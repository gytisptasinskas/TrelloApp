//
//  TrelloServiceProtocol.swift
//  trello
//
//  Created by Gytis Ptasinskas on 26/02/2024.
//

import Foundation

protocol TrelloServiceProtocol {
    func fetchBoards() async throws -> [Board]
    func fetchLists(board boardId: String) async throws -> [Lists]
    func fetchCard(card cardId: String) async throws -> Card
    func deleteCard(card cardId: String) async throws
    func updateCardDescription(cardId: String, newDescription: String) async throws
}
