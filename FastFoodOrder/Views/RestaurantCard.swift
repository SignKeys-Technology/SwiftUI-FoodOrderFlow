//
//  RestaurantCard.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/25/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import SwiftUI

struct RestaurantCard: View {
    @EnvironmentObject var viewModel : HomeViewModel
    let restaurant: Restaurant
    let width: CGFloat
    let bottomOffset: CGFloat
    let totalMovement: CGFloat
    let maxOffset: CGFloat
    @Binding var moved: CGFloat
    
    init(_ restaurant: Restaurant, width: CGFloat, bottomOffset: CGFloat, totalMovement: CGFloat, maxOffset: CGFloat, moved: Binding<CGFloat>) {
        self.restaurant = restaurant
        self.width = width
        self.bottomOffset = bottomOffset
        self.totalMovement = totalMovement
        self.maxOffset = maxOffset
        _moved = moved
    }
    
    var body: some View {
        let myIndex = viewModel.getIndex(restaurant)!
        let myCenter = CGFloat(myIndex) * totalMovement + totalMovement / 2
        let adjustedCenter = maxOffset - myCenter
//        print("\(myIndex): center = \(adjustedCenter) moved = \(moved) scale = \(abs(adjustedCenter - (moved - totalMovement / 2)) / maxOffset)")
//        GeometryReader { proxy in
            return VStack {
                Spacer()
                Image(self.restaurant.logo)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                Spacer()
                VStack(alignment: .center, spacing: 12) {
                    Image(self.restaurant.photo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .heroWrap("\(self.restaurant.id).photo")
                        .frame(width: width - 32, height: width - 32, alignment: .center)
                        .background(self.restaurant.color)
                        .cornerRadius(10)
                        .padding(.bottom, 12)
                    
                    Text(self.restaurant.name)
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(.black)
                        .heroWrap("\(self.restaurant.id).name", fitHeight: true)
                    
                    HStack(alignment: .center, spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)))
                        
                        Text(String(format:"%.1f", self.restaurant.rating))
                            .font(.system(size: 12))
                        
                        Circle()
                            .frame(width: 3, height: 3, alignment: .center)
                            .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                            .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
                        
                        Text(self.restaurant.description)
                            .font(.system(size: 12))
                        
                        Circle()
                            .frame(width: 3, height: 3, alignment: .center)
                            .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                            .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
                        
                        Text(self.restaurant.priceString)
                            .font(.system(size: 12))
                    }
                    .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                    .heroWrap("\(self.restaurant.id).info", fitHeight: true)
                    
                    Text(self.restaurant.orderTimeString)
                        .font(.system(size: 13))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
                        .background(
                            Capsule()
                            .foregroundColor(Color.secondaryBackground)
                        )
                        .heroWrap("\(self.restaurant.id).orderTime", fitHeight: true)
                }
                .padding(EdgeInsets(top: 20, leading: 16, bottom: 120 + bottomOffset, trailing: 16))
                .background(HeroViewWrapper(
                    Color.white.cornerRadius(radius: 10, corners: [.topLeft, .topRight])
                        .background(self.restaurant.color),
                    heroId: "\(self.restaurant.id).bg",
                    modifiers: [.useLayerRenderSnapshot]))
                
            }
            .frame(width: width, alignment: .bottom)
            .scaleEffect(min(max(1 - abs(adjustedCenter - (moved - totalMovement / 2)) / maxOffset, 0.9), 1), anchor: .bottom)
            .opacity(min(max(1 - Double(abs(adjustedCenter - (moved - totalMovement / 2)) / maxOffset), 0.9), 1))
            .animation(.linear)
//            .background(self.restaurant.color)
            .edgesIgnoringSafeArea(.all)
//        }
    }
}

struct RestaurantCard_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantCard(RestaurantRepo.all[4], width: 300, bottomOffset: 30, totalMovement: 300, maxOffset: 1, moved: .constant(1))
    }
}
