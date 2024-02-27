//
//  AuthView.swift
//  trello
//
//  Created by Gytis Ptasinskas on 23/02/2024.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isAuthenticating = false
    @State private var shouldAuthenticate = false
    
    var body: some View {
        VStack {
            if viewModel.isAuthenticated {
                BoardsView()
            } else {
                ContentUnavailableView("You don't have any boards to display", image: "no-content")
                    .task {
                        if shouldAuthenticate && !isAuthenticating {
                            isAuthenticating = true
                            await viewModel.authenticateWithTrello()
                            isAuthenticating = false
                            shouldAuthenticate = false
                        }
                    }
                    .onTapGesture {
                        Task {
                           await viewModel.authenticateWithTrello()
                        }
                    }
            }
        }
        .onChange(of: viewModel.isAuthenticated) { isAuthenticated in
            if !isAuthenticated {
                shouldAuthenticate = true
            }
        }
    }
}

#Preview {
    AuthView()
}
