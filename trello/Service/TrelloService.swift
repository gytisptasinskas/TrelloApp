//
//  TrelloService.swift
//  trello
//
//  Created by Gytis Ptasinskas on 23/02/2024.
//

import Foundation
import Alamofire

class TrelloService {
    private let baseURL = "https://api.trello.com/1"
    
    let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
    let token = TokenStorage().retrieveToken()
    
    // MARK: - Board Functions
    func fetchBoards() async throws -> [Board] {
        guard let token = token else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Authentication token is missing"])
        }

        let url = "\(baseURL)/members/me/boards"
        let parameters = ["key": apiKey, "token": token]

        return try await AF.request(url, parameters: parameters).serializingDecodable([Board].self).value
    }
    
    // MARK: - List Functions
    func fetchLists(forBoard boardId: String) async throws -> [Lists] {
            guard let token = token else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Authentication token is missing"])
            }

            let url = "\(baseURL)/boards/\(boardId)/lists"
            let parameters: [String: String] = ["key": apiKey, "token": token, "cards": "all"]

            let lists: [Lists] = try await AF.request(url, parameters: parameters).serializingDecodable([Lists].self).value
            return lists
        }
    
    // MARK: - Card Functions
    func fetchCard(card cardId: String) async throws -> Card {
        guard let token = token else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Authentication token is missing"])
        }
        
        let url = "\(baseURL)/cards/\(cardId)"
        let parameters: [String: String] = ["key": apiKey, "token": token]
        
        let card: Card = try await AF.request(url, parameters: parameters).serializingDecodable(Card.self).value
        return card
    }
    
    func deleteCard(card cardId: String) async throws {
        guard let token = token else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Authentication token is missing"])
        }
        
        let url = "\(baseURL)/cards/\(cardId)"
        let parameters: [String: String] = ["key": apiKey, "token": token]
        
        _ = try await AF.request(url, method: .delete, parameters: parameters).serializingDecodable(Card.self).value
    }
    
    func updateCardDescription(cardId: String, newDescription: String) async throws {
        guard let token = token else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Authentication token is missing"])
        }

        let url = "\(baseURL)/cards/\(cardId)"
        let parameters: [String: String] = ["key": apiKey, "token": token, "desc": newDescription]

        do {
            let response = try await AF.request(url, method: .put, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).validate().serializingDecodable(Card.self).value
        } catch {
            throw error
        }
    }
}
