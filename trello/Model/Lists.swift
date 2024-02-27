//
//  Lists.swift
//  trello
//
//  Created by Gytis Ptasinskas on 23/02/2024.
//

import Foundation

struct Lists: Codable, Identifiable, Equatable {    
    let id: String
    let name: String
    var cards: [Card]?
    
    init(id: String, name: String, cards: [Card]? = nil) {
        self.id = id
        self.name = name
        self.cards = cards
    }
}
