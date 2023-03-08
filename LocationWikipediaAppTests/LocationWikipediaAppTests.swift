//
//  LocationWikipediaAppTests.swift
//  LocationWikipediaAppTests
//
//  Created by Bart van Kuik on 08/03/2023.
//

@testable import LocationWikipediaApp
import XCTest

final class LocationWikipediaAppTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testLocationModel() throws {
        // Data from https://xkcd.com/2170/
        let url = Bundle(for: Self.self).url(forResource: "mock_locations", withExtension: "json")
        let data = try Data(contentsOf: url!)
        let locationList = try JSONDecoder().decode(LocationList.self, from: data)
        XCTAssert(!locationList.locations.isEmpty)
        XCTAssert(locationList.locations.count == 8)
        XCTAssertNil(locationList.locations.last!.name)
    }

    func testLocationListService() async {
        switch LocationListService.shared.mode {
        case let .success(list):
            XCTAssert(list.locations.isEmpty)
        default:
            XCTFail("Service was not configured correctly")
        }

        await LocationListService.shared.refresh()

        switch LocationListService.shared.mode {
        case let .success(list):
            XCTAssert(!list.locations.isEmpty)
        default:
            XCTFail("Service has unexpected status")
        }
    }
}
