//
//  CardViewFeature.swift
//  PokemonTCG
//
//  Created by NGO, LARRY on 6/1/23.
//

import Foundation
import Combine
import ComposableArchitecture

struct CardPageFeature: ReducerProtocol {
    let cardData: Card
    
    struct State: Equatable {
        var cardData: Card
    }
    
    enum Action: Equatable {
        case onAppear
        case launchWeb
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            state.cardData = cardData
            return .none
        case .launchWeb:
            return .none
        }
    }
}
