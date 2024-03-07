//
//  AuthServiceProtocol.swift
//  trello
//
//  Created by Gytis Ptasinskas on 28/02/2024.
//

import Foundation
import AuthenticationServices

protocol AuthServiceProtocol {
    func authenticateWithTrello() async throws -> String
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor
    func extractToken(from url: URL) -> String?
}
