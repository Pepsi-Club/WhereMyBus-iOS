import UIKit

import Domain
import Core
import DesignSystem

import RxSwift
import RxCocoa

public final class SearchViewController: UIViewController, UITableViewDelegate {
    private let viewModel: SearchViewModel
    
    private let disposeBag = DisposeBag()
    
    private let infoAgreeEvent = BehaviorSubject<Bool>(value: false)
    private let enterPressedEvent = PublishSubject<String>()
    private let backBtnTapEvent = PublishSubject<Void>()
    private let nearBusStopTapEvent = PublishSubject<Void>()
    
    private let recentSerachCell = RecentSearchCell()
    private let searchNearStopView = DeagreeSearchNearStopView()
    private let searchTextFieldView = SearchTextFieldView()
    
    private var dataSource: SearchDataSource!
    private var snapshot: SearchDataSource! //
    
    private var filteredList: [String] = []
    
    private let backBtn: UIButton = {
        let btn = UIButton()
        
        if let originalImage = UIImage(systemName: "chevron.backward") {
            let boldAndLargeImage = originalImage.withConfiguration(
                UIImage.SymbolConfiguration(
                    pointSize: 20,
                    weight: .regular
                )
            )
            btn.setImage(boldAndLargeImage, for: .normal)
        }
        
        btn.tintColor = .black
        return btn
    }()
    
    private let recentSearchlabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 15)
        label.textColor = .black
        label.text = "최근 검색 정류장"
        
        return label
    }()
    
    private let editBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = DesignSystemAsset.gray5.color
        var titleContainer = AttributeContainer()
        titleContainer.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 15)
        config.attributedTitle = AttributedString( "삭제",
                                                   attributes: titleContainer
        )
        
        let button = UIButton(configuration: config)
        
        return button
    }()
    
    private let coloredRectangleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255,
                                       green: 237/255,
                                       blue: 255/255,
                                       alpha: 1.0)
        return view
    }()
    
    private let textFieldStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        
        return stack
    }()
    
    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 100
        stack.distribution = .fill
        
        return stack
    }()
    
    private let magniStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 100
        
        return stack
    }()
    
    private lazy var recentSearchTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(RecentSearchCell.self)
        table.dataSource = dataSource
        table.delegate = self
        
        return table
    }()
    
    public init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // 정신차려라
        searchTextFieldView.delegate = self
        
        configureUI()
        bind()
        configureDataSource()
        hideKeyboard()
        
        // MARK: snapShot 여기다 두면 안될 거 같음
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.main])
        
        viewModel.useCase.recentSearchResult
            .subscribe(onNext: { [weak self] recentSearchResult in
                snapshot.appendItems(recentSearchResult)
                self?.dataSource.apply(snapshot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        // setupSearchController()
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = ""
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        [searchTextFieldView, backBtn, textFieldStack, recentSearchlabel,
         recentSearchTableView, coloredRectangleView, searchNearStopView,
         editBtn, headerStack, magniStack]
            .forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        [backBtn, searchTextFieldView]
            .forEach { components in
                textFieldStack.addArrangedSubview(components)
            }
        
        [recentSearchlabel, editBtn]
            .forEach { components in
                headerStack.addArrangedSubview(components)
            }
        
        NSLayoutConstraint.activate([
            
            backBtn.widthAnchor.constraint(equalToConstant: 20),
            
            searchTextFieldView.heightAnchor.constraint(
                equalToConstant: 39),
            
            textFieldStack.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 0
            ),
            textFieldStack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 10
            ),
            
            textFieldStack.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -10
            ),
            
            headerStack.topAnchor.constraint(
                equalTo: textFieldStack.bottomAnchor, constant: 15),
            headerStack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 15),
            headerStack.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -10),
            
            recentSearchTableView.topAnchor.constraint(
                equalTo: recentSearchlabel.bottomAnchor, constant: -30),
            recentSearchTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            recentSearchTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            
            recentSearchTableView.widthAnchor.constraint(
                equalTo: view.widthAnchor),
            
            coloredRectangleView.topAnchor.constraint(
                equalTo: recentSearchTableView.bottomAnchor,
                constant: 300),
            coloredRectangleView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 0),
            coloredRectangleView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: 0),
            coloredRectangleView.widthAnchor.constraint(
                equalToConstant: .screenWidth),
            
            searchNearStopView.topAnchor.constraint(
                equalTo: coloredRectangleView.topAnchor,
                constant: 10),
            searchNearStopView.bottomAnchor.constraint(
                equalTo: coloredRectangleView.bottomAnchor,
                constant: -10),
            searchNearStopView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 10),
            searchNearStopView.heightAnchor.constraint(
                equalToConstant: 87),
            searchNearStopView.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.95),
            searchNearStopView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: 10
            )
        ])
    }
    
    private func bind() {
        let input = SearchViewModel.Input(
            viewWillAppearEvenet: rx
                .methodInvoked(#selector(UIViewController.viewWillAppear))
                .map { _ in },
            enterPressedEvent: enterPressedEvent.asObservable(),
            backbtnEvent: backBtnTapEvent.asObservable(),
            nearBusStopTapEvent: nearBusStopTapEvent.asObservable())
        
        _ = viewModel.transform(input: input)
    }
    
    private func bindText() {
        searchTextFieldView.rx.controlEvent([.editingDidEndOnExit])
            .map({ _ in
                return self.searchTextFieldView.text ?? "안들어옴"
            })
            .bind(to: enterPressedEvent)
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() {
        dataSource = .init(
            tableView: recentSearchTableView,
            cellProvider: { [weak self] tableView, indexPath, response
                in
                guard let self = self,
                      let cell = self.configureCell(
                        tableView: tableView,
                        indexPath: indexPath,
                        response: response
                      )
                else { return UITableViewCell() }
                
                return cell
            })
    }
    
    private func configureCell(
        tableView: UITableView,
        indexPath: IndexPath,
        response: BusStopInfoResponse
    ) -> RecentSearchCell? {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecentSearchCell.identifier,
            for: indexPath
        ) as? RecentSearchCell
                
        else { return nil }
        
        cell.busStopNameLabel.text = response.busStopName
        cell.dircetionLabel.text = response.direction
        cell.numberLabel.text = response.busStopId
        
        return cell
    }
}

extension SearchViewController {
    typealias SearchDataSource =
    UITableViewDiffableDataSource
    <Section, BusStopInfoResponse>
}

extension SearchViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("입력완료")
        bindText()
        print("bindText실행됨")
        
        return true
    }
}

enum Section: CaseIterable { case main }
