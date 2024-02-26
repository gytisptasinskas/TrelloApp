//
//  AuthView.swift
//  trello
//
//  Created by Gytis Ptasinskas on 23/02/2024.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        VStack {
            if viewModel.isAuthenticated {
                EmptyView()
            } else {
                Button("Authenticate with Trello") {
                    Task {
                        await viewModel.authenticateWithTrello()
                    }
                }
            }
        }
    }
}

#Preview {
    AuthView()
}
