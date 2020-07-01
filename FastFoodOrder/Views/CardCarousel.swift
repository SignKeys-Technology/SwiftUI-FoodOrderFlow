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
    let totalMovement: CGFloat
    let maxOffset: CGFloat
    let cardWidth: CGFloat
    var items : [RestaurantCarouselItem]

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
        print("max offset: \(maxOffset)")
        items = [RestaurantCarouselItem]()
        items.append(contentsOf: viewModel.restaurants.map({ (rest) -> RestaurantCarouselItem in
            return RestaurantCarouselItem(rest, index: self.viewModel.getIndex(rest)!, totalMovement: self.totalMovement, maxOffset: self.maxOffset)
        }))
    }
    
    var body: some View {
        for i in 0..<self.viewModel.restaurants.count {
            self.items[i].moved = self.dragged
        }
        return HStack(alignment: .center, spacing: CardCarousel.spacing) {
            ForEach(items, id: \.self.id) { item in
                RestaurantCard(item, width: self.cardWidth, bottomOffset: self.bottomOffset)
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
                for i in 0..<self.viewModel.restaurants.count {
                    self.items[i].moved = self.dragged
                }
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
                for i in 0..<self.viewModel.restaurants.count {
                    self.items[i].isSelected = (i == index)
                    self.items[i].moved = offset
                }
        })
    }
}

struct CardCarousel_Previews: PreviewProvider {
    static var previews: some View {
        CardCarousel(viewModel: HomeViewModel(), width: 300, bottomOffset: 30)
    }
}
