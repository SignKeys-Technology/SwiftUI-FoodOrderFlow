//
//  Restaurants.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/25/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import Foundation
import SwiftUI

struct RestaurantRepo {
    static let all = [
        Restaurant("McDonald's", description: "Burgers, American", logo: "mcdonalds_logo", photo: "mcdonalds", orderTimeMin: 10, orderTimeMax: 15, color: Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)), rating: 4.8, priceRange: 3),
        Restaurant("Starbucks", description: "Coffee, Beverages", logo: "starbucks_logo", photo: "starbucks", orderTimeMin: 10, orderTimeMax: 15, color: Color(#colorLiteral(red: 0.09411764706, green: 0.3921568627, blue: 0.2588235294, alpha: 1)), rating: 4.6, priceRange: 3),
        Restaurant("Burger King", description: "Burgers, American", logo: "burgerking_logo", photo: "burgerking", orderTimeMin: 10, orderTimeMax: 15, color: Color(#colorLiteral(red: 0.05462269485, green: 0.3204415441, blue: 0.651030004, alpha: 1)), rating: 4.8, priceRange: 3),
        Restaurant("Pizza Hut", description: "Pizza, American", logo: "pizzahut_logo", photo: "pizza", orderTimeMin: 15, orderTimeMax: 30, color: Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), rating: 4.7, priceRange: 3),
        Restaurant("Costa Coffee", description: "Coffee, Beverages", logo: "costacoffee_logo", photo: "coffee", orderTimeMin: 5, orderTimeMax: 10, color: Color(#colorLiteral(red: 0.5264962912, green: 3.538817964e-06, blue: 0.1185295507, alpha: 1)), rating: 4.6, priceRange: 3)
    ]
    
    static let categories = [
        FoodCategory("Breakfast", photo: "coffee_machine"),
        FoodCategory("Snack & Sides", photo: "fries"),
        FoodCategory("Desserts", photo: "cake"),
        FoodCategory("Beverages", photo: "drink"),
        FoodCategory("Burgers", photo: "burger"),
        FoodCategory("Salads", photo: "salads")
    ]
    
    static func getMeals(_ category: FoodCategory) -> [Meal] {
//        var keyword = category.title.split(separator: " ")[0]
//        if keyword[keyword.endIndex] == "s" {
//            keyword.removeLast()
//        }
//        let url = "https://lorempixel.com/400/200/\(keyword)"
//        var output = [Meal]()
//        for i in 1...10 {
//            output.append(Meal("\(category.title) #\(i)", photo: url))
//        }
//        return output
        var output = [Meal]()
        for i in 1...20 {
            output.append(Meal("\(category.title) #\(i)", photo: category.photo, AED: Int.random(in: 5...20)))
        }
        return output
    }
}
