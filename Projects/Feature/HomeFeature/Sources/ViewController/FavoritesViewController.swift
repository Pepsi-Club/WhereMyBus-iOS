import UIKit
import Domain

import Core
import DesignSystem

import RxSwift
import RxCocoa
import RxDataSources

public final class FavoritesViewController: UIViewController {
    typealias FavoritesDataSource =
    RxTableViewSectionedReloadDataSource<ArrivalInfoResponse>
    private let viewModel: FavoritesViewModel
    
    private let disposeBag = DisposeBag()
    private let headerTapEvent = PublishSubject<Int>()
    private let likeBtnTapEvent = PublishSubject<IndexPath>()
    private let alarmBtnTapEvent = PublishSubject<IndexPath>()
    
    private let busIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DesignSystemAsset.bus.image
        return imageView
    }()
    
    private let searchBtn = SearchBusStopBtn(
        title: "버스 정류장을 검색하세요",
        image: UIImage(systemName: "magnifyingglass")
    )
    
    private let refreshBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .black
        config.imagePadding = 5
        // MARK: Image
        let image = UIImage(systemName: "arrow.triangle.2.circlepath")
        let imgConfig = UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 13)
        )
        config.image = image
        config.preferredSymbolConfigurationForImage = imgConfig
        // MARK: Title
        var titleContainer = AttributeContainer()
        titleContainer.font = .systemFont(
            ofSize: 12
        )
        let timeStr = Date().toString(dateFormat: "HH:mm")
        config.attributedTitle = AttributedString(
            "\(timeStr) 업데이트",
            attributes: titleContainer
        )
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(FavoritesHeaderView.self)
        tableView.register(FavoritesTVCell.self)
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
        configureUI()
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        [busIconView, searchBtn, refreshBtn, favoritesTableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            busIconView.topAnchor.constraint(
                equalTo: safeArea.topAnchor
            ),
            busIconView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: .screenWidth * 0.1
            ),
            
            searchBtn.topAnchor.constraint(equalTo: busIconView.bottomAnchor),
            searchBtn.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            searchBtn.widthAnchor.constraint(
                equalTo: safeArea.widthAnchor,
                multiplier: 0.95
            ),
            
            refreshBtn.topAnchor.constraint(equalTo: searchBtn.bottomAnchor),
            refreshBtn.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            
            favoritesTableView.topAnchor.constraint(
                equalTo: refreshBtn.bottomAnchor
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
        let output = viewModel.transform(
            input: .init(
                viewWillAppearEvent: rx
                    .methodInvoked(#selector(UIViewController.viewWillAppear))
                    .map { _ in },
                searchBtnTapEvent: searchBtn.rx.tap.asObservable(),
                refreshBtnTapEvent: refreshBtn.rx.tap.asObservable(),
                likeBtnTapEvent: likeBtnTapEvent.asObservable(),
                alarmBtnTapEvent: alarmBtnTapEvent.asObservable(),
                busStopTapEvent: headerTapEvent
            )
        )
        
//        let dataSource = FavoritesDataSource
//        { dataSource, tableView, indexPath, item in
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: FavoritesTVCell.identifier,
//                for: indexPath
//            ) as? FavoritesTVCell ?? .init()
//            cell.updateUI(
//                routeName: item.routeName,
//                firstArrivalTime: item.firstArrivalTime,
//                firstArrivalRemaining: item.firstArrivalRemaining,
//                secondArrivalTime: item.secondArrivalTime,
//                secondArrivalRemaining: item.secondArrivalRemaining
//            )
//            return cell
//        }
        
//        output.arrivalInfoResponse.bind(
//            to: favoritesTableView.rx.items(
//                dataSource: dataSource
//            )
//        )
        
        output.arrivalInfoList
            .bind(
                to: favoritesTableView.rx.items(
                    cellIdentifier: FavoritesTVCell.identifier,
                    cellType: FavoritesTVCell.self
                ),
                curriedArgument: { _, item, cell in
                    cell.updateUI(
                        routeName: item.routeName,
                        firstArrivalTime: item.firstArrivalTime,
                        firstArrivalRemaining: item.firstArrivalRemaining,
                        secondArrivalTime: item.secondArrivalTime,
                        secondArrivalRemaining: item.secondArrivalRemaining
                    )
                }
            )
            .disposed(by: disposeBag)
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        2
    }
    
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoritesTVCell.identifier,
            for: indexPath
        ) as? FavoritesTVCell ?? .init()
        cell.alarmBtn.rx.tap
            .map { _ in indexPath }
            .bind(to: alarmBtnTapEvent)
            .disposed(by: disposeBag)
        cell.likeBtn.rx.tap
            .map { _ in indexPath }
            .bind(to: likeBtnTapEvent)
            .disposed(by: disposeBag)
        return cell
    }
    
    public func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let isLastCell = tableView.numberOfRows(
            inSection: indexPath.section
        ) - 1 == indexPath.row
        if isLastCell {
            cell.addCornerRadius(
                corners: [.bottomLeft, .bottomRight]
            )
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    public func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: FavoritesHeaderView.identifier
        ) as? FavoritesHeaderView
        header?.updateUI(name: "테스트", direction: "테스트")
        let tapGesture = UITapGestureRecognizer()
        header?.contentView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .map { _ in section }
            .bind(to: headerTapEvent)
            .disposed(by: disposeBag)
        return header
    }
}
