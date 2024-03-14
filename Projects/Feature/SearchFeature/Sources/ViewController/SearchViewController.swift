import UIKit

import Domain
import Core
import DesignSystem

import RxSwift
import RxCocoa

public final class SearchViewController: UIViewController {
    private let viewModel: SearchViewModel
    
    private let nearBusStopTapEvent = PublishSubject<Void>()
    private let cellTapEvent = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    private let searchNearStopView = DeagreeSearchNearStopView()
    private let searchTextFieldView = SearchTextFieldView()
    
    private var dataSource: SearchDataSource!
    
    private let recentSearchlabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 15)
        label.textColor = .black
        label.text = "최근 검색 정류장"
        return label
    }()
    
    private let removeBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = DesignSystemAsset.gray5.color
        var titleContainer = AttributeContainer()
        titleContainer.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 15)
        config.attributedTitle = AttributedString( 
            "삭제",
            attributes: titleContainer
        )
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let coloredRectangleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(
            red: 230/255,
            green: 237/255,
            blue: 255/255,
            alpha: 1.0
        )
        return view
    }()
    
    private let tvBackgroundView = RecentSearchBackgroundView()
    
    private lazy var recentSearchTableView: UITableView = {
        let table = UITableView(
            frame: .zero,
            style: .insetGrouped
        )
        table.register(RecentSearchCell.self)
        table.dataSource = dataSource
        return table
    }()
    
    private var tableViewBtmConstraint: NSLayoutConstraint!
    
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
        hideKeyboard()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        configureNavigation()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        searchTextFieldView.removeFromSuperview()
    }
    
    private func configureNavigation() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backItem?.title = ""
        
        guard let navigationView = navigationController?.navigationBar
        else { return }
        navigationView.addSubview(searchTextFieldView)
        searchTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextFieldView.trailingAnchor.constraint(
                equalTo: navigationView.trailingAnchor,
                constant: -10
            ),
            searchTextFieldView.widthAnchor.constraint(
                equalTo: navigationView.widthAnchor,
                multiplier: 0.9
            ),
            searchTextFieldView.heightAnchor.constraint(
                equalTo: navigationView.heightAnchor,
                multiplier: 0.9
            )
        ])
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        [
            recentSearchlabel,
            removeBtn,
            coloredRectangleView,
            searchNearStopView,
            recentSearchTableView,
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        tableViewBtmConstraint = recentSearchTableView.bottomAnchor.constraint(
            equalTo: coloredRectangleView.topAnchor
        )
        NSLayoutConstraint.activate([
            recentSearchlabel.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: 15
            ),
            recentSearchlabel.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 15
            ),
            recentSearchlabel.heightAnchor.constraint(
                equalToConstant: 15
            ),
            
            removeBtn.centerYAnchor.constraint(
                equalTo: recentSearchlabel.centerYAnchor
            ),
            removeBtn.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -10
            ),
            
            coloredRectangleView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -200
            ),
            coloredRectangleView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            coloredRectangleView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            
            searchNearStopView.topAnchor.constraint(
                equalTo: coloredRectangleView.topAnchor,
                constant: 10
            ),
            searchNearStopView.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            searchNearStopView.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.95
            ),
            searchNearStopView.heightAnchor.constraint(
                equalToConstant: 87
            ),
            searchNearStopView.bottomAnchor.constraint(
                equalTo: coloredRectangleView.bottomAnchor,
                constant: -10
            ),
            
            recentSearchTableView.topAnchor.constraint(
                equalTo: recentSearchlabel.bottomAnchor,
                constant: 10
            ),
            recentSearchTableView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            recentSearchTableView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            tableViewBtmConstraint,
        ])
    }
    
    private func bind() {
        let input = SearchViewModel.Input(
            viewWillAppearEvenet: rx
                .methodInvoked(#selector(UIViewController.viewWillAppear))
                .map { _ in },
            enterPressedEvent: searchTextFieldView.rx.text
                .orEmpty
                .asObservable(),
            removeBtnTapEvent: removeBtn.rx.tap.asObservable(),
            nearBusStopTapEvent: nearBusStopTapEvent.asObservable(),
            cellTapEvent: cellTapEvent
        )
        
        let output = viewModel.transform(input: input)
        
        output.recentSearchResultResponse
            .filter { _ in
                output.tableViewSection.value == .recentSearch
            }
            .withLatestFrom(output.tableViewSection) { responses, section in
                (responses, section)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, tuple in
                    let (responses, section) = tuple
                    viewController.updateSnapshot(
                        section: section,
                        responses: responses
                    )
                }
            )
            .disposed(by: disposeBag)
        
        output.searchedResponse
            .filter { _ in
                output.tableViewSection.value == .searchedData
            }
            .withLatestFrom(output.tableViewSection) { responses, section in
                (responses, section)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, tuple in
                    let (responses, section) = tuple
                    viewController.updateSnapshot(
                        section: section,
                        responses: responses
                    )
                }
            )
            .disposed(by: disposeBag)
        
        output.tableViewSection
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, section in
                    viewController.tableViewBtmConstraint.isActive = false
                    switch section {
                    case .recentSearch:
                        if viewController.recentSearchTableView.cellForRow(
                            at: .init(
                                row: 0,
                                section: 0
                            )
                        ) == nil {
                            viewController.recentSearchTableView.backgroundView
                            = viewController.tvBackgroundView
                        } else {
                            viewController.recentSearchTableView.backgroundView
                            = nil
                        }
                        viewController.tableViewBtmConstraint
                        = viewController.recentSearchTableView.bottomAnchor
                            .constraint(
                                equalTo: viewController.coloredRectangleView
                                    .topAnchor
                            )
                    case .searchedData:
                        viewController.recentSearchTableView.backgroundView
                        = nil
                        viewController.tableViewBtmConstraint
                        = viewController.recentSearchTableView.bottomAnchor
                            .constraint(
                                equalTo: viewController.view.safeAreaLayoutGuide
                                    .bottomAnchor
                            )
                    }
                    viewController.tableViewBtmConstraint.isActive = true
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() {
        dataSource = .init(
            tableView: recentSearchTableView,
            cellProvider: { [weak self] tableView, indexPath, response in
                guard let self,
                      let cell = tableView.dequeueReusableCell(
                        withIdentifier: RecentSearchCell.identifier,
                        for: indexPath
                      ) as? RecentSearchCell
                else { return .init() }
                cell.updateUI(response: response)
                let tapGesture = UITapGestureRecognizer()
                cell.addGestureRecognizer(tapGesture)
                tapGesture.rx.event
                    .map { _ in
                        response.busStopId
                    }
                    .withUnretained(self)
                    .subscribe(
                        onNext: { viewController, busStopId in
                            viewController.cellTapEvent.onNext(busStopId)
                        }
                    )
                    .disposed(by: cell.disposeBag)
                return cell
            }
        )
    }
    
    private func updateSnapshot(
        section: SearchSection,
        responses: [BusStopInfoResponse]
    ) {
        var snapshot = SearchSnapshot()
        snapshot.appendSections([section])
        snapshot.appendItems(
            responses,
            toSection: section
        )
        dataSource.apply(
            snapshot,
            animatingDifferences: false
        )
    }
}

extension SearchViewController {
    typealias SearchDataSource =
    UITableViewDiffableDataSource<SearchSection, BusStopInfoResponse>
    typealias SearchSnapshot =
    NSDiffableDataSourceSnapshot<SearchSection, BusStopInfoResponse>
}

enum SearchSection: CaseIterable {
    case recentSearch, searchedData
}
