//
//  RestaurantViewModel.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/26/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import Foundation

struct CollectionRow<T: Identifiable>: Identifiable {
    var items: [T]
    var id: Int
    init(_ items: [T]) {
        self.items = items
        var hasher = Hasher()
        for i in items {
            hasher.combine(i.id)
        }
        id = hasher.finalize().hashValue
    }
}

class RestaurantViewModel: ObservableObject {
    let restaurant: Restaurant
    static let columns = 2
    @Published var categories : [FoodCategory]
    @Published var currentCategory: FoodCategory {
        didSet {
            meals = generateMeals()
        }
    }
    @Published var meals: [CollectionRow<Meal>]
    
    init(_ restaurant: Restaurant) {
        self.restaurant = restaurant
        _categories = .init(initialValue: RestaurantRepo.categories)
        let cat = RestaurantRepo.categories[0]
        currentCategory = cat
        
        _meals = .init(initialValue: RestaurantViewModel.generateMeals(category: cat))
    }
    
    private func generateMeals() -> [CollectionRow<Meal>] {
        return RestaurantViewModel.generateMeals(category: currentCategory)
    }
    
    private static func generateMeals(category: FoodCategory) -> [CollectionRow<Meal>] {
        let all = RestaurantRepo.getMeals(category)
        var items = [CollectionRow<Meal>]()
        guard all.count != 0 else {
            return items
        }
        var currentIndex = 0
        while currentIndex < all.count {
            let maxIndex = min(currentIndex + columns, all.count) - 1
            items.append(CollectionRow<Meal>(Array(all[currentIndex...maxIndex])))
            currentIndex += columns
        }
        return items
    }
}
