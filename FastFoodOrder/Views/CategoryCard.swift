//
//  CategoryCard.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/26/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import SwiftUI

struct CategoryCard: View {
    @ObservedObject var category: ListItem<FoodCategory>
    let selectionColor: Color
    
    init(_ category: ListItem<FoodCategory>, selectionColor: Color) {
        self.category = category
        self.selectionColor = selectionColor
    }
    var body: some View {
        VStack {
            Image(category.data.photo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 52, height: 52, alignment: .center)
            Text(category.data.title)
                .font(.system(size: 13))
                .foregroundColor(category.isSelected
                    ? .white : .black)
        }
        .frame(width: 80, height: 100, alignment: .center)
        .fixedSize(horizontal: true, vertical: true)
        .background(
            category.isSelected
                ? selectionColor
                : Color.secondaryBackground)
        .cornerRadius(4)
    }
}

struct CategoryCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CategoryCard(ListItem<FoodCategory>(RestaurantRepo.categories[0]), selectionColor: RestaurantRepo.all[0].color)
            .frame(width: 80, height: 100, alignment: .center)
            CategoryCard(ListItem<FoodCategory>(RestaurantRepo.categories[0]), selectionColor: RestaurantRepo.all[1].color)
            .frame(width: 80, height: 100, alignment: .center)
        }
    }
}
