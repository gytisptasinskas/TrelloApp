//
//  MockAuthWebSession.swift
//  trelloTests
//
//  Created by Gytis Ptasinskas on 29/02/2024.
//

import Foundation
@testable import trello

class MockWebAuthSession: WebAuthSessionProtocol {
    var shouldSucceed: Bool
    var mockToken: String?
    var mockError: Error?
    
    init(shouldSucceed: Bool, mockToken: String? = nil, mockError: Error? = nil) {
        self.shouldSucceed = shouldSucceed
        self.mockToken = mockToken
        self.mockError = mockError
    }
    
    func start() {
        // The `start` method doesn't need to do anything in the mock,
        // as the completion behavior is simulated in `configure`.
    }
    
    func configure(url: URL, callbackURLScheme: String?, completion: @escaping (URL?, Error?) -> Void) {
        if shouldSucceed, let token = mockToken {
            let mockURL = URL(string: "\(callbackURLScheme ?? "")://callback#token=\(token)")!
            completion(mockURL, nil)
        } else if let error = mockError {
            completion(nil, error)
        }
    }
}
