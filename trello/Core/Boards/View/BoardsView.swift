//
//  BoardsView.swift
//  trello
//
//  Created by Gytis Ptasinskas on 22/02/2024.
//

import SwiftUI

struct BoardsView: View {
    @StateObject private var viewModel = BoardViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                } else {
                    List(viewModel.filteredBoards, id: \.id) { board in
                        NavigationLink {
                            ListsView(board: board)
                        } label: {
                            Text(board.name)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .onAppear {
                viewModel.fetchBoards()
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Boards")
            .searchable(text: $viewModel.searchText)

        }
    }
}

#Preview {
    BoardsView()
}
