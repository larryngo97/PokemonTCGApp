//
//  CardView.swift
//  PokemonTCG
//
//  Created by NGO, LARRY on 6/1/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import WebKit

struct CardPageView: View {
    let store: StoreOf<CardPageFeature>
    //let columns = Array(repeating: GridItem(.adaptive(minimum: 100)), count: 3)
    let columns = [GridItem(.adaptive(minimum: 100), spacing: 16)]
    @State var showWebView = false
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        AsyncImage(url: URL(string: viewStore.cardData.images.small)) { phase in
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
                        .frame(width: 150, height: 250)
                        Spacer()
                    }
                    
                    if(viewStore.cardData.tcgplayer.prices != nil) {
                        HStack {
                            Text("TCGPlayer Prices").font(.title2).bold()
                            Spacer()
                            Button("Buy"){
                                print(viewStore.cardData.tcgplayer.url)
                                if let url = URL(string: viewStore.cardData.tcgplayer.url) {
                                    openURL(url)
                                }
                                //showWebView.toggle()
                            }.buttonStyle(PrimaryButtonStyle())
                                .fullScreenCover(isPresented: $showWebView) {
                                    WebView(url: URL(string: viewStore.cardData.tcgplayer.url)!, showWebView: $showWebView)
                                }
                            
                        }.padding(.bottom, 4)
                        
                        Text("* Prices updated as of \(viewStore.cardData.tcgplayer.updatedAt), approximate, and NM")
                            .font(.caption)
                            .italic()
                            .padding(.bottom, 16)
                        
                        
                        if(viewStore.cardData.tcgplayer.prices!.firstEditionHolofoil != nil) {
                            HStack {
                                Spacer()
                                Text("1st Edition Holofoil")
                                    .font(.title2)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
                                gridItem(category: "Low", price: viewStore.cardData.tcgplayer.prices!.firstEditionHolofoil?.low)
                                gridItem(category: "Mid", price: viewStore.cardData.tcgplayer.prices!.firstEditionHolofoil?.mid)
                                gridItem(category: "High", price: viewStore.cardData.tcgplayer.prices!.firstEditionHolofoil?.high)
                                gridItem(category: "Market", price: viewStore.cardData.tcgplayer.prices!.firstEditionHolofoil?.market)
                                gridItem(category: "TCGDirect", price: viewStore.cardData.tcgplayer.prices!.firstEditionHolofoil?.directLow)
                            }.padding(.bottom, 16)
                        }
                        if(viewStore.cardData.tcgplayer.prices!.unlimitedHolofoil != nil) {
                            HStack {
                                Spacer()
                                Text("Unlimited Holofoil")
                                    .font(.title2)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
                                gridItem(category: "Low", price: viewStore.cardData.tcgplayer.prices!.unlimitedHolofoil?.low)
                                gridItem(category: "Mid", price: viewStore.cardData.tcgplayer.prices!.unlimitedHolofoil?.mid)
                                gridItem(category: "High", price: viewStore.cardData.tcgplayer.prices!.unlimitedHolofoil?.high)
                                gridItem(category: "Market", price: viewStore.cardData.tcgplayer.prices!.unlimitedHolofoil?.market)
                                gridItem(category: "TCGDirect", price: viewStore.cardData.tcgplayer.prices!.unlimitedHolofoil?.directLow)
                            }.padding(.bottom, 16)
                        }
                        if(viewStore.cardData.tcgplayer.prices!.firstEdition != nil) {
                            HStack {
                                Spacer()
                                Text("1st Edition")
                                    .font(.title2)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
                                gridItem(category: "Low", price: viewStore.cardData.tcgplayer.prices!.firstEdition?.low)
                                gridItem(category: "Mid", price: viewStore.cardData.tcgplayer.prices!.firstEdition?.mid)
                                gridItem(category: "High", price: viewStore.cardData.tcgplayer.prices!.firstEdition?.high)
                                gridItem(category: "Market", price: viewStore.cardData.tcgplayer.prices!.firstEdition?.market)
                                gridItem(category: "TCGDirect", price: viewStore.cardData.tcgplayer.prices!.firstEdition?.directLow)
                            }.padding(.bottom, 16)
                        }
                        if(viewStore.cardData.tcgplayer.prices!.unlimited != nil) {
                            HStack {
                                Spacer()
                                Text("Unlimited")
                                    .font(.title2)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
                                gridItem(category: "Low", price: viewStore.cardData.tcgplayer.prices!.unlimited?.low)
                                gridItem(category: "Mid", price: viewStore.cardData.tcgplayer.prices!.unlimited?.mid)
                                gridItem(category: "High", price: viewStore.cardData.tcgplayer.prices!.unlimited?.high)
                                gridItem(category: "Market", price: viewStore.cardData.tcgplayer.prices!.unlimited?.market)
                                gridItem(category: "TCGDirect", price: viewStore.cardData.tcgplayer.prices!.unlimited?.directLow)
                            }.padding(.bottom, 16)
                        }
                        if(viewStore.cardData.tcgplayer.prices!.holofoil != nil) {
                            HStack {
                                Spacer()
                                Text("Holofoil")
                                    .font(.title2)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
                                gridItem(category: "Low", price: viewStore.cardData.tcgplayer.prices!.holofoil?.low)
                                gridItem(category: "Mid", price: viewStore.cardData.tcgplayer.prices!.holofoil?.mid)
                                gridItem(category: "High", price: viewStore.cardData.tcgplayer.prices!.holofoil?.high)
                                gridItem(category: "Market", price: viewStore.cardData.tcgplayer.prices!.holofoil?.market)
                                gridItem(category: "TCGDirect", price: viewStore.cardData.tcgplayer.prices!.holofoil?.directLow)
                            }.padding(.bottom, 16)
                        }
                        if(viewStore.cardData.tcgplayer.prices!.reverseHolofoil != nil) {
                            HStack {
                                Spacer()
                                Text("Reverse Holofoil")
                                    .font(.title2)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
                                gridItem(category: "Low", price: viewStore.cardData.tcgplayer.prices!.reverseHolofoil?.low)
                                gridItem(category: "Mid", price: viewStore.cardData.tcgplayer.prices!.reverseHolofoil?.mid)
                                gridItem(category: "High", price: viewStore.cardData.tcgplayer.prices!.reverseHolofoil?.high)
                                gridItem(category: "Market", price: viewStore.cardData.tcgplayer.prices!.reverseHolofoil?.market)
                                gridItem(category: "TCGDirect", price: viewStore.cardData.tcgplayer.prices!.reverseHolofoil?.directLow)
                            }.padding(.bottom, 16)
                        }
                        if(viewStore.cardData.tcgplayer.prices!.normal != nil) {
                            HStack {
                                Spacer()
                                Text("Normal")
                                    .font(.title2)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
                                gridItem(category: "Low", price: viewStore.cardData.tcgplayer.prices!.normal?.low)
                                gridItem(category: "Mid", price: viewStore.cardData.tcgplayer.prices!.normal?.mid)
                                gridItem(category: "High", price: viewStore.cardData.tcgplayer.prices!.normal?.high)
                                gridItem(category: "Market", price: viewStore.cardData.tcgplayer.prices!.normal?.market)
                                gridItem(category: "TCGDirect", price: viewStore.cardData.tcgplayer.prices!.normal?.directLow)
                            }.padding(.bottom, 16)
                        }
                    } else {
                        Text("NULL")
                    }
                }.padding(.horizontal)
                .onAppear {
                    viewStore.send(.onAppear)
                }.navigationBarTitle(viewStore.cardData.name)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    @ViewBuilder
    func gridItem(category: String, price: Double?) -> some View {
        ZStack(alignment: .center) {
            Rectangle().fill(.background).shadow(radius: 3, y: 3)
            
            VStack {
                Text(category)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.4)
                    .padding(.top, 16)
                Spacer()
                Text(getPriceText(price: price))
                    .foregroundColor(.blue)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.4)
                    .padding(.bottom, 8)
            }
        }.frame(width: 100, height: 120)
    }
    
    struct WebView: UIViewRepresentable {
        var url: URL
        @Binding var showWebView: Bool
        
        func makeUIView(context: Context) -> WKWebView {
            let wkWebView = WKWebView()
            return wkWebView
        }
        
        func updateUIView(_ webView: WKWebView, context: Context) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    
    func getPriceText(price: Double?) -> String {
        if(price != nil) {
            return "$" + String(format: "%.2f", price ?? 0.00)
        } else {
            return "N/A"
        }
    }
    
    public struct PrimaryButtonStyle: ButtonStyle {
        
        public func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .textCase(.uppercase)
                .foregroundColor(.white)
                .font(Font.body.weight(.semibold))
                .frame(maxWidth: 80, alignment: .center)
                .padding()
                .background(Color.accentColor.opacity(configuration.isPressed ? 0.7 : 1))
                .frame(height: 32)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
