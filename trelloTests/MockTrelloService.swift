//
//  MockTrelloService.swift
//  trelloTests
//
//  Created by Gytis Ptasinskas on 26/02/2024.
//

import Foundation
@testable import trello

final class MockTrelloService: TrelloServiceProtocol, Mockable {
    
    func fetchBoards() async throws -> [Board] {
        return try loadJson(filename: "boardResponse", type: [Board].self)
    }
    
    func fetchLists(board boardId: String) async throws -> [Lists] {
        return try loadJson(filename: "listResponse", type: [Lists].self)
    }
    
    func fetchCard(card cardId: String) async throws -> Card {
        return try loadJson(filename: "cardResponse", type: Card.self)
    }
    
    func deleteCard(card cardId: String) async throws {
        
    }
    
    func updateCardDescription(cardId: String, newDescription: String) async throws {
        
    }
}

