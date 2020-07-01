//
//  MealCard.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/29/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import SwiftUI

struct MealCard: View {
    var meal: Meal
    var selectionHandler : (Meal) -> Void
    
    init(_ meal: Meal, onSelected: @escaping (Meal) -> Void) {
        self.meal = meal
        self.selectionHandler = onSelected
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 4) {
                Image(self.meal.photo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                        .frame(width: proxy.size.width - 40, height: proxy.size.width - 40, alignment: .center)
                
                Text(self.meal.title)
                    .foregroundColor(.darkGray)
                    .font(.system(size: 12))
                    .fontWeight(.light)
                
                HStack {
                    Text("AED: \(self.meal.AED)")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                    Spacer()
                    Button(action: {
                        self.selectionHandler(self.meal)
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(.darkGray)
                        .padding(6)
                        .frame(width: 20, height: 20, alignment: .center)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color(#colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)), radius: 1, x: 1, y: 1)
                    }
                    .buttonStyle(ScaleButtonStyle(step: 0.6))
                    
                }
            }
            .padding(8)
            .background(Color(#colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)))
            .frame(height: proxy.size.width + 30, alignment: .center)
        }
    }
}

struct MealCard_Previews: PreviewProvider {
    static var previews: some View {
        MealCard(RestaurantRepo.getMeals(RestaurantRepo.categories[0])[0], onSelected: { m in })
        .previewLayout(.fixed(width: 120, height: 200))
    }
}
