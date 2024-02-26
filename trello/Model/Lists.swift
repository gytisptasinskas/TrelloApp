//
//  Lists.swift
//  trello
//
//  Created by Gytis Ptasinskas on 23/02/2024.
//

import Foundation

struct Lists: Codable, Identifiable {
    let id: String
    let name: String
    var cards: [Card]?
}

struct Card: Identifiable, Codable {
    let id: String
    let name: String
    let labels: [Label]
    let desc: String
    
    struct Label: Identifiable, Codable {
        let id: String
        let name: String
        let color: String
    }
}
