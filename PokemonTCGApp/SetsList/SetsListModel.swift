//
//  HomeModel.swift
//  PokemonTCG
//
//  Created by NGO, LARRY on 3/27/23.
//

import Foundation

struct SetsInfo: Decodable {
    var data: [SetData] = []
    let page: Int
    let pageSize: Int
    let count: Int
    let totalCount: Int

}

struct SetData: Decodable, Hashable, Identifiable {
    let id: String
    let name: String
    let series: String
    let printedTotal: Int
    let total: Int
    let releaseDate: String
    let images: SetImages
    
    struct SetImages: Decodable, Hashable {
        let symbol: String
        let logo: String
        
    }
}

