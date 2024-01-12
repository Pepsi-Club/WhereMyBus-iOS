import XCTest

import RxSwift

@testable import Networks

final class NetworksTests: XCTestCase {
    var sut: NetworkService!
    var endPoint: KISEndPoint!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        sut = DefaultNetworkService()
        disposeBag = .init()
    }

    override func tearDownWithError() throws {
    }

    func test_KISAccessOAuthEndPoint() throws {
//        endPoint = KISCheckBalanceEndPoint(
//            investType: .simulation,
//            query: .init(accountNumber: ""),
//            authorization: ""
//        )
    }
    
    func test_KISOAuthEndPoint() throws {
//        endPoint = KISOAuthEndPoint(
//            oAuthType: .webSocket,
//            investType: .simulation
//        )
        sut.request(endPoint: endPoint)
            .subscribe { _ in
                print("Success")
            } onError: { error in
                print(error.localizedDescription)
            } onCompleted: {
                print("Completed")
            } onDisposed: {
                print("Disposed")
            }.disposed(by: disposeBag)
    }

    func testPerformanceExample() throws {
        self.measure {
        }
    }
}
