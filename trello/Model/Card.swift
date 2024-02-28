//
//  Card.swift
//  trello
//
//  Created by Gytis Ptasinskas on 27/02/2024.
//

import Foundation

struct Card: Identifiable, Codable, Equatable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
           return lhs.id == rhs.id && lhs.name == rhs.name && lhs.desc == rhs.desc
       }
    
    let id: String
    let name: String
    let labels: [Label]?
    let desc: String
    
    struct Label: Identifiable, Codable {
        let id: String
        let name: String
        let color: String
    }
    
    init(id: String, name: String, labels: [Label]? = nil, desc: String) {
        self.id = id
        self.name = name
        self.labels = labels
        self.desc = desc
    }
}
