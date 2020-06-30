//
//  CardCarousel.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/25/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import SwiftUI

struct CardCarousel: View {
    static let flickMode = true
    
    @ObservedObject var viewModel : HomeViewModel
    
    @State private var dragged : CGFloat = 0
    @State private var accumulated : CGFloat = 0
    
    let width: CGFloat
    let bottomOffset: CGFloat
    var cardWidth: CGFloat = 0
    var totalMovement: CGFloat = 0
    var maxOffset: CGFloat = 0

    static let spacing : CGFloat = 8
    static let widthOfHiddenCards : CGFloat = 32
    static let leftPadding = widthOfHiddenCards + spacing

    
    init(viewModel: HomeViewModel, width: CGFloat, bottomOffset: CGFloat) {
        self.width = width
        self.bottomOffset = bottomOffset
        self.viewModel = viewModel
        let itemsCount = CGFloat(viewModel.restaurants.count)
        let totalSpacing = (itemsCount - 1) * CardCarousel.spacing
        cardWidth = width - CardCarousel.widthOfHiddenCards * 2 - CardCarousel.spacing * 2
        let totalCanvasWidth: CGFloat = (cardWidth * itemsCount) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - width) / 2
        maxOffset = xOffsetToShift + CardCarousel.leftPadding
        totalMovement = cardWidth + CardCarousel.spacing
        _dragged = .init(initialValue: maxOffset)
        _accumulated = .init(initialValue: maxOffset)
    }
    
    var body: some View {
        return HStack(alignment: .center, spacing: CardCarousel.spacing) {
            ForEach(viewModel.restaurants, id: \.self.id) { rest in
                 
                 RestaurantCard(rest, width: self.cardWidth, bottomOffset: self.bottomOffset, totalMovement: self.totalMovement, maxOffset: self.maxOffset, moved: self.$dragged).environmentObject(self.viewModel)
                        .transition(AnyTransition.slide)
                      
            }
        }
        .offset(x: dragged, y: 0)
        .gesture(DragGesture()
            .onChanged({
                if CardCarousel.flickMode {
                    return
                }
                self.dragged = max(min(self.accumulated + $0.translation.width, self.maxOffset), 0 - self.maxOffset)
            })
            .onEnded {
                
                var index = CardCarousel.flickMode ? self.viewModel.currentRestaurantIndex : Int(((self.maxOffset - self.dragged) / self.width).rounded())
                if ($0.translation.width < -50) {
                    index += 1
                }
                else if ($0.translation.width > 50) {
                    index -= 1
                }
                index = (0...self.viewModel.restaurants.count - 1).clamp(index)
                self.viewModel.currentRestaurant = self.viewModel.restaurants[index]
                
                let offset = self.maxOffset - self.totalMovement * CGFloat(index)
                self.dragged = offset
                self.accumulated = self.dragged
        })
    }
}

struct CardCarousel_Previews: PreviewProvider {
    static var previews: some View {
        CardCarousel(viewModel: HomeViewModel(), width: 300, bottomOffset: 30)
    }
}
