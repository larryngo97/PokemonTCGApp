//
//  SetPageModel.swift
//  PokemonTCG
//
//  Created by NGO, LARRY on 4/13/23.
//

import Foundation

struct SetCards: Decodable, Equatable {
    var data: [Card]
    var page: Int
    var count: Int
    var totalCount: Int
}

enum CardsOrderType: String, CaseIterable, Identifiable {
    case order, name, price
    var id: Self { self }
}

enum CardsOrderDirection: String, CaseIterable, Identifiable {
    case ascending, descending
    var id: Self { self }
}

struct Card: Decodable, Equatable, Identifiable {
    let id: String
    let name: String
    let supertype: String?
    let subtypes: [String]?
    let hp: String?
    let types: [String]?
    let rules: [String]?
    let attacks: [CardAttacks]?
    let weaknesses: [CardWeakness]?
    let retreatCost: [String]?
    let number: String?
    let artist: String?
    let rarity: String?
    let legalities: CardLegalities?
    let regulationMark: String?
    let images: CardImages
    let tcgplayer: TCGPlayer
    let cardmarket: CardMarket
    
    struct CardMarket: Decodable, Equatable {
        let url: String
        let updatedAt: String
        let prices: CardMarketPrices
        
        struct CardMarketPrices: Decodable, Equatable {
            let averageSellPrice: Double?
            let lowPrice: Double?
            let trendPrice: Double?
            let germanProLow: Double?
            let suggestedPrice: Double?
            let reverseHoloSell: Double?
            let reverseHoloLow: Double?
            let reverseHoloTrend: Double?
            let lowPriceExPlus: Double?
            let avg1: Double?
            let avg7: Double?
            let avg30: Double?
            let reverseHoloAvg1: Double?
            let reverseHoloAvg7: Double?
            let reverseHoloAvg30: Double?
        }
    }
    
    struct TCGPlayer: Decodable, Equatable {
        let url: String
        let updatedAt: String
        let prices: TCGPlayerPriceType?
        
        struct TCGPlayerPriceType: Decodable, Equatable {
            let firstEditionHolofoil: TCGPlayerPriceValue?
            let unlimitedHolofoil: TCGPlayerPriceValue?
            let firstEdition: TCGPlayerPriceValue?
            let unlimited: TCGPlayerPriceValue?
            let holofoil: TCGPlayerPriceValue?
            let reverseHolofoil: TCGPlayerPriceValue?
            let normal: TCGPlayerPriceValue?
            
            enum CodingKeys: String, CodingKey {
                case firstEditionHolofoil = "1stEditionHolofoil"
                case firstEdition = "1stEdition"
                case unlimitedHolofoil
                case unlimited
                case normal
                case reverseHolofoil
                case holofoil
            }
            
            struct TCGPlayerPriceValue: Decodable, Equatable {
                let low: Double?
                let mid: Double?
                let high: Double?
                let market: Double?
                let directLow: Double?
            }
        }
    }
    
    struct CardImages: Decodable, Equatable {
        let small: String
        let large: String
    }
    
    struct CardLegalities: Decodable, Equatable {
        let unlimited: String?
        let standard: String?
        let expanded: String?
    }
    
    struct CardAttacks: Decodable, Equatable {
        let name: String
        let cost: [String]
        let convertedEnergyCost: Int
        let damage: String
        let text: String
    }
    
    struct CardWeakness: Decodable, Equatable {
        let type: String
        let value: String
    }
}
