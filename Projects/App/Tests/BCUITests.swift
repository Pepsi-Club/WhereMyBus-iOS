//
//  BCUITests.swift
//  App
//
//  Created by gnksbm on 2/19/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import XCTest
import CoreLocation

final class BCUITests: XCTestCase {
    private var testLocation: CLLocation {
        .init(
            latitude: 37.570238,
            longitude: 126.986536
        )
    }
    
    @MainActor override func setUpWithError() throws {
        continueAfterFailure = false
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDownWithError() throws {
    }
    
    @MainActor func testExample() throws {
        // MARK: Launch
        let app = XCUIApplication()
        app.launch()
        captureEmptyFavorite(app: app)
        captureRecentSearch(app: app)
        captureSearchAndBusStop(app: app)
        captureFavorites(app: app)
        captureNearMap(app: app)
        captureRegularAlarm(app: app)
    }
    /// 빈 즐겨찾기 화면 snapshot
    @MainActor private func captureEmptyFavorite(app: XCUIApplication) {
        snapshot("0_EmptyFavorites")
    }
    /// 최근 검색 화면 snapshot
    @MainActor private func captureRecentSearch(app: XCUIApplication) {
        app.buttons["홈에서 검색뷰로 네비게이션"].tap()
        snapshot("2_RecentSearch")
        app.buttons["Back"].tap()
    }
    /// 최근 검색 화면 snapshot
    @MainActor private func captureSearchAndBusStop(app: XCUIApplication) {
        app.buttons["홈에서 검색뷰로 네비게이션"].tap()
        let searchField = app.textFields["정류장 검색"]
        searchField.tap()
        searchField.typeText("은곡마을")
        
        app.tables["검색결과"].staticTexts["23412 | 세곡푸르지오.은곡삼거리 방면"].tap()
        
        let resultTable = app.tables["정류장"]
        
        resultTable.cells.containing(
            .staticText,
            identifier:"6600"
        ).buttons["favorite"].tap()
        resultTable.cells.containing(
            .staticText,
            identifier:"강남06"
        ).buttons["favorite"].tap()
        resultTable.cells.containing(
            .staticText,
            identifier:"452"
        ).buttons["favorite"].tap()
        resultTable.cells.containing(
            .staticText,
            identifier:"741"
        ).buttons["favorite"].tap()
        snapshot("4_BusStop")
        app.buttons["Back"].tap()
        
        searchField.buttons["Clear text"].tap()
        searchField.typeText("신분당선")
        
        snapshot("3_Search")
        app.tables["검색결과"].staticTexts["22010 | 지하철2호선강남역 방면"].tap()
        
        resultTable.cells.containing(
            .staticText,
            identifier:"140"
        ).buttons["favorite"].tap()
        resultTable.cells.containing(
            .staticText,
            identifier:"400"
        ).buttons["favorite"].tap()
        resultTable.cells.containing(
            .staticText,
            identifier:"1550광주"
        ).buttons["favorite"].tap()
        
        app.buttons["Back"].tap()
        app.buttons["Back"].tap()
    }
    /// 즐겨찾기 snapshot
    @MainActor private func captureFavorites(app: XCUIApplication) {
        snapshot("1_Favorites")
    }
    /// 주변 정류장 snapshot
    @MainActor private func captureNearMap(app: XCUIApplication) {
        app.resetAuthorizationStatus(for: .location)
        if #available(iOS 16.4, *) {
            XCUIDevice.shared.location = .init(
                location: testLocation
            )
        }
        app.buttons["홈에서 검색뷰로 네비게이션"].tap()
        let nearByStopText = app.staticTexts["주변정류장"]
        nearByStopText.tap()
        addUIInterruptionMonitor(
            withDescription: "‘버스어디’ 앱이 사용자의 위치를 사용하도록 허용하겠습니까?"
        ) { alert in
            alert.buttons["한 번 허용"].tap()
            return true
        }
        sleep(3)
        nearByStopText.tap()
        app.children(matching: .window).element(boundBy: 0)
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element(boundBy: 0).tap()
        snapshot("5_NearMap")
        app.buttons["Back"].tap()
        app.buttons["Back"].tap()
    }
    /// 정규알람 snapshot
    @MainActor private func captureRegularAlarm(app: XCUIApplication) {
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["알람"].tap()
        
        app.buttons["정규알람 추가하기"].tap()
        addUIInterruptionMonitor(
            withDescription: "‘버스어디’에서 알림을 보내고자 합니다."
        ) { alert in
            alert.buttons["허용"].tap()
            return true
        }
        sleep(3)
        app.buttons["알람에서 검색뷰로 네비게이션"].tap()
        
        app.tables["최근검색"].staticTexts["23412 | 세곡푸르지오.은곡삼거리 방면"].tap()
        
        app.tables["정류장"].cells.element(boundBy: 0).tap()
        
        let datePicker = app.datePickers.pickerWheels
        datePicker.element(boundBy: 0).adjust(toPickerWheelValue: "7")
        datePicker.element(boundBy: 1).adjust(toPickerWheelValue: "30")
        datePicker.element(boundBy: 2).adjust(toPickerWheelValue: "AM")
        
        app.staticTexts["월"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["화"]/*[[".buttons[\"화\"].staticTexts[\"화\"]",".staticTexts[\"화\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["수"].tap()
        app.staticTexts["목"].tap()
        app.staticTexts["금"].tap()
        
        snapshot("6_RegularAlarm")
        
        tabBar.buttons["홈"].tap()
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
