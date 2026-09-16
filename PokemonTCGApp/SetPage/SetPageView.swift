//
//  SetPageView.swift
//  PokemonTCG
//
//  Created by NGO, LARRY on 4/13/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct SetPageView: View {
    let store: StoreOf<SetPageFeature>
    var columns = [GridItem(.adaptive(minimum: 110))]
    @State private var orderType: CardsOrderType = .order
    @State private var orderTypeDirection: CardsOrderDirection = .ascending
    
    
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
                }
                else if(viewStore.isLoading) {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Spacer()
                                ZStack(alignment: .top) {
                                    Circle()
                                        .fill(.background)
                                        .shadow(radius: 3, y: 3)
                                        .frame(width: 120, height: 120)
                                    AsyncImage(url: URL(string: viewStore.setData.images.logo)) { phase in
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
                                    .frame(width: 120, height: 120)
                                }.padding(.bottom, 16)
                                Spacer()
                            }
                            
                            Section(header: Text("Overview").font(.title2).bold()) {
                                ZStack(alignment: .center) {
                                    Rectangle().fill(.background).shadow(radius: 3, y: 3)
                                    VStack {
                                        HStack {
                                            Text("Release Date").font(.subheadline).fontWeight(.light)
                                            Spacer()
                                            Text(viewStore.setData.releaseDate)
                                                .multilineTextAlignment(.trailing)
                                                .font(.subheadline).fontWeight(.light)
                                        }.padding(.bottom, 8)
                                        HStack {
                                            Text("Cards").font(.subheadline).fontWeight(.light)
                                            Spacer()
                                            Text(String(viewStore.setData.printedTotal))
                                                .multilineTextAlignment(.trailing)
                                                .font(.subheadline).fontWeight(.light)
                                        }.padding(.bottom, 8)
                                        HStack {
                                            Text("Secret Rares").font(.subheadline).fontWeight(.light)
                                            Spacer()
                                            Text(String(viewStore.setData.total - viewStore.setData.printedTotal))
                                                .multilineTextAlignment(.trailing)
                                                .font(.subheadline).fontWeight(.light)
                                        }
                                    }.padding(.all)
                                }.padding(.all, 4)
                            }.padding(.bottom, 16)
                            
                            
                            Section(header: Text("Prices").font(.title2).bold()) {
                                ZStack(alignment: .center) {
                                    Rectangle().fill(.background).shadow(radius: 3, y: 3)
                                    VStack {
                                        let totalValue = viewStore.cards?.data.reduce(0) { $0 + ($1.cardmarket.prices.avg7 ?? 0.00) }
                                        let highestValue = viewStore.cards?.data.map { $0.cardmarket.prices.avg7 ?? 0.00 }.max()
                                        let averageValue = (totalValue ?? 0.00) / Double(viewStore.setData.total)
                                        HStack {
                                            Text("Total Value").font(.subheadline).fontWeight(.light)
                                            Spacer()
                                            Text("$\((totalValue ?? 0.00), specifier: "%.2f")")
                                                .multilineTextAlignment(.trailing)
                                                .font(.subheadline)
                                                .fontWeight(.light)
                                        }.padding(.bottom, 8)
                                        HStack {
                                            Text("Highest").font(.subheadline).fontWeight(.light)
                                            Spacer()
                                            Text("$\((highestValue ?? 0.00), specifier: "%.2f")")
                                                .multilineTextAlignment(.trailing)
                                                .font(.subheadline)
                                                .fontWeight(.light)
                                        }.padding(.bottom, 8)
                                        HStack {
                                            Text("Average").font(.subheadline).fontWeight(.light)
                                            Spacer()
                                            Text("$\((averageValue), specifier: "%.2f")")
                                                .multilineTextAlignment(.trailing)
                                                .font(.subheadline)
                                                .fontWeight(.light)
                                        }
                                    }.padding(.all)
                                }.padding(.all, 4)
                                Text("* Prices are based on average sale data within 7 days").font(.caption).italic()
                            }.padding(.bottom, 16)
                            
                            
                            Section(header: Text("Cards").font(.title2).bold()) {
                                Picker("Order", selection: $orderType) {
                                    ForEach(CardsOrderType.allCases) { order in
                                        Text(order.rawValue.capitalized)
                                    }
                                }.onChange(of: orderType, perform: { _ in
                                    viewStore.send(.sortCards(orderType, orderTypeDirection))
                                })
                                .padding(.vertical, 8)
                                Picker("Direction", selection: $orderTypeDirection) {
                                    ForEach(CardsOrderDirection.allCases) { direction in
                                        Text(direction.rawValue.capitalized)
                                    }
                                }.onChange(of: orderTypeDirection, perform: { _ in
                                    viewStore.send(.sortCards(orderType, orderTypeDirection))
                                })
                                
                                LazyVGrid(columns: columns, alignment: .center) {
                                    ForEach(viewStore.cardsSorted ?? []) { card in
                                        VStack(alignment: .center, spacing: 0) {
                                            NavigationLink(
                                                destination: {
                                                    CardPageView(
                                                        store: Store(
                                                        initialState: CardPageFeature.State(cardData: card),
                                                        reducer: CardPageFeature(cardData: card)
                                                        )
                                                    )
                                                },
                                                label: {
                                                    AsyncImage(url: URL(string: card.images.small)) { phase in
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
                                                    .frame(width: 110, height: 190)
                                                    .padding(.bottom, 8)
                                                }
                                                    
                                            )
                                            Text(card.name)
                                                .padding(.bottom, 2)
                                                .multilineTextAlignment(.center)
                                            Text(singleCardPriceText(price: card.cardmarket.prices.avg7))
                                                .bold()
                                                .multilineTextAlignment(.center)
                                        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    }
                                }
                            }.pickerStyle(.segmented)
                        }
                    }
                }
            }.onAppear {
                viewStore.send(.onAppear)
            }.padding(.leading).padding(.trailing)
                .navigationBarTitle(viewStore.setData.name)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func singleCardPriceText(price: Double?) -> String {
        var cardPriceText = "N/A"
        if (price != nil) {
            cardPriceText = "$" + String(format: "%.2f", price ?? 0.00)
        }
        return cardPriceText
    }
}
