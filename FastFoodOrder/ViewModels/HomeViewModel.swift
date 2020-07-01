//
//  HomeViewModel.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/25/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import Foundation
class HomeViewModel: ObservableObject {
    var restaurants = RestaurantRepo.all
    @Published var currentRestaurant : Restaurant {
        didSet {
            print("Current restaurant: \(currentRestaurant.name)")
        }
    }
    
    var currentRestaurantIndex : Int {
        get {
            return getIndex(currentRestaurant)!
        }
        set {
            if restaurants.count == 0 {
                return
            }
            let clamped = (0...restaurants.count - 1).clamp(newValue)
            currentRestaurant = restaurants[clamped]
        }
    }
    
    init() {
        currentRestaurant = restaurants[0]
    }
    
    func getIndex(_ restaurant: Restaurant) -> Int? {
        return restaurants.firstIndex(where: { $0.id == restaurant.id})
    }
}
