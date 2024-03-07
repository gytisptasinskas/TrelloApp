//
//  WebAuthSessionProtocol.swift
//  trello
//
//  Created by Gytis Ptasinskas on 29/02/2024.
//

import Foundation

protocol WebAuthSessionProtocol {
    func start()
    func configure(url: URL, callbackURLScheme: String?, completion: @escaping (URL?, Error?) -> Void)
}

