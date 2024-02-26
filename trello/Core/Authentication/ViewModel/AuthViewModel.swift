//
//  AuthViewModel.swift
//  trello
//
//  Created by Gytis Ptasinskas on 22/02/2024.
//

import Foundation
import Alamofire
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var isAuthenticated = false
    private var authService = AuthService()
    private let tokenStorage = TokenStorage()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Task {
            await authenticateIfPossible()
        }
    }
    
    func authenticateIfPossible() async {
        guard let token = tokenStorage.retrieveToken(), !token.isEmpty else {
            self.isAuthenticated = false
            return
        }
        validateToken(token)
    }
    
    func authenticateWithTrello() async {
        do {
            let token = try await authService.authenticateWithTrello()
            tokenStorage.storeToken(token)
            self.isAuthenticated = true
        } catch {
            self.isAuthenticated = false
        }
    }
    
    private func validateToken(_ token: String) {
        let url = "https://api.trello.com/1/members/me"
        let parameters: [String: String] = [
            "key": ProcessInfo.processInfo.environment["API_KEY"] ?? "",
            "token": token
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            switch response.result {
            case .success:
                print("Token is valid.")
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            case .failure:
                print("Token validation failed or token is invalid.")
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                    self.tokenStorage.clearToken()
                    print("Token has been cleared.")
                }
            }
        }
    }
}
