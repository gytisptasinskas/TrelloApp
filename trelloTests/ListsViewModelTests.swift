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
    
    // MARK: Setup
    override func setUp() {
        super.setUp()
        mockService = MockTrelloService()
        viewModel = ListsViewModel(service: mockService)
    }
    
    // MARK: - Tear Down
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        mockService = nil
        
    }
    
    // MARK: - Tests
    func testFetchListsSuccessfully() async {
        await viewModel.fetchLists(board: "1")
        
        XCTAssertFalse(viewModel.lists.isEmpty, "Lists should not be empty after successful fetch.")
        XCTAssertEqual(viewModel.state, .success, "State should be .success after successful fetch.")
    }
    
    func testFetchListsFailure() async {
        mockService.shouldFetchListsFail = true
        
        await viewModel.fetchLists(board: "1")
        
        XCTAssertTrue(viewModel.lists.isEmpty, "Lists should be empty after fetch failure.")
        XCTAssertEqual(viewModel.state, .failure("The operation couldn’t be completed. (trelloTests.MockServiceError error 0.)"), "State should be .failure after fetch failure.")
    }
}
