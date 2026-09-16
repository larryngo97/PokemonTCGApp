//
//  APIEndpoints.swift
//  PokemonTCG
//
//  Created by NGO, LARRY on 5/25/23.
//

import Foundation

enum APIEndpoints {
    case getSets
    case getSetCards(setID: String, page: Int)
}

extension APIEndpoints: Endpoint {
    var baseURL: String {
        return "https://api.pokemontcg.io/v2"
    }
    
    var path: String {
        switch self {
        case .getSets:
            return "sets?orderBy=releaseDate"
        case .getSetCards(let setID, let page):
            return "cards?q=set.id:\(setID)&orderBy=number&page=\(page)"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getSets:
            return []
        case .getSetCards(let setID, let page):
            return []
        }
    }
}
