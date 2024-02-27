//
//  CardViewModel.swift
//  trello
//
//  Created by Gytis Ptasinskas on 23/02/2024.
//

import Foundation

@MainActor
class CardViewModel: ObservableObject {
    @Published var descriptionText = ""
    @Published var card: Card?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var cardLabels: [String] = []
    @Published var isAlertShowned = false
    
    var service: TrelloServiceProtocol
    
    init(service: TrelloServiceProtocol) {
        self.service = service
    }
    
    func fetchCard(cardId: String) async {
        isLoading = true
        
        do {
            let fetchedCard = try await service.fetchCard(card: cardId)
            self.card = fetchedCard
            self.descriptionText = fetchedCard.desc
            self.cardLabels = fetchedCard.labels?.map { $0.name } ?? []
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    func deleteCard(cardId: String) async {
        do {
            try await service.deleteCard(card: cardId)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func updateDescription(cardId: String, newDescription: String) async {
        isLoading = true
        do {
            try await service.updateCardDescription(cardId: cardId, newDescription: newDescription)
                self.descriptionText = newDescription
                self.isLoading = false
        } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
        }
    }
}
