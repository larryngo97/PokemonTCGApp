//
//  SetsListFeature.swift
//  PokemonTCG
//
//  Created by NGO, LARRY on 3/28/23.
//

import Foundation
import Combine
import ComposableArchitecture

struct SetsListFeature: ReducerProtocol {
    @Dependency(\.networkManager) var networkManager
    
    struct State: Equatable {
        var sets: [SetData] = []
        var setsFiltered: [SetData] = []
        @BindingState var searchText: String = ""
        var isLoading = false
        var isError = false
        var showEmptyResults = false
    }
    
    enum Action: BindableAction {
        case onAppear
        case endPointResponse(TaskResult<SetsInfo>)
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                state.isError = false
                
                let endpoint = APIEndpoints.getSets
                
                let endpointPublisher: AnyPublisher<SetsInfo, APIError> =
                networkManager.fetchData(endpoint: endpoint)
                
                return .task {
                    await .endPointResponse(TaskResult { try await endpointPublisher
                            .map({$0})
                            .eraseToAnyPublisher()
                        .async()})
                }
            case .endPointResponse(.failure(let error)):
                state.isLoading = false
                state.isError = true
                return .none
            case .endPointResponse(.success(let sets)):
                state.sets = sets.data
                state.setsFiltered = sets.data
                state.isLoading = false
                state.isError = false
            case .binding(\.$searchText):
                if(state.searchText.isEmpty) {
                    state.setsFiltered = state.sets
                } else {
                    state.setsFiltered = state.sets.filter { $0.name.contains(state.searchText) }
                }
                state.showEmptyResults = (state.setsFiltered.isEmpty && !state.searchText.isEmpty && state.isError == false)
                return .none
            case .binding:
                return .none
            }
            return .none
        }
    }
    
}
