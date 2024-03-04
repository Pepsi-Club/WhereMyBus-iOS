import UIKit
import Domain

import Core
import DesignSystem

import RxSwift
import RxCocoa

public final class SearchViewController: UIViewController, UITableViewDelegate {
    private let viewModel: SearchViewModel
    
    private let disposeBag = DisposeBag()
    private let searchEnterEvent = PublishSubject<String>()
    private let searchTapEvent = PublishSubject<IndexPath>()
    // 주변 정류장 클릭했을 때 나오는 이벤트
    
    private let recentSerachCell = RecentSearchCell()
    private let searchNearStopView = SearchNearStopView()
    private let searchTextFieldView = SearchTextFieldView()

    private var dataSource: SearchDataSource!
    private var snapshot: SearchDataSource! //
    
    private let backBtn: UIButton = {
        let btn = UIButton()
        let starImage = UIImage(systemName: "chevron.backward")
        btn.setImage(starImage, for: .normal)
        btn.tintColor = .black
        //        btn.backgroundColor = .red
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
    
    private let magniImage: UIImageView = {
        let symbolName = "magnifyingglass"
        let migImageView = UIImageView()
        var configuration = UIImage.SymbolConfiguration(pointSize: 8,
                                                        weight: .light)
        configuration = configuration.applying(
            UIImage.SymbolConfiguration(
                font: UIFont.systemFont(ofSize: 20, weight: .light),
                scale: .default
            )
        )
        let migImage = UIImage(
             systemName: symbolName,
             withConfiguration: configuration
        )?.withTintColor(.black)
        
        return migImageView
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
        configureDataSource()
        configureUI()
        bind()
       }
    
    private func configureUI() {
        view.backgroundColor = .white

        [searchTextFieldView, backBtn, textFieldStack, recentSearchlabel,
         recentSearchTableView, coloredRectangleView, searchNearStopView,
         editBtn, headerStack, magniStack, magniImage]
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
        
        magniImage.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: -5
            ),
        
        magniImage.widthAnchor.constraint(
                equalToConstant: 20
            ),
        
        magniImage.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            
        searchTextFieldView.heightAnchor.constraint(
                equalToConstant: 39),
           
        textFieldStack.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: -14
            ),
        textFieldStack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 10
            ),
        
        textFieldStack.trailingAnchor.constraint(
            equalTo: magniImage.trailingAnchor,
            constant: 10
            ),
        
        headerStack.topAnchor.constraint(
                equalTo: textFieldStack.bottomAnchor, constant: 15),
        headerStack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 15),
        headerStack.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -15),
     
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
                                    constant: 10)
   
           ])
    }
    
    private func bind() {
   
    }
    
    private func configureDataSource() {
        dataSource = .init(
            tableView: recentSearchTableView,
            cellProvider: { [weak self] tableView, indexPath, response
                in guard let self else { return UITableViewCell() }
                
                let cell = self.configureCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    response: response)
                
                return cell })
    }
    
    // MARK: 다시해야하는구간
    private func configureCell(
        tableView: UITableView,
        indexPath: IndexPath,
        response: BusArrivalInfoResponse) -> RecentSearchCell? {
            guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecentSearchCell.identifier,
            for: indexPath
        ) as? RecentSearchCell
            else { return nil }
            let msg1 = response.busName
            let msg2 = response.busId
            
            return cell
    }
}

extension SearchViewController {
    typealias SearchDataSource =
    UITableViewDiffableDataSource
    <BusStopArrivalInfoResponse, BusArrivalInfoResponse>
}
