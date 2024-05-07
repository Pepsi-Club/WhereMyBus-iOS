import UIKit

import Domain
import Core
import DesignSystem

import RxSwift
import RxCocoa

public final class SearchViewController: UIViewController {
    private let viewModel: SearchViewModel
    
    private let removeBtnTapEvent = PublishSubject<Void>()
    private let cellTapEvent = PublishSubject<BusStopInfoResponse>()
    private let mapBtnTapEvent = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    private var recentSearchDataSource: RecentSearchDataSource!
    private var searchedDataSource: SearchedDataSource!
    
    private let searchTextFieldView: SearchTextFieldView = {
        let textFieldView = SearchTextFieldView()
        textFieldView.accessibilityIdentifier = "정류장 검색"
        return textFieldView
    }()
    
    private let recentSearchBGView = SearchTVBackgroundView(
        text: "최근 검색된 정류장이 없습니다"
    )
    
    private let searchedStopBGView = SearchTVBackgroundView(
        text: "검색된 정류장이 없습니다"
    )
    
    private let recentSearchHeaderView = SearchTVHeaderView(
        title: "최근 검색 정류장",
        btnTitle: "삭제"
    )
    
    private lazy var recentSearchTableView: UITableView = {
        let table = UITableView(
            frame: .zero,
            style: .insetGrouped
        )
        table.register(SearchTVCell.self)
        table.backgroundColor = DesignSystemAsset.tableViewColor.color
        table.dataSource = recentSearchDataSource
        table.delegate = self
        table.accessibilityIdentifier = "최근검색"
        table.separatorInset = UIEdgeInsets(
            top: 0,
            left: 13,
            bottom: 0,
            right: 13
        )
        return table
    }()
    
    private lazy var searchedStopTableView: UITableView = {
        let table = UITableView(
            frame: .zero,
            style: .insetGrouped
        )
        table.register(SearchTVMapCell.self)
        table.backgroundColor = DesignSystemAsset.tableViewColor.color
        table.isHidden = true
        table.dataSource = searchedDataSource
        table.delegate = self
        table.accessibilityIdentifier = "검색결과"
        table.separatorInset = UIEdgeInsets(
            top: 0,
            left: 13,
            bottom: 0,
            right: 13
        )
        return table
    }()
    
    private let nearBusStopHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumBold(size: 16)
        label.textAlignment = .left
        label.textColor = DesignSystemAsset.settingColor.color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.text = "주변 정류장"
        return label
    }()
    
    private let nearByStopView = SearchNearStopInformationView()
    
    public init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDataSource()
        bind()
        hideKeyboardOnTapOrDrag()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
        nearByStopView.busStopImage.play()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(
            true,
            animated: true
        )
        searchTextFieldView.removeFromSuperview()
    }
    
    private func hideKeyboardOnTapOrDrag() {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .withUnretained(self)
            .subscribe(
                onNext: { vc, _ in
                    vc.searchTextFieldView.endEditing(true)
                }
            )
            .disposed(by: disposeBag)
        recentSearchTableView.keyboardDismissMode = .onDrag
        searchedStopTableView.keyboardDismissMode = .onDrag
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        [
            recentSearchHeaderView,
            nearByStopView,
            recentSearchTableView,
            searchedStopTableView,
            nearBusStopHeaderLabel,
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            nearBusStopHeaderLabel.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -200
            ),
            nearBusStopHeaderLabel.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 15
            ),
            nearBusStopHeaderLabel.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -15
            ),
            
            nearByStopView.topAnchor.constraint(
                equalTo: nearBusStopHeaderLabel.bottomAnchor,
                constant: 15
            ),
            nearByStopView.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            nearByStopView.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.95
            ),
            
            recentSearchHeaderView.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: 10
            ),
            recentSearchHeaderView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 5
            ),
            recentSearchHeaderView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -5
            ),
            
            recentSearchTableView.topAnchor.constraint(
                equalTo: recentSearchHeaderView.bottomAnchor
            ),
            recentSearchTableView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            recentSearchTableView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            recentSearchTableView.bottomAnchor.constraint(
                equalTo: nearBusStopHeaderLabel.topAnchor,
                constant: -20
            ),
            
            searchedStopTableView.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: 10
            ),
            searchedStopTableView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            searchedStopTableView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            searchedStopTableView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor
            ),
        ])
    }
    
    private func configureNavigation() {
        if navigationController?.isNavigationBarHidden == true {
            navigationController?.setNavigationBarHidden(
                false,
                animated: true
            )
        }
        
        guard let navigationView = navigationController?.navigationBar
        else { return }
        navigationView.addSubview(searchTextFieldView)
        searchTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextFieldView.topAnchor.constraint(
                equalTo: navigationView.topAnchor,
                constant: 5
            ),
            searchTextFieldView.trailingAnchor.constraint(
                equalTo: navigationView.trailingAnchor,
                constant: -10
            ),
            searchTextFieldView.widthAnchor.constraint(
                equalTo: navigationView.widthAnchor,
                multiplier: 0.85
            ),
            searchTextFieldView.heightAnchor.constraint(
                equalTo: navigationView.heightAnchor,
                multiplier: 0.9
            )
        ])
    }
    
    private func bind() {
        let nearByStopTapGesture = UITapGestureRecognizer()
        nearByStopView.addGestureRecognizer(nearByStopTapGesture)
        
        let input = SearchViewModel.Input(
            viewWillAppearEvent: rx.methodInvoked(
                #selector(UIViewController.viewWillAppear)
            ).map { _ in },
            textFieldChangeEvent: searchTextFieldView.rx.text
                .orEmpty
                .skip(1)
                .asObservable(),
            removeBtnTapEvent: removeBtnTapEvent,
            nearByStopTapEvent: nearByStopTapGesture.rx.event.map { _ in },
            cellTapEvent: cellTapEvent,
            mapBtnTapEvent: mapBtnTapEvent
        )
        
        let output = viewModel.transform(input: input)
        
        output.recentSearchedResponse
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, responses in
                    viewController.updateRecentSearchSnapshot(
                        responses: responses
                    )
                }
            )
            .disposed(by: disposeBag)
        
        output.nearByStopInfo
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, tuple in
                    let (response, distance) = tuple
                    viewController.nearByStopView.updateUI(
                        busStopName: response.busStopName,
                        distance: distance
                    )
                }
            )
            .disposed(by: disposeBag)
        
        output.searchedResponse
            .withUnretained(self)
            .subscribe(
                onNext: { vc, regions in
                    vc.updateSearchedSnapshot(regions: regions)
                }
            )
            .disposed(by: disposeBag)
        
        searchTextFieldView.rx
            .controlEvent(.editingChanged)
            .withUnretained(self)
            .subscribe(
                onNext: { vc, _ in
                    guard let text = vc.searchTextFieldView.text
                    else { return }
                    vc.searchedStopTableView.isHidden = text.isEmpty
                    if text.isEmpty { 
                        vc.nearBusStopHeaderLabel.isHidden = false
                    } else {
                        vc.nearBusStopHeaderLabel.isHidden = true
                    }
                }
            )
            .disposed(by: disposeBag)
        
        recentSearchHeaderView.actionBtnTapEvent
            .bind(to: removeBtnTapEvent)
            .disposed(by: recentSearchHeaderView.disposeBag)
    }
    
    private func configureDataSource() {
        configureRecentSearchDataSource()
        configureSearchedDataSource()
    }
    
    private func configureRecentSearchDataSource() {
        recentSearchDataSource = .init(
            tableView: recentSearchTableView
        ) { [weak self] tableView, indexPath, response in
            guard let self,
                  let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchTVCell.identifier,
                    for: indexPath
                  ) as? SearchTVCell
            else { return .init() }
            cell.updateUI(
                response: response,
                searchKeyword: self.searchTextFieldView.text ?? ""
            )
            cell.cellTapEvent
                .bind(to: self.cellTapEvent)
                .disposed(by: cell.disposeBag)
            return cell
        }
    }
    
    private func configureSearchedDataSource() {
        searchedDataSource = .init(
            tableView: searchedStopTableView
        ) { [weak self] tableView, indexPath, response in
            guard let self,
                  let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchTVMapCell.identifier,
                    for: indexPath
                  ) as? SearchTVMapCell
            else { return .init() }
            cell.updateUI(
                response: response,
                searchKeyword: self.searchTextFieldView.text ?? ""
            )
            cell.cellTapEvent
                .bind(to: self.cellTapEvent)
                .disposed(by: cell.disposeBag)
            cell.mapBtnTapEvent
                .bind(to: self.mapBtnTapEvent)
                .disposed(by: cell.disposeBag)
            return cell
        }
    }
    
    private func updateRecentSearchSnapshot(
        responses: [BusStopInfoResponse]
    ) {
        var snapshot = RecentSearchSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(
            responses,
            toSection: 0
        )
        recentSearchDataSource.apply(
            snapshot,
            animatingDifferences: false
        )
        switch responses.isEmpty {
        case true:
            recentSearchTableView.backgroundView = recentSearchBGView
        case false:
            recentSearchTableView.backgroundView = nil
        }
    }
    
    private func updateSearchedSnapshot(
        regions: [BusStopRegion]
    ) {
        var snapshot = SearchedSnapshot()
        snapshot.appendSections(regions)
        regions.forEach { region in
            switch region {
            case .seoul(let responses):
                snapshot.appendItems(
                    responses,
                    toSection: region
                )
            }
        }
        searchedDataSource.apply(
            snapshot,
            animatingDifferences: false
        )
        switch snapshot.numberOfItems == 0 {
        case true:
            searchedStopTableView.backgroundView = searchedStopBGView
        case false:
            searchedStopTableView.backgroundView = nil
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        var headerView: UIView?
        if tableView === searchedStopTableView {
            switch section {
            case 0:
                headerView = SearchTVHeaderView(
                    title: "서울"
                )
            default:
                break
            }
        }
        return headerView
    }
}

extension SearchViewController {
    typealias RecentSearchDataSource =
    UITableViewDiffableDataSource<Int, BusStopInfoResponse>
    typealias RecentSearchSnapshot =
    NSDiffableDataSourceSnapshot<Int, BusStopInfoResponse>
    typealias SearchedDataSource =
    UITableViewDiffableDataSource<BusStopRegion, BusStopInfoResponse>
    typealias SearchedSnapshot =
    NSDiffableDataSourceSnapshot<BusStopRegion, BusStopInfoResponse>
}
