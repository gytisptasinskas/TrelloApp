//
//  ListsViewModelTests.swift
//  trelloTests
//
//  Created by Gytis Ptasinskas on 27/02/2024.
//

import XCTest
@testable import trello

@MainActor
final class ListsViewModelTests: XCTestCase {

    var viewModel: ListsViewModel!
    var mockService: MockTrelloService!
    
    override func setUp() {
        super.setUp()
        mockService = MockTrelloService()
        viewModel = ListsViewModel(service: mockService)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        mockService = nil
        
    }
    
    func testFetchListsSuccessfully() async {
        await viewModel.fetchLists(forBoard: "1")

        XCTAssertFalse(viewModel.lists.isEmpty, "Lists should not be empty after successful fetch.")
        XCTAssertEqual(viewModel.state, .success, "State should be .success after successful fetch.")
    }
}
