//
//  CardViewModelTests.swift
//  trelloTests
//
//  Created by Gytis Ptasinskas on 27/02/2024.
//

import XCTest
@testable import trello

@MainActor
final class CardViewModelTests: XCTestCase {
    
    var viewModel: CardViewModel!
    var mockService: MockTrelloService!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        mockService = MockTrelloService()
        viewModel = CardViewModel(service: mockService)
    }
    
    // MARK: = Tear Down
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        mockService = nil
        
    }
    
    // MARK: - Tests
    func testFetchCardSuccessfully() async throws {
        await viewModel.fetchCard(cardId: "card1")
        
        let expectedLabels = ["Urgent", "Bug"]
        XCTAssertEqual(viewModel.card?.id, "card1", "The fetched card ID should match.")
        XCTAssertEqual(viewModel.descriptionText, "Description of Task 1", "Description text should be updated correctly.")
        XCTAssertEqual(viewModel.cardLabels, expectedLabels, "Card labels should be updated correctly.")
    }
    
    func testFetchCardFailure() async {
        mockService.shouldFetchCardFail = true
        
        await viewModel.fetchCard(cardId: "card1")
        
        XCTAssertNil(viewModel.card, "Card should be nil on fetch failure.")
        XCTAssertNotNil(viewModel.errorMessage, "Error message should be set on fetch failure.")
    }
    
    func testUpdateDescriptionSuccessfully() async throws {
        let updatedDescription = "Updated Description"
        
        await viewModel.updateDescription(cardId: "1", newDescription: updatedDescription)
        
        XCTAssertEqual(viewModel.descriptionText, updatedDescription, "Description text should be updated on success.")
        XCTAssertNil(viewModel.errorMessage, "There should be no error message on successful description update.")
    }
    
    func testUpdateDescriptionFailure() async {
        mockService.shouldUpdateCardFail = true
        
        await viewModel.updateDescription(cardId: "1", newDescription: "New Description")
        
        XCTAssertNotNil(viewModel.errorMessage, "Error message should be set on update failure.")
    }
    
    func testDeleteCardSuccessfully() async throws {
        await viewModel.deleteCard(cardId: "1")
        
        XCTAssertNil(viewModel.errorMessage, "There should be no error message on successful deletion.")
    }
    
    func testDeleteCardFailure() async {
        mockService.shouldDeleteCardFail = true
        
        await viewModel.deleteCard(cardId: "1")
        
        XCTAssertNotNil(viewModel.errorMessage, "Error message should be set on delete failure.")
    }
}
