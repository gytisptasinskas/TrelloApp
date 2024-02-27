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
    
    init(id: String, name: String) {
         self.id = id
         self.name = name
     }
}
