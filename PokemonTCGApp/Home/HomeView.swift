//
//  ContentView.swift
//  PokemonTCGApp
//
//  Created by NGO, LARRY on 3/15/23.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
  let store: StoreOf<SetsListFeature>
  var body: some View {
      WithViewStore(self.store) { viewStore in
      TabView {
          SetsListView(
            store: Store(
                initialState: SetsListFeature.State(),
                reducer: SetsListFeature()
            )
          )
          .tabItem {
            Image(systemName: "menucard.fill")
            Text("Sets")
          }

        Color.clear
          .tabItem {
            Image(systemName: "rectangle.portrait.on.rectangle.portrait.fill")
            Text("Collection")
          }

      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    let rootView = HomeView(
      store: Store(
        initialState: SetsListFeature.State(),
        reducer: SetsListFeature()
        )
      )
    return rootView
  }
}
