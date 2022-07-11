//
//  HomeTests.swift
//  NousTests
//
//  Created by Mehmet Tarhan on 11/07/2022.
//  Copyright © 2022 MEMTARHAN. All rights reserved.
//

@testable import Nous
import XCTest

class HomeTests: XCTestCase {
    
    var model: HomeModel!
    
    override func setUpWithError() throws {
        model = HomeModel()
    }

    override func tearDownWithError() throws {
        model = nil
    }

    func testModelIfFetchesFeeds() async throws {
        do {
            let feeds = try await model.fetchFeeds()
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
