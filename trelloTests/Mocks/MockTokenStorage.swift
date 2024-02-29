//
//  MockTokenStorage.swift
//  trelloTests
//
//  Created by Gytis Ptasinskas on 28/02/2024.
//

import Foundation
@testable import trello

class MockTokenStorage: TokenStorageProtocol {
    private var storedToken: String?
    
    func storeToken(_ token: String) {
        storedToken = token
        print("Mock: Stored token")
    }

    func retrieveToken() -> String? {
        if let token = storedToken {
            print("Mock: Retrieved token")
            return token
        } else {
            print("Mock: No token found")
            return nil
        }
    }
    
    func clearToken() {
        storedToken = nil
        print("Mock: Token cleared successfully")
    }
}

