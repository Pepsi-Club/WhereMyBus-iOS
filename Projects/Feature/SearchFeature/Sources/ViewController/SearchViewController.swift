import UIKit

import Core
import DesignSystem

import RxSwift
import RxCocoa
import RxDataSources

public final class SearchViewController: UIViewController {
    private let viewModel: SearchViewModel

   // private lazy var recentSearchView = RecentSearchView()
   // private lazy var afterSearchView = AfterSearchView()

    private let disposeBag = DisposeBag()
    private let searchTapEvent = PublishSubject<String>()

    private let searchBtn = SearchBusStopBtn(
        title: "버스 정류장을 검색하세요",
        image: UIImage(systemName: "magnifyingglass")
    )

    public init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let tableView = UITableView()
        //tableView.register(RecentSearchView.self,
        //forHeaderFooterViewReuseIdentifier: "RecentSearchView")

        tableView.tableHeaderView = searchBtn
        tableView.tableFooterView = UIView()
//        tableView.delegate = self
// tableView.dataSource = self

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0 //edit
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    }
//
//    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            // return recentSearchView
//        } else {
//           // return afterSearchView
//        }
//    }
//
//    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 100
//    }
//}
