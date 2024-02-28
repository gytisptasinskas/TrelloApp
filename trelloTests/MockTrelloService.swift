//
//  MockTrelloService.swift
//  trelloTests
//
//  Created by Gytis Ptasinskas on 26/02/2024.
//

import Foundation
@testable import trello

final class MockTrelloService: TrelloServiceProtocol, Mockable {
    var shouldFetchBoardsFail = false
    var shouldFetchListsFail = false
    var shouldFetchCardFail = false
    var shouldUpdateCardFail = false
    var shouldDeleteCardFail = false
    
    func fetchBoards() async throws -> [Board] {
        if shouldFetchBoardsFail {
            throw MockServiceError.simulatedError
        }
        return try loadJson(filename: "boardResponse", type: [Board].self)
    }
    
    func fetchLists(board boardId: String) async throws -> [Lists] {
        if shouldFetchListsFail {
            throw MockServiceError.simulatedError
        }
        return try loadJson(filename: "listResponse", type: [Lists].self)
    }
    
    func fetchCard(card cardId: String) async throws -> Card {
        if shouldFetchCardFail {
            throw MockServiceError.simulatedError
        }
        return try loadJson(filename: "cardResponse", type: Card.self)
    }
    
    func deleteCard(card cardId: String) async throws {
        if shouldDeleteCardFail {
            throw MockServiceError.simulatedError
        }
    }
    
    func updateCardDescription(cardId: String, newDescription: String) async throws {
        if shouldUpdateCardFail {
            throw MockServiceError.simulatedError
        }
    }
}

enum MockServiceError: Error {
    case simulatedError
    
    var errorDescription: String? {
        switch self {
        case .simulatedError:
            return "Error"
        }
    }
}
