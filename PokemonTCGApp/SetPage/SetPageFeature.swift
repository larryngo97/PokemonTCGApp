//
//  SetPageFeature.swift
//  PokemonTCG
//
//  Created by NGO, LARRY on 4/13/23.
//

import Foundation
import Combine
import ComposableArchitecture

struct SetPageFeature: ReducerProtocol {
    let setData: SetData
    @Dependency(\.networkManager) var networkManager
    
    struct State: Equatable {
        var setData: SetData
        var cards: SetCards? = nil
        var cardsSorted: [Card]? = []
        var isLoading = false
        var isError = false
        
        var pageCount = 1
        var pageCardCount = 0
    }
    
    enum Action: Equatable {
        case onAppear
        case sortCards(CardsOrderType, CardsOrderDirection)
        case endPointResponse(TaskResult<SetCards>)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .sortCards(let type, let direction):
            var data = {
                switch type {
                case .order:
                    return state.cards?.data.sorted {
                        Int($0.number ?? "0") ?? 0 < Int($1.number ?? "0") ?? 0
                    } ?? []
                case .name:
                    return state.cards?.data.sorted {
                        $0.name < $1.name
                    } ?? []
                case .price:
                    return state.cards?.data.sorted {
                        if($0.cardmarket.prices.avg7 == $1.cardmarket.prices.avg7) {
                            return $0.id < $1.id
                        }
                        return $0.cardmarket.prices.avg7 ?? 0.00 < $1.cardmarket.prices.avg7 ?? 0.00
                    } ?? []
                    
                }
            }()
            
            switch direction {
            case .ascending:
                state.cardsSorted = data
            case .descending:
                state.cardsSorted = data.reversed()
            }
            return .none
        case .onAppear:
            state.setData = setData
            state.cards = nil
            state.isLoading = true
            state.isError = false
            state.pageCount = 1
            state.pageCardCount = 0

            let endpoint = APIEndpoints.getSetCards(setID: setData.id, page: state.pageCount)

            let endpointPublisher: AnyPublisher<SetCards, APIError> = networkManager.fetchData(endpoint: endpoint)
            
            return .task {
                await .endPointResponse(TaskResult { try await endpointPublisher
                        .map({$0})
                        .eraseToAnyPublisher()
                    .async()})
            }
        case .endPointResponse(.failure(let error)):
            print(error.localizedDescription)
            state.isLoading = false
            state.isError = true
            return .none
        case .endPointResponse(.success(let set)):
            //print(set.data)
            if(state.cards == nil) {
                state.cards = SetCards(data: [], page: 1, count: 0, totalCount: 0)
            }
            state.cards?.data.append(contentsOf: set.data)
            state.cardsSorted = state.cards?.data
            print(state.cards?.data)
            state.pageCardCount += set.count
            if(state.pageCardCount < set.totalCount) {
                state.pageCount += 1
                
                let endpoint = APIEndpoints.getSetCards(setID: setData.id, page: state.pageCount)
                
                let endpointPublisher: AnyPublisher<SetCards, APIError> = networkManager.fetchData(endpoint: endpoint)
                
                return .task {
                    await .endPointResponse(TaskResult { try await endpointPublisher
                            .map({$0})
                            .eraseToAnyPublisher()
                        .async()})
                }
            } else {
                state.isError = false
                state.isLoading = false
                return .none
            }
        }
    }
}
