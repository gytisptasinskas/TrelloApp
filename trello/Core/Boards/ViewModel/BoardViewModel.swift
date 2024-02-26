//
//  BoardsViewModel.swift
//  trello
//
//  Created by Gytis Ptasinskas on 22/02/2024.
//

import Foundation

@MainActor
class BoardViewModel: ObservableObject {
    @Published var boards: [Board] = []
    @Published var filteredBoards: [Board] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = "" {
        didSet {
            filterBoards()
        }
    }
    
    private var service = TrelloService()
    
    func fetchBoards() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                boards = try await service.fetchBoards()
                filteredBoards = boards
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    private func filterBoards() {
        if searchText.isEmpty {
            filteredBoards = boards
        } else {
            filteredBoards = boards.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

