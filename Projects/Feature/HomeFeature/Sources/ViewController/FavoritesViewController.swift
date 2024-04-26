import UIKit
import Domain

import Core
import DesignSystem

import RxSwift
import RxCocoa

public final class FavoritesViewController: UIViewController {
    private let viewModel: FavoritesViewModel
    
    private let headerTapEvent = PublishSubject<String>()
    private let alarmBtnTapEvent = PublishSubject<IndexPath>()
    private let scrollReachedBtmEvent = PublishSubject<Void>()
    private let isTableViewEditMode = BehaviorSubject(value: false)
    private let disposeBag = DisposeBag()
    
    private var dataSource: FavoritesDataSource!
    private var snapshot: FavoritesSnapshot!
    private var headerInfoList: [[String: String]] = []
    private let refreshAttribute: AttributeContainer = {
        var titleContainer = AttributeContainer()
        titleContainer.font = .systemFont(ofSize: 14)
        return titleContainer
    }()
    
    private let searchBtn: SearchBusStopBtn = {
        let searchBtn = SearchBusStopBtn(
            title: "버스 정류장을 검색하세요",
            image: UIImage(systemName: "magnifyingglass")
        )
        searchBtn.accessibilityIdentifier = "홈에서 검색뷰로 네비게이션"
        return searchBtn
    }()
    
    private lazy var refreshBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .black
        config.imagePadding = 6
        // Image
        let image = UIImage(systemName: "arrow.triangle.2.circlepath")
        let imgConfig = UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 11)
        )
        config.image = image
        config.preferredSymbolConfigurationForImage = imgConfig
        // Title
        let timeStr = Date().toString(dateFormat: "HH:mm")
        config.attributedTitle = AttributedString(
            "\(timeStr) 업데이트",
            attributes: refreshAttribute
        )
        let button = UIButton(configuration: config)
        return button
    }()
    
    private lazy var favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(FavoritesHeaderView.self)
        tableView.register(FavoritesTVCell.self)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.sectionHeaderTopPadding = 0
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: 15,
            bottom: 0,
            right: 15
        )
        return tableView
    }()
    
    public init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureUI()
        bind()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(
            true,
            animated: true
        )
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        [
            searchBtn,
            refreshBtn,
            favoritesTableView
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            searchBtn.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: 10
            ),
            searchBtn.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            searchBtn.widthAnchor.constraint(
                equalTo: safeArea.widthAnchor,
                multiplier: 0.95
            ),
            
            refreshBtn.topAnchor.constraint(
                equalTo: searchBtn.bottomAnchor,
                constant: 10
            ),
            refreshBtn.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 5
            ),
            
            favoritesTableView.topAnchor.constraint(
                equalTo: refreshBtn.bottomAnchor,
                constant: 3
            ),
            favoritesTableView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 10
            ),
            favoritesTableView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -10
            ),
            favoritesTableView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor
            ),
        ])
    }
    
    private func bind() {
        let refreshControl = favoritesTableView.enableRefreshControl(
            refreshStr: ""
        )
        
        let output = viewModel.transform(
            input: .init(
                viewWillAppearEvent: rx
                    .methodInvoked(
                        #selector(UIViewController.viewWillAppear)
                    )
                    .map { _ in },
                searchBtnTapEvent: searchBtn.rx.tap.asObservable(),
                refreshBtnTapEvent: Observable.merge(
                    refreshControl.rx.controlEvent(.valueChanged)
                        .asObservable(),
                    refreshBtn.rx.tap.asObservable()
                ),
                alarmBtnTapEvent: alarmBtnTapEvent.asObservable(),
                busStopTapEvent: headerTapEvent,
                scrollReachedBtmEvent: scrollReachedBtmEvent
            )
        )
        
        Observable.combineLatest(
            output.distanceFromTimerStart,
            output.busStopArrivalInfoResponse
        )
        .withUnretained(self)
        .observe(on: MainScheduler.asyncInstance)
        .subscribe(
            onNext: { viewController, tuple in
                let (timerValue, responses) = tuple
                let newResponses = responses.map {
                    return $0.replaceTime(timerSecond: timerValue)
                }
                viewController.headerInfoList.removeAll()
                newResponses.forEach { response in
                    viewController.updateHeaderInfo(
                        name: response.busStopName,
                        direction: response.direction,
                        busStopId: response.busStopId
                    )
                }
                viewController.updateSnapshot(busStopResponse: newResponses)
            }
        )
        .disposed(by: disposeBag)
        
        output.fetchStatus
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                onNext: { state in
                    switch state {
                    case .firstFetching, .nextFetching, .fakeFetching:
                        refreshControl.beginRefreshing()
                    case .fetchComplete, .finalPage:
                        refreshControl.endRefreshing()
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() {
        dataSource = .init(
            tableView: favoritesTableView
        ) { [weak self] tableView, indexPath, response in
            guard let self else { return UITableViewCell() }
            let cell = self.configureCell(
                tableView: tableView,
                indexPath: indexPath,
                response: response
            )
            cell?.selectionStyle = .none
            cell?.alarmBtn.rx.tap
                .map { _ in indexPath }
                .bind(to: self.alarmBtnTapEvent)
                .disposed(by: self.disposeBag)
            return cell
        }
    }
    
    private func configureCell(
        tableView: UITableView,
        indexPath: IndexPath,
        response: BusArrivalInfoResponse
    ) -> FavoritesTVCell? {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoritesTVCell.identifier,
            for: indexPath
        ) as? FavoritesTVCell
        let isLastCell = tableView.numberOfRows(
            inSection: indexPath.section
        ) - 1 == indexPath.row
        if isLastCell {
            cell?.addCornerRadius(
                corners: [.bottomLeft, .bottomRight]
            )
        }
        cell?.updateUI(response: response)
        return cell
    }
    
    private func updateHeaderInfo(
        name: String,
        direction: String,
        busStopId: String
    ) {
        headerInfoList += [
            [
                "name": name,
                "direction": direction,
                "busStopId": busStopId
            ]
        ]
    }
    
    private func updateSnapshot(busStopResponse: [BusStopArrivalInfoResponse]) {
        if busStopResponse.isEmpty {
            favoritesTableView.backgroundView = EmptyFavoritesView()
            refreshBtn.isHidden = true
        } else {
            favoritesTableView.backgroundView = nil
            refreshBtn.isHidden = false
        }
        snapshot = .init()
        snapshot.appendSections(busStopResponse)
        busStopResponse.forEach { response in
            snapshot.appendItems(
                response.buses, 
                toSection: response
            )
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension FavoritesViewController: UITableViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >
            scrollView.contentSize.height - scrollView.bounds.height {
            scrollReachedBtmEvent.onNext(())
        }
    }
    
    public func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    public func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        60
    }
    
    public func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        60
    }
    
    public func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        15
    }
    
    public func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: FavoritesHeaderView.identifier
        ) as? FavoritesHeaderView
        else { return .init() }
        if section < headerInfoList.count {
            header.updateUI(
                name: headerInfoList[section]["name"],
                direction: headerInfoList[section]["direction"]
            )
        }
        guard let busStopId = headerInfoList[section]["busStopId"]
        else { return header }
        let tapGesture = UITapGestureRecognizer()
        header.contentView.addGestureRecognizer(tapGesture)
        header.disposeBag = .init()
        tapGesture.rx.event
            .map { _ in busStopId }
            .bind(to: headerTapEvent)
            .disposed(by: header.disposeBag)
        return header
    }
}

extension FavoritesViewController {
    typealias FavoritesDataSource =
    UITableViewDiffableDataSource
    <BusStopArrivalInfoResponse, BusArrivalInfoResponse>
    
    typealias FavoritesSnapshot =
    NSDiffableDataSourceSnapshot
    <BusStopArrivalInfoResponse, BusArrivalInfoResponse>
}
