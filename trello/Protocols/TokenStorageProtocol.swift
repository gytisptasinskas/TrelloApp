//
//  TokenStorageProtocol.swift
//  trello
//
//  Created by Gytis Ptasinskas on 28/02/2024.
//

import Foundation

protocol TokenStorageProtocol {
    func storeToken(_ token: String)
    func retrieveToken() -> String?
    func clearToken()
}
