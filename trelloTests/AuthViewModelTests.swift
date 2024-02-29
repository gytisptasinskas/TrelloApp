//
//  AuthViewModelTests.swift
//  trelloTests
//
//  Created by Gytis Ptasinskas on 28/02/2024.
//

import XCTest
@testable import trello

@MainActor
final class AuthViewModelTests: XCTestCase {
    
    private var viewModel: AuthViewModel!
    private var mockAuthService: MockAuthService!
    private var mockTokenStorage: MockTokenStorage!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        mockTokenStorage = MockTokenStorage()
        viewModel = AuthViewModel(service: mockAuthService, tokenStorage: mockTokenStorage)
    }
    
    // MARK: - Tear down
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        mockAuthService = nil
        mockTokenStorage = nil
    }
    
    // MARK: - Test Functions
    func testAuthenticateWithTrelloSuccess() async {
        // Ensure the result is set before the method call
        mockAuthService.authenticateWithTrelloResult = .success("validToken")
        
        await viewModel.authenticateWithTrello()
        
        XCTAssertTrue(viewModel.isAuthenticated, "The viewModel should be marked as authenticated.")
    }

    func testAuthenticateWithTrelloFailure() async {
        mockAuthService.authenticateWithTrelloResult = .failure(MockAuthServiceError.tokenExtractionFailed)
        
        await viewModel.authenticateWithTrello()
        
        XCTAssertFalse(viewModel.isAuthenticated, "The viewModel should not be marked as authenticated.")
    }
    
    func testAuthenticateWithTrelloResultNotSet() async {
        do {
            let _ = try await mockAuthService.authenticateWithTrello()
            XCTFail("Expected .resultNotSet error to be thrown")
        } catch MockAuthServiceError.resultNotSet {
            // Test passes if this error is thrown
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testTokenRetrievalSuccess() {
        // Pre-set a token in the mock storage
        let expectedToken = "validToken"
        mockTokenStorage.storeToken(expectedToken)
        
        // Attempt to retrieve the token
        let retrievedToken = viewModel.tokenStorage.retrieveToken()
        
        // Validate the token was retrieved successfully
        XCTAssertEqual(retrievedToken, expectedToken, "The retrieved token should match the expected token.")
    }
    
    func testTokenRetrievalFailure() {
        // Ensure no token is set in the mock storage
        mockTokenStorage.clearToken()
        
        // Attempt to retrieve the token
        let retrievedToken = viewModel.tokenStorage.retrieveToken()
        
        // Validate that no token is retrieved
        XCTAssertNil(retrievedToken, "No token should be retrieved when none is set.")
    }
}
