import UIKit

import Domain
import DesignSystem

import RxSwift

public final class BusStopViewController: UIViewController {
    private let viewModel: BusStopViewModel
    
    private let disposeBag = DisposeBag()
    private let mapBtnTapEvent = PublishSubject<BusStopArrivalInfoResponse>()
    private let likeBusBtnTapEvent = PublishSubject<BusArrivalInfoResponse>()
    private let alarmBtnTapEvent = PublishSubject<BusArrivalInfoResponse>()
    private let refresh = PublishSubject<Bool>()
    
    private var dataSource: BusStopDataSource!
    private var snapshot: BusStopSnapshot!
    
    private let headerView: BusStopInfoHeaderView = BusStopInfoHeaderView()
    private let scrollView: UIScrollView = UIScrollView()
    private let refreshControl = UIRefreshControl()
    private let contentView = UIView()
    private lazy var busStopTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(
            BusTableViewCell.self,
            forCellReuseIdentifier: BusTableViewCell.identifier
        )
        table.register(
            BusStopTVHeaderView.self,
            forHeaderFooterViewReuseIdentifier: BusStopTVHeaderView.identifier
        )
        table.delegate = self
        table.isScrollEnabled = false
        table.backgroundColor = .systemGray6
        return table
    }()
    
    private var tableViewHeightConstraint = NSLayoutConstraint()
    
    public init(viewModel: BusStopViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureUI()
        bind()
        configureDataSource()
        configureRefreshControl()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewHeightConstraint.constant = busStopTableView.contentSize.height
    }
    
    private func bind() {
        let input = BusStopViewModel.Input(
            viewWillAppearEvent: rx
                .methodInvoked(#selector(UIViewController.viewWillAppear))
                .map { _ in }
                .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance),
            likeBusBtnTapEvent: likeBusBtnTapEvent.asObservable(),
            alarmBtnTapEvent: alarmBtnTapEvent.asObservable(),
            mapBtnTapEvent: mapBtnTapEvent.asObservable(),
            refreshLoading: refresh.asObservable(),
            navigationBackBtnTapEvent
            : headerView.navigationBtn.rx.tap.asObservable()
        )
        
        rx.methodInvoked(#selector(UIViewController.viewWillAppear))
            .subscribe(onNext: { [weak self] _ in
                guard let naviController = self?.navigationController
                else { return }
                
                naviController.navigationBar.isHidden = true
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        bindTableView(output: output)
        bindMapBtn(output: output)
        bindRefreshing(output: output)
    }
    
    private func bindTableView(output: BusStopViewModel.Output) {
        
        output.busStopArrivalInfoResponse
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, response in
                    viewController.headerView.bindUI(
                        routeId: response.busStopId,
                        busStopName: response.busStopName,
                        nextStopName: response.direction
                    )
                    viewController.updateSnapshot(busStopResponse: response)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func bindMapBtn(output: BusStopViewModel.Output) {
        output.busStopArrivalInfoResponse
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, response in
                    viewController.headerView.mapBtn.rx.tap
                        .take(1)
                        .withUnretained(self)
                        .map { _ in
                            // 두번 열리는 이유를 모르겠음 -> 그래서 take(1)을 통해 한번만 구독 될 수 있게.
                            // 여기서 강묵님 쪽으로 데이터 넘겨주면 될 듯
                            print("🤢 \(response) ")
                            return response
                        }
                        .bind(to: self.mapBtnTapEvent)
                        .disposed(by: self.disposeBag)
                }
            )
            .disposed(by: disposeBag)
    }
    private func bindRefreshing(output: BusStopViewModel.Output) {
        output.isRefreshing
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] bool in
                print("output - \(bool)")
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
            }
            .disposed(by: disposeBag)
    }
    
    private func updateSnapshot(busStopResponse: BusStopArrivalInfoResponse) {
        snapshot = .init()
        for busInfo in busStopResponse.buses {
            let busTypeSection = busInfo.busType
            if !snapshot.sectionIdentifiers.contains(busTypeSection) {
                snapshot.appendSections([busTypeSection])
            }
            snapshot.appendItems([busInfo], toSection: busTypeSection)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureDataSource() {
        dataSource = .init(
            tableView: busStopTableView,
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
        response: BusArrivalInfoResponse
    ) -> BusTableViewCell? {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: BusTableViewCell.identifier,
            for: indexPath
        ) as? BusTableViewCell
        
        cell?.updateBtn(
            favorite: response.isFavorites,
            alarm: response.isAlarmOn
        )
        cell?.updateBusRoute(
            routeName: response.busName,
            nextRouteName: response.nextStation
        )
        cell?.updateFirstArrival(
            firstArrivalTime: response.firstArrivalTime,
            firstArrivalRemaining: response.firstArrivalRemaining
        )
        cell?.updateSecondArrival(
            secondArrivalTime: response.secondArrivalTime,
            secondArrivalRemaining: response.secondArrivalRemaining
        )
        
        cell?.busNumber.textColor = response.busType.toColor
        
        cell?.starBtnTapEvent
            .map { _ in
                return response
            }
            .bind(to: self.likeBusBtnTapEvent)
            .disposed(by: cell!.disposeBag)
        
        cell?.alarmBtnTapEvent
            .map { _ in
                return response
            }
            .bind(to: self.alarmBtnTapEvent)
            .disposed(by: cell!.disposeBag)
        
        return cell
    }
    
    private func configureRefreshControl() {
        refreshControl.endRefreshing()
        scrollView.refreshControl = refreshControl
        
        refreshControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .subscribe(onNext: { viewC, _ in
                viewC.refresh.onNext(true)
            })
            .disposed(by: disposeBag)
        
        refreshControl.tintColor = DesignSystemAsset.mainColor.color
        refreshControl.attributedTitle = NSAttributedString(
            string: "당겨서 새로고침",
            attributes: [.foregroundColor: DesignSystemAsset.mainColor.color]
        )
    }
}

extension BusStopViewController {
    public func configureUI() {
        view.addSubview(scrollView)
        
        [scrollView, contentView, headerView, busStopTableView]
            .forEach { components in
                components.translatesAutoresizingMaskIntoConstraints = false
            }
        
        [headerView, busStopTableView]
            .forEach { components in
                contentView.addSubview(components)
            }
        
        tableViewHeightConstraint = busStopTableView.heightAnchor
            .constraint(equalToConstant: 0)
        
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            scrollView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            scrollView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            
            contentView.topAnchor.constraint(
                equalTo: scrollView.topAnchor
            ),
            contentView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor
            ),
            contentView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor
            ),
            contentView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor
            ),
            contentView.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor
            ),
            
            headerView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            headerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            headerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            
            busStopTableView.topAnchor.constraint(
                equalTo: headerView.bottomAnchor
            ),
            busStopTableView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            busStopTableView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            busStopTableView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
            tableViewHeightConstraint,
        ])
    }
}

extension BusStopViewController: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 60
    }
    
    public func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: BusStopTVHeaderView.identifier
        ) as? BusStopTVHeaderView else { return UIView() }
        
        let sectionIdentifier = dataSource.snapshot()
            .sectionIdentifiers[section]
        
        headerView.bind(with: sectionIdentifier.toString)
        
        return headerView
    }
}

extension BusStopViewController {
    typealias BusStopDataSource =
    UITableViewDiffableDataSource
    <BusType, BusArrivalInfoResponse>
    typealias BusStopSnapshot =
    NSDiffableDataSourceSnapshot
    <BusType, BusArrivalInfoResponse>
    
}
