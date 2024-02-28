//
//  TrelloServiceTests.swift
//  trelloTests
//
//  Created by Gytis Ptasinskas on 26/02/2024.
//

import XCTest
@testable import trello
import OHHTTPStubsSwift
import OHHTTPStubs

class TrelloServiceTests: XCTestCase {
    var trelloService: TrelloService!

    override func setUp() {
        super.setUp()
        trelloService = TrelloService()
        
        // Stub for fetchBoards
        stub(condition: isHost("api.trello.com") && isPath("/1/members/me/boards")) { _ in
            guard let stubPath = OHPathForFile("boardResponse.json", type(of: self).self) else {
                fatalError("boardResponse.json not found")
            }
            return fixture(filePath: stubPath, headers: ["Content-Type": "application/json"])
        }

        // Stub for fetchLists
        stub(condition: isHost("api.trello.com") && isPath("/1/boards/1/lists")) { _ in
            guard let stubPath = OHPathForFile("listResponse.json", type(of: self).self) else {
                fatalError("listResponse.json not found")
            }
            return fixture(filePath: stubPath, headers: ["Content-Type": "application/json"])
        }

        // Stub for fetchCard
        stub(condition: isHost("api.trello.com") && isPath("/1/cards/card1")) { _ in
            guard let stubPath = OHPathForFile("cardResponse.json", type(of: self).self) else {
                fatalError("cardResponse.json not found")
            }
            return fixture(filePath: stubPath, headers: ["Content-Type": "application/json"])
        }

        // Stub for deleteCard
        stub(condition: isHost("api.trello.com") && isPath("/1/cards/card1") && isMethodDELETE()) { _ in
            guard let stubPath = OHPathForFile("cardResponse.json", type(of: self).self) else {
                fatalError("cardResponse.json not found")
            }
            return fixture(filePath: stubPath, status: 200, headers: ["Content-Type":"application/json"])
        }

        // Stub for updateCardDescription
        stub(condition: isHost("api.trello.com") && isPath("/1/cards/card1") && isMethodPUT()) { _ in
            guard let stubPath = OHPathForFile("cardResponse.json", type(of: self).self) else {
                fatalError("cardResponse.json not found")
            }
            return fixture(filePath: stubPath, status: 200, headers: ["Content-Type":"application/json"])
        }
    }

    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testFetchBoardsSuccess() async throws {
        do {
            let boards = try await trelloService.fetchBoards()
            XCTAssertFalse(boards.isEmpty, "Boards list should not be empty")
            XCTAssertEqual(boards.first?.name, "Test Board", "The first board's name does not match the expected value.")
        } catch {
            XCTFail("Fetching boards failed with error: \(error)")
        }
    }
    
    func testFetchListsSuccess() async throws {
        do {
            let lists = try await trelloService.fetchLists(board: "1")
            XCTAssertFalse(lists.isEmpty, "Lists should not be empty")
            XCTAssertEqual(lists.first?.name, "To Do", "The first list's name does not match the expected value.")
        } catch {
            XCTFail("Fetching lists failed with error: \(error)")
        }
    }
    
    func testFetchCardSuccess() async throws {
        do {
            let card = try await trelloService.fetchCard(card: "card1")
            XCTAssertNotNil(card, "Fetched card should not be nil")
            XCTAssertEqual(card.name, "Task 1", "The card's name does not match the expected value.")
            XCTAssertEqual(card.desc, "Description of Task 1", "The card's description does not match the expected value.")
        } catch {
            XCTFail("Fetching card failed with error: \(error)")
        }
    }
    
    func testDeleteCardSuccess() async throws {
        do {
            try await trelloService.deleteCard(card: "card1")
            //  this operation does not return content
        } catch {
            XCTFail("Deleting card failed with error: \(error)")
        }
    }
    
    func testUpdateCardDescriptionSuccess() async throws {
        do {
            try await trelloService.updateCardDescription(cardId: "card1", newDescription: "Updated Description")
        } catch {
            XCTFail("Updating card description failed with error: \(error)")
        }
    }
}
