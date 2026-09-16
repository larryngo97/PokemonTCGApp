//
//  Endpoint.swift
//  PokemonTCG
//
//  Created by NGO, LARRY on 5/25/23.
//

import Foundation

public protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var url: URL { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var url: URL {
        var urlStr = baseURL + "/" + path
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        var url = URL(string: urlStr)!
        url.append(queryItems: queryItems)
        return url
    }
}

