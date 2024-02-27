//
//  TrelloServiceProtocol.swift
//  trello
//
//  Created by Gytis Ptasinskas on 26/02/2024.
//

import Foundation
import Alamofire

protocol TrelloServiceProtocol {
    func fetchBoards() async throws -> [Board]
    func fetchLists(forBoard boardId: String) async throws -> [Lists]
    func fetchCard(card cardId: String) async throws -> Card
    func deleteCard(card cardId: String) async throws
    func updateCardDescription(cardId: String, newDescription: String) async throws
}
