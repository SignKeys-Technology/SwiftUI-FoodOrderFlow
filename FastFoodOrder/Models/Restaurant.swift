//
//  Restaurant.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/25/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import Foundation
import SwiftUI

struct Restaurant: Identifiable {
    let id = UUID().uuidString
    var name: String
    var description: String
    @Clamping(0.0...5.0) var rating : Double
    @Clamping(1...5) var priceRange: Int
    var logo: String
    var photo: String
    var orderTimeMin: UInt = 0
    var orderTimeMax: UInt = 0
    var color: Color
    
    init(_ name: String, description: String, logo: String, photo: String, orderTimeMin: UInt, orderTimeMax: UInt, color: Color, rating: Double = 0.0, priceRange: Int = 1) {
        self.name = name
        self.description = description
        self.logo = logo
        self.photo = photo
        self.orderTimeMin = orderTimeMin
        self.orderTimeMax = max(orderTimeMin, orderTimeMax)
        self.color = color
        self.rating = rating
        self.priceRange = priceRange
    }
}

extension Restaurant {
    var priceString : String {
        get {
            var str = ""
            for _ in 0..<priceRange {
                str += "$"
            }
            return str
        }
    }
    
    var orderTimeString: String {
        get {
            if (orderTimeMax <= orderTimeMin) {
                return "\(orderTimeMin) Min"
            }
            return "\(orderTimeMin) - \(orderTimeMax) Min"
        }
    }
}
