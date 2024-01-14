import XCTest

import RxSwift

@testable import Networks

final class NetworksTests: XCTestCase {
    var sut: NetworkService!
    var endPoint: EndPoint!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        sut = DefaultNetworkService()
        disposeBag = .init()
    }

    override func tearDownWithError() throws {
    }

    func testPerformanceExample() throws {
        self.measure {
        }
    }
}
