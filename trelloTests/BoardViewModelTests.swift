//
//  testBoardViewModel.swift
//  trelloTests
//
//  Created by Gytis Ptasinskas on 27/02/2024.
//

import XCTest
import Combine
@testable import trello

@MainActor
final class BoardViewModelTests: XCTestCase {
    
    var viewModel: BoardViewModel!
    var mockService: MockTrelloService!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockService = MockTrelloService()
        viewModel = BoardViewModel(service: mockService)
        
        viewModel.boards = [
            Board(id: "1", name: "Test Board", lists: []),
            Board(id: "2", name: "Another Test Board", lists: []),
            Board(id: "3", name: "Board Test", lists: [])
        ]
        viewModel.filteredBoards = viewModel.boards
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        mockService = nil
        cancellables.removeAll()
    }
    
    func testFetchBoardsSuccessfully() async {
        let expectation = XCTestExpectation(description: "Fetch boards completes")
        
        viewModel.$isLoading
            .dropFirst()
            .sink(receiveValue: { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            })
            .store(in: &cancellables)
        
        viewModel.fetchBoards()
        
        await fulfillment(of: [expectation], timeout: 5.0)
        
        XCTAssertFalse(viewModel.isLoading, "ViewModel should not be loading after fetching boards.")
        XCTAssertFalse(viewModel.boards.isEmpty, "Boards array should contain elements.")
        XCTAssertNil(viewModel.errorMessage, "There should be no error message after successful fetching.")
    }
    
    func testFilterBoardsWithSearchText() {
        viewModel.searchText = "Another"
        
        XCTAssertEqual(viewModel.filteredBoards.count, 1, "There should be exactly one board matching the search text 'Another'")
        XCTAssertEqual(viewModel.filteredBoards.first?.name, "Another Test Board", "The filtered board should be 'Another Test Board'")
        
        viewModel.searchText = ""
        
        XCTAssertEqual(viewModel.filteredBoards.count, 3, "Clearing the search text should show all boards again")
        
        viewModel.searchText = "Nonexistent"
        
        XCTAssertTrue(viewModel.filteredBoards.isEmpty, "No boards should match the search text 'Nonexistent'")
    }
}
