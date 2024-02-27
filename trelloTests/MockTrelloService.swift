//
//  MockTrelloService.swift
//  trelloTests
//
//  Created by Gytis Ptasinskas on 26/02/2024.
//

import Foundation
@testable import trello

class MockTrelloService: TrelloServiceProtocol, Mockable {
    var deleteCardSuccess: Bool = true
    var updateCardDescriptionSuccess: Bool = true
    var fetchListsShouldReturnEmpty: Bool = false

    func fetchBoards() async throws -> [Board] {
        return try loadJson(filename: "boardResponse", type: [Board].self)
    }
    
    func fetchLists(forBoard boardId: String) async throws -> [Lists] {
        return try loadJson(filename: "listResponse", type: [Lists].self)
    }
    
    func fetchCard(card cardId: String) async throws -> Card {
        return try loadJson(filename: "cardResponse", type: Card.self)
    }
    
    func deleteCard(card cardId: String) async throws {
        if !deleteCardSuccess {
            throw NSError(domain: "com.yourapp.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to delete card"])
        }
    }
    
    func updateCardDescription(cardId: String, newDescription: String) async throws {
        if !updateCardDescriptionSuccess {
            throw NSError(domain: "com.yourapp.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to update card description"])
        }
    }
}

