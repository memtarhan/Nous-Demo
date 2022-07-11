//
//  HomeTests.swift
//  NousTests
//
//  Created by Mehmet Tarhan on 11/07/2022.
//  Copyright © 2022 MEMTARHAN. All rights reserved.
//

@testable import Nous
import XCTest
import Combine

class HomeTests: XCTestCase {
    var model: HomeModel!
    var view: HomeViewController!
    var viewModel: HomeViewModel!
    
    private var cancellables: Set<AnyCancellable> = []


    override func setUpWithError() throws {
        model = HomeModel()
        view = HomeViewController.instantiate()
        viewModel = HomeViewModel()

        view.viewModel = viewModel
        viewModel.view = view
        viewModel.model = model
    }

    override func tearDownWithError() throws {
        model = nil
        view = nil
        viewModel = nil
    }

    func testViewModelIfFetchesFeeds() async throws {
        let expectation = self.expectation(description: "testViewModelIfFetchesFeeds")
        
        await viewModel.loadInitialData()
        
        viewModel.snapshot.sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        
        await waitForExpectations(timeout: 5.0)
        
        XCTAssertFalse(viewModel.feedModels.isEmpty, "Feeds should not be empty after fetching")
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
