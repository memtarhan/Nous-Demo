//
//  APITests.swift
//  NousTests
//
//  Created by Mehmet Tarhan on 11/07/2022.
//  Copyright © 2022 MEMTARHAN. All rights reserved.
//

@testable import Nous
import XCTest

class APITests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchFeeds() async throws {
        do {
            let response = try await FeedsService.shared.fetchFeeds()
            let feeds = response.feeds
            XCTAssertFalse(feeds.isEmpty, "Feeds should not be empty after fetching")

        } catch {
            throw error
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
