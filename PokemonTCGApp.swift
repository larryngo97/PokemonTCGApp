//
//  PokemonTCGAppApp.swift
//  PokemonTCGApp
//
//  Created by NGO, LARRY on 3/15/23.
//

import SwiftUI
import ComposableArchitecture
import ComposableCoreLocation

@main
struct PokemonTCGApp: App {
    var body: some Scene {
      WindowGroup {
        SetsListView(
          store: Store(
            initialState: SetsListFeature.State(),
            reducer: SetsListFeature()
            )
          )
      }
    }
}
