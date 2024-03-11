import UIKit

import Domain
import DesignSystem

import RxSwift

public final class BusStopViewController: UIViewController {
    private let viewModel: BusStopViewModel
    
    private let disposeBag = DisposeBag()
    private let mapBtnTapEvent = PublishSubject<Void>()
    private let likeBusBtnTapEvent = PublishSubject<BusArrivalInfoResponse>()
    private let alarmBtnTapEvent = PublishSubject<BusArrivalInfoResponse>()
    
    private var dataSource: BusStopDataSource!
    private var snapshot: BusStopSnapshot!
    
    private let headerView: BusStopInfoHeaderView = BusStopInfoHeaderView()
    private let scrollView: UIScrollView = UIScrollView()
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
    
    public init(viewModel: BusStopViewModel) {
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
        configureDataSource()
        bindMapBtn()
    }
    
    private func bind() {
        let refreshControl = scrollView.enableRefreshControl(
            refreshStr: "당겨서 새로고침"
        )
        
        let input = BusStopViewModel.Input(
            viewWillAppearEvent: rx
                .methodInvoked(#selector(UIViewController.viewWillAppear))
                .map { _ in },
            likeBusBtnTapEvent: likeBusBtnTapEvent.asObservable(),
            alarmBtnTapEvent: alarmBtnTapEvent.asObservable(),
            mapBtnTapEvent: mapBtnTapEvent.asObservable(),
            refreshLoading
            : refreshControl.rx.controlEvent(.valueChanged).asObservable(),
            navigationBackBtnTapEvent
            : headerView.navigationBtn.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        bindTableView(output: output)
        
        output.isRefreshing
            .subscribe(onNext: { refresh in
                print("\(refresh)")
                switch refresh {
                case .fetchComplete:
                    refreshControl.endRefreshing()
                case .fetching:
                    break
                }
            })
            .disposed(by: disposeBag)
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
    
    private func bindMapBtn() {
        // output.- 을 가공해서 다시 input으로 넣어줘버림 -> 순환 참조가 되어버림
        // 지금
        // 가공 -> 인풋 X -> viewModel에서 이벤트 헨들링만 하는 것 !
        // 이게 더 MVVM 형태에 맞는게 아닐까 (VC는 정말 이벤트만 보내주는 형태 !)
        headerView.mapBtn.rx.tap
            .map { _ in }
            .bind(to: mapBtnTapEvent)
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
            .map({ _ in
                return response
            })
            .subscribe(onNext: { busInfo in
                self.likeBusBtnTapEvent.onNext(busInfo)
            })
            .disposed(by: cell!.disposeBag)
        
        cell?.alarmBtnTapEvent
            .map { _ in
                return response
            }
            .bind(to: self.alarmBtnTapEvent)
            .disposed(by: cell!.disposeBag)
        
        return cell
    }
}

extension BusStopViewController {
    public func configureUI() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(scrollView)
        
        [scrollView, contentView, headerView, busStopTableView]
            .forEach { components in
                components.translatesAutoresizingMaskIntoConstraints = false
            }
        
        [headerView, busStopTableView]
            .forEach { components in
                contentView.addSubview(components)
            }
        
        scrollView.addSubview(contentView)
        scrollView.contentInsetAdjustmentBehavior = .never
        
        NSLayoutConstraint.activate([
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
            
            contentView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor
            ),
            contentView.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor
            ),
            contentView.widthAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.widthAnchor
            ),
            contentView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor
            ),
            contentView.heightAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor
            ),
            
            scrollView.frameLayoutGuide.topAnchor.constraint(
                equalTo: view.topAnchor
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
