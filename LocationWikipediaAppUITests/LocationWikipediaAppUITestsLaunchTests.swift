//
//  LocationWikipediaAppUITestsLaunchTests.swift
//  LocationWikipediaAppUITests
//
//  Created by Bart van Kuik on 08/03/2023.
//

import XCTest

final class LocationWikipediaAppUITestsLaunchTests: XCTestCase {
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSearch() throws {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars["Locations"].buttons["Search"].tap()
        
        let latitudeAsDecimalNumberTextField = app.textFields["Latitude as decimal number"]
        latitudeAsDecimalNumberTextField.tap()
        latitudeAsDecimalNumberTextField.typeText("5")
        
        let longitudeAsDecimalNumberTextField = app.textFields["Longitude as decimal number"]
        longitudeAsDecimalNumberTextField.tap()
        longitudeAsDecimalNumberTextField.typeText("2")
        
        app.staticTexts["Go to location"].tap()
    }
    
    func testTable() throws {
        let app = XCUIApplication()
        app.launch()
        let cell = app.tables.cells.firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        cell.tap()
    }
}
