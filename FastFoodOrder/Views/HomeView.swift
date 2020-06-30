//
//  HomeView.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/25/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import SwiftUI
import Combine

struct HomeView: View {
    var viewModel = HomeViewModel()
    var onOrder: ((Restaurant) -> Void)? = nil
    @State private var backgroundColor = Color.white //Fix background not updated when restaurant changes
    @State private var restaurantObserver: AnyCancellable? = nil
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                HStack {
                    Text("ASAP")
                    Image(systemName: "arrow.right")
                    Text("Work")
                }
                .font(.system(size: 14))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 1))
                )
                .padding(.top, 8 + max(proxy.safeAreaInsets.top, 22))
                 
                CardCarousel(viewModel: self.viewModel, width: proxy.size.width, bottomOffset: proxy.safeAreaInsets.bottom + (proxy.size.height > 500 ? 30 : 0))
            }
            .overlay(
                Button(action: {
                    self.onOrder?(self.viewModel.currentRestaurant)
                }) {
                    Text("Order from here")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                .padding(EdgeInsets(top: 12, leading: 32, bottom: 12, trailing: 32))
                    .background(Color.black)
                .cornerRadius(32)
                    .padding(.bottom, 20 + max(proxy.safeAreaInsets.bottom, 10))
            }
//                .buttonStyle(ScaleButtonStyle())
            , alignment: .bottom)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(backgroundColor)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.backgroundColor = self.viewModel.currentRestaurant.color
            self.restaurantObserver = self.viewModel.$currentRestaurant.sink { (r) in
                self.backgroundColor = r.color
            }
        }
        .onDisappear {
            self.restaurantObserver?.cancel()
            self.restaurantObserver = nil
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView().previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max")).colorScheme(.light)
            HomeView().previewDevice(PreviewDevice(rawValue: "iPhone 11"))
            HomeView().previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)")).colorScheme(.dark)
        }
        
    }
}
