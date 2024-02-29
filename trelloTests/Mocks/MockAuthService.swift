//
//  MockAuthService.swift
//  trelloTests
//
//  Created by Gytis Ptasinskas on 28/02/2024.
//

import Foundation
@testable import trello
import AuthenticationServices

class MockAuthService: AuthServiceProtocol {
    var authenticateWithTrelloResult: Result<String, Error>?
    var extractTokenResult: String?
    var presentationAnchor: ASPresentationAnchor?
    
    func authenticateWithTrello() async throws -> String {
        guard let result = authenticateWithTrelloResult else {
            throw MockAuthServiceError.resultNotSet
        }
        
        switch result {
        case .success(let token):
            return token
        case .failure(let error):
            throw error
        }
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        if let anchor = presentationAnchor {
            return anchor
        } else {
            fatalError("presentationAnchor was not set.")
        }
    }
    
    func extractToken(from url: URL) -> String? {
        return extractTokenResult
    }
}

enum MockAuthServiceError: Error {
    case tokenExtractionFailed
    case resultNotSet
}
