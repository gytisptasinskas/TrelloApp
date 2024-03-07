//
//  AuthService.swift
//  trello
//
//  Created by Gytis Ptasinskas on 23/02/2024.
//

import Foundation
import AuthenticationServices

class AuthService: NSObject, AuthServiceProtocol {
    
    private let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
    private var tokenStorage = TokenStorage()
    private let callbackScheme = "trelloapp"
    private var webAuthSession: WebAuthSessionProtocol
    
    init(webAuthSession: WebAuthSessionProtocol) {
        self.webAuthSession = webAuthSession
    }
    func authenticateWithTrello() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                let scope = "read,write"
                let callbackURL = "\(self.callbackScheme)://callback"
                let callbackMethod = "fragment"
                
                guard let authURL = URL(string: "https://trello.com/1/authorize?expiration=never&name=MyPersonalToken&scope=\(scope)&response_type=token&key=\(self.apiKey)&return_url=\(callbackURL)&callback_method=\(callbackMethod)") else {
                    continuation.resume(throwing: AuthServiceError.invalidURL)
                    return
                }
                
                self.webAuthSession.configure(url: authURL, callbackURLScheme: self.callbackScheme) { callbackURL, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    guard let callbackURL = callbackURL, let token = self.extractToken(from: callbackURL) else {
                        continuation.resume(throwing: AuthServiceError.tokenExtractionFailed)
                        return
                    }
                    
                    continuation.resume(returning: token)
                }
                
                self.webAuthSession.start()
            }
        }
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = scene.windows.first(where: \.isKeyWindow) else {
            fatalError("Active UIWindowScene or key window not found.")
        }
        return window
    }
    
    func extractToken(from url: URL) -> String? {
        guard let fragment = url.fragment,
              let tokenPrefix = fragment.components(separatedBy: "&").first(where: { $0.starts(with: "token=") }) else { return nil }
        let token = String(tokenPrefix.dropFirst("token=".count))
        return token
    }
}

enum AuthServiceError: Error {
    case invalidURL
    case tokenExtractionFailed
}

class WebAuthSession: NSObject, WebAuthSessionProtocol, ASWebAuthenticationPresentationContextProviding {
    private var session: ASWebAuthenticationSession?
    private var completionHandler: ((URL?, Error?) -> Void)?
    
    func configure(url: URL, callbackURLScheme: String?, completion: @escaping (URL?, Error?) -> Void) {
        self.completionHandler = completion
        self.session = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackURLScheme) { callbackURL, error in
            self.completionHandler?(callbackURL, error)
        }
        self.session?.presentationContextProvider = self
    }
    
    func start() {
        self.session?.start()
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = scene.windows.first(where: \.isKeyWindow) else {
            fatalError("Active UIWindowScene or key window not found.")
        }
        return window
    }
}

