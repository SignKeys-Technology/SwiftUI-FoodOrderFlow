//
//  RestaurantCarouselItem.swift
//  FastFoodOrder
//
//  Created by Ha Do on 7/1/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import Foundation
import SwiftUI

class RestaurantCarouselItem: ListItem<Restaurant> {
    let maxOffset: CGFloat
    let totalMovement: CGFloat
    let adjustedCenter: CGFloat

    @Published var opacity: CGFloat = 0.9
    @Published var moved: CGFloat {
        didSet {
            updateOpacity()
        }
    }
    
   
    init(_ data: Restaurant, index: Int, totalMovement: CGFloat, maxOffset: CGFloat) {
        self.maxOffset = maxOffset
        self.totalMovement = totalMovement
        let myCenter = CGFloat(index) * totalMovement + totalMovement / 2
        adjustedCenter = maxOffset - myCenter
        moved = maxOffset

        super.init(data)
        
        self.index = index
        updateOpacity()
    }
    
    func updateOpacity() {
        opacity =  min(max(1 - abs(adjustedCenter - (moved - totalMovement / 2)) / maxOffset, 0.9), 1)
    }
}
