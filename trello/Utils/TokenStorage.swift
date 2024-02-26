//
//  TokenStorage.swift
//  trello
//
//  Created by Gytis Ptasinskas on 23/02/2024.
//

import Foundation
import KeychainAccess

class TokenStorage {
    private let keychain = Keychain(service: "com.gytisptasinskas.trello")

    func storeToken(_ token: String) {
         do {
             try keychain.set(token, key: "oauthToken")
         } catch {
             print("Error storing token: \(error)")
         }
     }

     func retrieveToken() -> String? {
         do {
             let token = try keychain.get("oauthToken")
             if let token = token {
                 
             } else {
                 print("No token found in Keychain")
             }
             return token
         } catch {
             print("Error retrieving token: \(error)")
             return nil
         }
     }
    
    func clearToken() {
        do {
            try keychain.remove("oauthToken")
            print("Token cleared successfully")
        } catch {
            print("Error clearing token: \(error)")
        }
    }
}
