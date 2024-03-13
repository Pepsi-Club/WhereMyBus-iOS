import UIKit

import Core
import DesignSystem
import Domain

import RxSwift
import RxCocoa

public final class AfterSearchViewController
: UIViewController, UITableViewDelegate {
    private let viewModel: AfterSearchViewModel
    
    private let disposeBag = DisposeBag()
    
    private let backBtnTapEvent = PublishSubject<Void>()
    private let cellTapEvent = PublishSubject<Void>()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let searchTextFieldView = SearchTextFieldView()
    private let recentSerachCell = RecentSearchCell()
    
    private var dataSource: AfterSearchDataSource!
    private var snapshot: AfterSearchDataSource!
    
    private let backBtn: UIButton = {
        let btn = UIButton()
        let starImage = UIImage(systemName: "chevron.backward")?
            .withConfiguration(UIImage.SymbolConfiguration(
                pointSize: 20,
                weight: .bold)
            )
        btn.setImage(starImage, for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private let recentSearchlabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 15)
        label.textColor = DesignSystemAsset.gray4.color
        label.text = "서울"
        
        return label
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
    
    private lazy var afterSearchResultTableView: UITableView = {
            let table = UITableView(frame: .zero, style: .insetGrouped)
            table.register(RecentSearchCell.self)
            table.dataSource = dataSource
            table.delegate = self
            table.tableHeaderView = searchController.searchBar
            return table
        }()
   
    
    public init(viewModel: AfterSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        bind()
        configureDataSource()
        hideKeyboard()

        view.backgroundColor = .systemBackground
        
        [searchTextFieldView, backBtn, textFieldStack, recentSearchlabel,
         coloredRectangleView,
         headerStack, magniStack, afterSearchResultTableView]
            .forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        [backBtn, searchTextFieldView]
            .forEach { components in
                textFieldStack.addArrangedSubview(components)
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
                equalTo: view.leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -15),
        ])
    }
    
    private func bind() {
        let input = AfterSearchViewModel.Input(
            viewWillAppearEvenet: rx
                .methodInvoked(#selector(UIViewController.viewWillAppear))
                .map { _ in },
            backBtnTapEvent: backBtnTapEvent.asObservable(),
            cellTapEvent: Observable<String>,
            )
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
    
    private func configureDataSource() {
        dataSource = .init(
            tableView: afterSearchResultTableView,
            cellProvider: { [weak self] tableView, indexPath, response in
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
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = ""
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension AfterSearchViewController {
    typealias AfterSearchDataSource =
    UITableViewDiffableDataSource
    <Int, BusStopInfoResponse>
}

extension AfterSearchViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased()
        else { return }
    // self.filteredList = self.arr.filter { $0.localizedCaseInsensitiveContains(text) }
        
    
        // self.tableView.reloadData()
    }
}
