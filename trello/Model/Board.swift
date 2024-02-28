//
//  Board.swift
//  trello
//
//  Created by Gytis Ptasinskas on 22/02/2024.
//

import Foundation


struct Board: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let lists: [Lists]?
    
    init(id: String, name: String, lists: [Lists]? = nil) {
        self.id = id
        self.name = name
        self.lists = lists
    }
}
