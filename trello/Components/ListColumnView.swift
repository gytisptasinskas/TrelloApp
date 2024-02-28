//
//  ListsRowView.swift
//  trello
//
//  Created by Gytis Ptasinskas on 26/02/2024.
//

import SwiftUI

struct ListColumnView: View {
    let list: [Lists]
    var body: some View {
        ForEach(list) { list in
            Text(list.name)
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(list.cards ?? [] ) { card in
                    NavigationLink {
                        CardView(card: card)
                    } label: {
                        CardRowView(card: card)
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)

                    }
                }
            }
        }
    }
}

#Preview {
    ListColumnView(list: [Lists(id: "1", name: "iOS", cards: [Card(id: "1", name: "Test Card", labels: [], desc: "iOS")])])
}
