//
//  Mockable.swift
//  trelloTests
//
//  Created by Gytis Ptasinskas on 27/02/2024.
//

import Foundation

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    
    func loadJson<T: Decodable>(filename fileName: String, type: T.Type) throws -> T
}

extension Mockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    func loadJson<T: Decodable>(filename fileName: String, type: T.Type) throws -> T {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw NSError(domain: "FileNotFound", code: 404, userInfo: nil)
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(T.self, from: data)
            return jsonData
        } catch {
            throw error
        }
    }
}

