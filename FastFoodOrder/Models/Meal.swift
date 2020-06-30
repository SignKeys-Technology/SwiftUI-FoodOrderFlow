//
//  Meal.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/29/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import Foundation

struct Meal: Identifiable {
    let id = UUID().uuidString
    var title: String
    var photo: String
    var AED: Int
    
    init(_ title: String, photo: String, AED: Int) {
        self.title = title
        self.photo = photo
        self.AED = AED
    }
}
