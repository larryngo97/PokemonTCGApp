//
//  Networkable.swift
//  PokemonTCG
//
//  Created by NGO, LARRY on 5/25/23.
//

import Foundation
import Combine

protocol Networkable {
    func fetchData<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, APIError>
}
