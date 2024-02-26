//
//  CardRowView.swift
//  trello
//
//  Created by Gytis Ptasinskas on 26/02/2024.
//

import SwiftUI

struct CardRowView: View {
    let card: Card
    var body: some View {
        VStack(alignment: .leading) {
            Text(card.name)
                .font(.headline)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack(spacing: 5) {
                ForEach(card.labels, id: \.id) { label in
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.trelloColor(named: label.color.capitalized))
                }
            }
        }
    }
}

#Preview {
    CardRowView(card: Card(id: "1", name: "1", labels: [], desc: ""))
}
