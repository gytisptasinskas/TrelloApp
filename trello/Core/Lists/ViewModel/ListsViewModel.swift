//
//  ListsViewModel.swift
//  trello
//
//  Created by Gytis Ptasinskas on 23/02/2024.
//

import Foundation

@MainActor
class ListsViewModel: ObservableObject {
    @Published var lists: [Lists] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var state: ViewState = .loading

    private var service = TrelloService()
    
    func fetchLists(forBoard boardId: String) async {
        state = .loading
        
        do {
            let fetchedLists = try await service.fetchLists(forBoard: boardId)
            if fetchedLists.isEmpty {
                state = .empty
            } else {
                self.lists = fetchedLists
                state = .success
            }
        } catch {
            self.errorMessage = error.localizedDescription
            state = .failure(errorMessage ?? "An error occurred")
        }
    }
}

enum ViewState {
    case loading
    case success
    case failure(String)
    case empty
}
