import UIKit

import Domain
import DesignSystem

import RxSwift
import RxCocoa

public final class BusStopViewController: UIViewController {
    private let viewModel: BusStopViewModel
    
    private let disposeBag = DisposeBag()
    private let mapBtnTapEvent = PublishSubject<Int>()
    private let likeBusStopBtnTapEvent = BehaviorSubject<Bool>(value: false)
    private let likeBusBtnTapEvent = PublishSubject<IndexPath>()
    private let alarmBtnTapEvent = PublishSubject<IndexPath>()
    
    private var dataSource: BusStopDataSource!
    private var snapshot: BusStopSnapshot!
    
    private let headerView: BusStopInfoHeaderView = BusStopInfoHeaderView()
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView = UIView()
    private let busStopTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(
            BusTableViewCell.self,
            forCellReuseIdentifier: BusTableViewCell.identifier
        )
        table.register(
            BusStopTVHeaderView.self,
            forHeaderFooterViewReuseIdentifier: BusStopTVHeaderView.identifier
        )
        table.isScrollEnabled = false
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
        
        view.backgroundColor = .systemBackground
        
        configureDataSource()
        bind()
        configureUI()
        
        busStopTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewHeightConstraint.constant = busStopTableView.contentSize.height
    }
    
    private func bind() {
        let input = BusStopViewModel.Input(
            viewWillAppearEvent: rx
                .methodInvoked(#selector(UIViewController.viewWillAppear))
                .map { _ in },
            likeBusBtnTapEvent: likeBusBtnTapEvent.asObservable(),
            alarmBtnTapEvent: alarmBtnTapEvent.asObservable(),
            likeBusStopBtnTapEvent: likeBusStopBtnTapEvent.asObservable(),
            mapBtnTapEvent: mapBtnTapEvent.asObservable()
        )
        
        rx.methodInvoked(#selector(UIViewController.viewWillAppear))
            .subscribe(onNext: { [weak self] _ in
                guard let naviController = self?.navigationController
                else { return }
                
                naviController.navigationBar.isHidden = true
            })
            .disposed(by: disposeBag)
        
        headerView.favoriteBtn.rx.tap
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                guard let isEditMode = try? viewController
                    .likeBusStopBtnTapEvent.value()
                else { return }
                viewController.likeBusStopBtnTapEvent
                    .onNext(!isEditMode)
                print("tap")
            })
            .disposed(by: disposeBag)
        
        likeBusStopBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, isEditMode in
                    guard var config 
                        = viewController.headerView.favoriteBtn.configuration
                    else { return }
                    
                    config.baseForegroundColor = isEditMode
                    ? .white
                    : DesignSystemAsset.favoritesOrange.color
                    
                    config.baseBackgroundColor = isEditMode
                    ? DesignSystemAsset.favoritesOrange.color
                    : .white
                    
                    config.image = isEditMode
                    ? UIImage(systemName: "star.fill")
                    : UIImage(systemName: "star")
                    
                    viewController.headerView.favoriteBtn.configuration = config
                }
            )
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        bindTableView(output: output)
    }
    
    private func bindTableView(output: BusStopViewModel.Output) {
        
        output.busStopArrivalInfoResponse
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, response in
                    response.forEach { res in
                        viewController.headerView.bindUI(
                            routeId: res.busStopId,
                            busStopName: res.busStopName,
                            nextStopName: res.direction
                        )
                    }
                    
                    viewController.updateSnapshot(busStopResponse: response)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func updateSnapshot(busStopResponse: [BusStopArrivalInfoResponse]) {
        snapshot = .init()
        
        for response in busStopResponse {
            for busInfo in response.buses {
                let busTypeSection = busInfo.busType
                if !snapshot.sectionIdentifiers.contains(busTypeSection) {
                    snapshot.appendSections([busTypeSection])
                }
                snapshot.appendItems([busInfo], toSection: busTypeSection)
            }
        }
        dataSource.apply(snapshot)
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
                
                cell.starBtnTapEvent
                    .map { _ in
                        return indexPath
                    }
                    .bind(to: self.likeBusBtnTapEvent)
                    .disposed(by: cell.disposeBag)
                
                cell.alarmBtnTapEvent
                    .map { _ in
                        return indexPath
                    }
                    .bind(to: self.alarmBtnTapEvent)
                    .disposed(by: cell.disposeBag)
                
                return cell
                
            })
        
    }
    
    private func configureCell(
        tableView: UITableView,
        indexPath: IndexPath,
        response: BusArrivalInfoResponse
    ) -> BusTableViewCell? {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BusTableViewCell.identifier,
            for: indexPath
        ) as? BusTableViewCell
        else { return nil }
        let splittedMsg1 = response.firstArrivalTime
            .components(separatedBy: "[")
        let splittedMsg2 = response.secondArrivalTime
            .components(separatedBy: "[")
        let firstArrivalTime = splittedMsg1[0]
            .components(separatedBy: "분")[0]
        let secondArrivalTime = splittedMsg2[0]
            .components(separatedBy: "분")[0]
        var firstArrivalRemaining = ""
        var secondArrivalRemaining = ""
        if splittedMsg1.count > 1 {
            firstArrivalRemaining = splittedMsg1[1]
            firstArrivalRemaining.removeLast() // "]" 제거
        }
        if splittedMsg2.count > 1 {
            secondArrivalRemaining = splittedMsg2[1]
            secondArrivalRemaining.removeLast() // "]" 제거
        }
        
        cell.updateBtn(
            favorite: response.isFavorites,
            alarm: response.isAlarmOn
        )
        cell.updateBusRoute(
            routeName: response.routeName,
            nextRouteName: "강남구청역 방면"
        )
        cell.updateFirstArrival(
            firstArrivalTime: firstArrivalTime,
            firstArrivalRemaining: firstArrivalRemaining
        )
        cell.updateSecondArrival(
            secondArrivalTime: secondArrivalTime,
            secondArrivalRemaining: secondArrivalRemaining
        )
        
        cell.busNumber.textColor = busTypeColor(
            busTypeResponse: response.busType
        )
        
        return cell
    }
    
    private func busTypeColor(
        busTypeResponse: BusType
    ) -> UIColor {
        switch busTypeResponse {
        case .common:
            return DesignSystemAsset.gray4.color // 완
        case .airport:
            return DesignSystemAsset.airportGold.color
        case .village:
            return DesignSystemAsset.limeGreen.color // 완
        case .trunkLine:
            return DesignSystemAsset.regularAlarmBlue.color // 완
        case .branchLine:
            return DesignSystemAsset.limeGreen.color // 완
        case .circulation:
            return DesignSystemAsset.circulateYellow.color // 완
        case .wideArea:
            return DesignSystemAsset.redBusColor.color // 완
        case .incheon:
            return DesignSystemAsset.settingColor.color
        case .gyeonggi:
            return DesignSystemAsset.settingColor.color
        case .abolition:
            return DesignSystemAsset.gray4.color
        }
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
                equalTo: scrollView.bottomAnchor
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
