//
//  ListsView.swift
//  trello
//
//  Created by Gytis Ptasinskas on 23/02/2024.
//

import SwiftUI

struct ListsView: View {
    let board: Board
    @StateObject private var viewModel = ListsViewModel(service: TrelloService())
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                case .success:
                        ListColumnView(list: viewModel.lists)
                case .failure(let message):
                    Text(message)
                default:
                    ContentUnavailableView("You don't have any boards to display", image: "no-content")
                }
            }
            .padding(.top)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle(board.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.fetchLists(board: board.id)
            }
        }
    }
}

#Preview {
    ListsView(board: Board(id: "1", name: "iOS", lists: []))
}
