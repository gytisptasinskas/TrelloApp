//
//  AuthServiceTests.swift
//  trelloTests
//
//  Created by Gytis Ptasinskas on 28/02/2024.
//

import XCTest
@testable import trello
import OHHTTPStubsSwift
import OHHTTPStubs
import Alamofire

class AuthServiceTests: XCTestCase {
    var authService: AuthService!
    var mockWebAuthSession: MockWebAuthSession!
    
    override func setUp() {
        super.setUp()
        mockWebAuthSession = MockWebAuthSession(shouldSucceed: true, mockToken: "123456")
        authService = AuthService(webAuthSession: mockWebAuthSession)
    }
    
    func testAuthenticateWithTrelloSuccess() async throws {
        let token = try await authService.authenticateWithTrello()
        XCTAssertEqual(token, "123456", "The token received from authentication should match the mock token.")
    }
    
    func testAuthenticateWithTrelloFailure() async {
        mockWebAuthSession.shouldSucceed = false
        mockWebAuthSession.mockError = AuthServiceError.tokenExtractionFailed
        
        do {
            let _ = try await authService.authenticateWithTrello()
            XCTFail("Authentication should have failed but succeeded.")
        } catch AuthServiceError.tokenExtractionFailed {
            // Expected failure path
        } catch {
            XCTFail("Unexpected error type received.")
        }
    }
}
