//
//  TrelloServiceTests.swift
//  trelloTests
//
//  Created by Gytis Ptasinskas on 26/02/2024.
//

import XCTest
@testable import trello

class TrelloServiceTests: XCTestCase {
    var mockService: MockTrelloService!
    
    override func setUp() {
        super.setUp()
        mockService = MockTrelloService()
    }
    
    override func tearDown() {
        mockService = nil
        super.tearDown()
    }
    
    func testFetchBoardsSuccess() async throws {
        let expectedBoards = [Board(id: "1", name: "Test Board"), Board(id: "2", name: "Test Board2"), Board(id: "3", name: "Test Board3")]
        let boards = try await mockService.fetchBoards()
        
        XCTAssertEqual(boards.count, expectedBoards.count)
        XCTAssertEqual(boards.first?.id, expectedBoards.first?.id)
        XCTAssertEqual(boards.first?.name, expectedBoards.first?.name)
    }
    
    func testFetchListsSuccess() async throws {
        let expectedBoardId = "1"
        let expectedLists = [Lists(id: "1", name: "Test List", cards: [])]
        let lists = try await mockService.fetchLists(forBoard: expectedBoardId)
        
        XCTAssertEqual(lists.count, expectedLists.count, "Fetched lists do not match expected lists")
    }
    
    func testFetchCardSuccess() async throws {
        let expectedCardId = "card1"
        let expectedCard = Card(id: expectedCardId, name: "Test Card", desc: "Description")
        let card = try await mockService.fetchCard(card: expectedCardId)
        
        XCTAssertEqual(card, expectedCard, "Fetched card does not match expected card")
    }
    
    func testDeleteCardSuccess() async throws {
        mockService.deleteCardSuccess = true
        let cardId = "testCardId"
        
        do {
            try await mockService.deleteCard(card: cardId)
    
        } catch {
            XCTFail("Delete card should not fail: \(error.localizedDescription)")
        }
    }

    func testUpdateCardDescriptionSuccess() async throws {
        mockService.updateCardDescriptionSuccess = true
        let cardId = "1"
        let newDescription = "Updated Description"
        
        do {
            try await mockService.updateCardDescription(cardId: cardId, newDescription: newDescription)
        } catch {
            XCTFail("Update card description should not fail: \(error.localizedDescription)")
        }
    }
}
