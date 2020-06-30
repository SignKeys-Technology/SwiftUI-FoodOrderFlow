//
//  FoodCategory.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/26/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import Foundation

struct FoodCategory: Identifiable {
    let id = UUID().uuidString
    var title: String
    var photo: String
    
    init(_ title: String, photo: String) {
        self.title = title
        self.photo = photo
    }
}
