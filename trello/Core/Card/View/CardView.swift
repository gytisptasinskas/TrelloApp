//
//  CardView.swift
//  trello
//
//  Created by Gytis Ptasinskas on 23/02/2024.
//

import SwiftUI

struct CardView: View {
    let card: Card
    @StateObject private var viewModel = CardViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(card.name)
                    .font(.title).bold()
                    .padding(.leading)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(card.labels) { label in
                            Text(label.name)
                                .padding(8)
                                .background(Color.trelloColor(named: label.color.capitalized))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.vertical, 8)
                        }
                    }
                    .padding()
                }
                .background(Color(uiColor: .systemGroupedBackground))
                
                DescriptionEditor(descriptionText: $viewModel.descriptionText)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Button("Save") {
                                Task {
                                    print("MESSAGE WAS SENT")
                                    await viewModel.updateDescription(cardId: card.id, newDescription: viewModel.descriptionText)
                                }
                            }
                        }
                    }
            }
            .navigationTitle("Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Delete", systemImage: "trash") {
                    viewModel.isAlertShowned = true
                }
            }
            .task {
                await viewModel.fetchCard(cardId: card.id)
                print("CARD ID: \(card.id)")
            }
            .alert("Are you sure?", isPresented: $viewModel.isAlertShowned) {
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deleteCard(cardId: card.id)
                        dismiss()
                    }
                }
                
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    // MARK: - Description Editor View
    private func DescriptionEditor(descriptionText: Binding<String>) -> some View {
        return VStack(alignment: .leading) {
            Text("Description")
                .font(.headline)
                .foregroundColor(.gray)
            
            TextEditor(text: descriptionText)
            
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 6).stroke(.gray, lineWidth: 1)
        }
        .padding(20)
    }
}

//#Preview {
//    CardView(card: Card())
//}
