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
import Alamofire

class TrelloServiceTests: XCTestCase {
    var trelloService: TrelloService!

    override func setUp() {
        super.setUp()
        trelloService = TrelloService()
        
        // MARK: - Stubs
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

    // MARK: - Tear Down
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    // MARK: - Tests
    // MARK: - Board Functions
    func testFetchBoardsSuccess() async throws {
        do {
            let boards = try await trelloService.fetchBoards()
            XCTAssertFalse(boards.isEmpty, "Boards list should not be empty")
            XCTAssertEqual(boards.first?.name, "Test Board", "The first board's name does not match the expected value.")
        } catch {
            XCTFail("Fetching boards failed with error: \(error)")
        }
    }
    
    func testFetchBoardsFailureNetworkError() async throws {
        // Stub to simulate a network error
        stub(condition: isHost("api.trello.com") && isPath("/1/members/me/boards")) { _ in
            let error = NSError(domain: NSURLErrorDomain, code: URLError.networkConnectionLost.rawValue, userInfo: nil)
            return HTTPStubsResponse(error: error)
        }
        
        do {
            let _ = try await trelloService.fetchBoards()
            XCTFail("Expected network error to be thrown")
        } catch let error as AFError {
            if let underlyingError = error.underlyingError as NSError? {
                XCTAssertEqual(underlyingError.domain, NSURLErrorDomain)
                XCTAssertEqual(underlyingError.code, URLError.networkConnectionLost.rawValue)
            } else {
                XCTFail("Expected underlying NSError")
            }
        } catch {
            XCTFail("Expected AFError")
        }
    }
    
    // MARK: - Board Lists
    func testFetchListsSuccess() async throws {
        do {
            let lists = try await trelloService.fetchLists(board: "1")
            XCTAssertFalse(lists.isEmpty, "Lists should not be empty")
            XCTAssertEqual(lists.first?.name, "To Do", "The first list's name does not match the expected value.")
        } catch {
            XCTFail("Fetching lists failed with error: \(error)")
        }
    }
    
    func testFetchListsFailureInvalidJSON() async throws {
        // Stub to return invalid JSON
        stub(condition: isHost("api.trello.com") && isPath("/1/boards/1/lists")) { _ in
            let notJSONData = "Invalid JSON".data(using: .utf8)!
            return HTTPStubsResponse(data: notJSONData, statusCode: 200, headers: ["Content-Type": "application/json"])
        }

        do {
            let _ = try await trelloService.fetchLists(board: "1")
            XCTFail("Expected JSON parsing error to be thrown")
        } catch let error as AFError {
            switch error {
            case .responseSerializationFailed(let reason):
                switch reason {
                case .decodingFailed(let error as DecodingError):
                    XCTAssertTrue(true, "Caught DecodingError as expected")
                default:
                    XCTFail("Expected a DecodingError but got \(error)")
                }
            default:
                XCTFail("Expected a responseSerializationFailed error but got \(error)")
            }
        }
    }
    
    // MARK: - Card Functions
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
    
    func testUpdateCardDescriptionFailureHTTPError() async throws {
        // Stub to simulate a 404 Not Found error
        stub(condition: isHost("api.trello.com") && isPath("/1/cards/card1") && isMethodPUT()) { _ in
            return HTTPStubsResponse(data: Data(), statusCode: 404, headers: ["Content-Type": "application/json"])
        }
        
        do {
            try await trelloService.updateCardDescription(cardId: "card1", newDescription: "Updated Description")
            XCTFail("Expected HTTP 404 error to be thrown")
        } catch {
            // Assert that an HTTP error occurred
            let afError = error as? AFError
            let statusCode = afError?.responseCode
            XCTAssertEqual(statusCode, 404, "Expected HTTP status code 404 but got \(String(describing: statusCode))")
        }
    }
}
