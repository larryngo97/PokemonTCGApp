//
//  SetsListView.swift
//  PokemonTCG
//
//  Created by NGO, LARRY on 3/28/23.
//

import SwiftUI
import ComposableArchitecture

struct SetsListView: View {
    let imageDimensions: Double = 150
    let textDimensionsHeight: Double = 50
    let store: StoreOf<SetsListFeature>
    var columns = [GridItem(.adaptive(minimum: 150), spacing: 16, alignment: .center)]
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                if(viewStore.isError) {
                    Text("Failed to load page")
                        .multilineTextAlignment(.center)
                        .bold()
                    
                    Spacer().frame(height: 8)
                    
                    Text("Please check your internet connection.")
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 8)
                    
                    Button("Try Again") {
                        viewStore.send(.onAppear)
                    }
                } else if (viewStore.isLoading){
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    NavigationStack {
                        VStack {
                            if (viewStore.showEmptyResults) {
                                Spacer()
                                Image("not_found_icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: imageDimensions / 2, height: imageDimensions / 2)
                                
                                Spacer().frame(height: 8)
                                
                                Text("Could Not Find Set")
                                    .multilineTextAlignment(.center)
                                    .bold()
                                
                                Spacer().frame(height: 8)
                                
                                Text("Please try again.")
                                    .multilineTextAlignment(.center)
                                Spacer()
                            } else {
                                ScrollView {
                                    LazyVGrid(columns: columns, spacing: 16) {
                                        ForEach(viewStore.setsFiltered.reversed()) { setItem in
                                            NavigationLink(
                                                destination: {
                                                    SetPageView(
                                                        store: Store(
                                                            initialState: SetPageFeature.State(setData: setItem),
                                                            reducer: SetPageFeature(setData: setItem)
                                                        )
                                                    )
                                                },
                                                label: {
                                                    gridItem(setItem: setItem)
                                                }
                                            )
                                        }
                                    }.padding(24)
                                }
                            }
                        }
                    }
                }
            }.onAppear {
                viewStore.send(.onAppear)
            }.searchable(text: viewStore.$searchText)
        }
    }
    
    @ViewBuilder
    func gridItem(setItem: SetData) -> some View {

        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: imageDimensions, height: imageDimensions)
                    .overlay(
                        Rectangle().stroke(Color.blue, lineWidth: 1)
                    )
                AsyncImage(url: URL(string: setItem.images.logo )) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                    }
                    else if phase.error != nil {
                        Image("set_logo_default")
                            .resizable()
                            .scaledToFit()
                    }
                    else {
                        ProgressView()
                    }
                    
                }
                .frame(width: imageDimensions, height: imageDimensions)
            }
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: imageDimensions, height:textDimensionsHeight)
                    .overlay(
                        Rectangle().stroke(Color.blue, lineWidth: 1)
                    )
                Text("\(setItem.name)")
                    .frame(width: imageDimensions, height: textDimensionsHeight, alignment: .center)
                    .multilineTextAlignment(.center)
                    .bold()
            }
        }
    }
}
