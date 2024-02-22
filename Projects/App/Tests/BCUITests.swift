//
//  BCUITests.swift
//  App
//
//  Created by gnksbm on 2/19/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import XCTest

final class BCUITests: XCTestCase {

    @MainActor override func setUpWithError() throws {
        continueAfterFailure = false
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDownWithError() throws {
    }

    @MainActor func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        snapshot("0_Favorites")
        
        var button = app.buttons["버스 정류장을 검색하세요"]
        button.tap()
        snapshot("1_SearchBusStop")
        
        button = XCUIApplication().tabBars["Tab Bar"].buttons["알람"]
        button.tap()
        snapshot("3_RegularAlarm")
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
