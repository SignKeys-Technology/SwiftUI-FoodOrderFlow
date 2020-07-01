//
//  RestaurantCard.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/25/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import SwiftUI

struct RestaurantCard: View {
    @ObservedObject var viewModel: RestaurantCarouselItem
    @State var myOpacity: CGFloat
    
    let width: CGFloat
    let bottomOffset: CGFloat
    
    init(_ viewModel: RestaurantCarouselItem, width: CGFloat, bottomOffset: CGFloat) {
        self.viewModel = viewModel
        self.width = width
        self.bottomOffset = bottomOffset
        _myOpacity = .init(initialValue: viewModel.opacity)
    }
    
    var body: some View {
            return VStack {
                Spacer()
                Image(self.viewModel.data.logo)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                Spacer()
                VStack(alignment: .center, spacing: 12) {
                    Image(self.viewModel.data.photo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .heroWrap("\(self.viewModel.data.id).photo")
                        .frame(width: width - 32, height: width - 32, alignment: .center)
                        .background(self.viewModel.data.color)
                        .cornerRadius(10)
                        .padding(.bottom, 12)
                    
                    Text(self.viewModel.data.name)
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(.black)
                        .heroWrap("\(self.viewModel.data.id).name", fitHeight: true)
                    
                    HStack(alignment: .center, spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)))
                        
                        Text(String(format:"%.1f", self.viewModel.data.rating))
                            .font(.system(size: 12))
                        
                        Circle()
                            .frame(width: 3, height: 3, alignment: .center)
                            .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                            .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
                        
                        Text(self.viewModel.data.description)
                            .font(.system(size: 12))
                        
                        Circle()
                            .frame(width: 3, height: 3, alignment: .center)
                            .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                            .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
                        
                        Text(self.viewModel.data.priceString)
                            .font(.system(size: 12))
                    }
                    .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                    .heroWrap("\(self.viewModel.data.id).info", fitHeight: true)
                    
                    Text(self.viewModel.data.orderTimeString)
                        .font(.system(size: 13))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
                        .background(
                            Capsule()
                            .foregroundColor(Color.secondaryBackground)
                        )
                        .heroWrap("\(self.viewModel.data.id).orderTime", fitHeight: true)
                }
                .padding(EdgeInsets(top: 20, leading: 16, bottom: 120 + bottomOffset, trailing: 16))
                .background(HeroViewWrapper(
                    Color.white.cornerRadius(radius: 10, corners: [.topLeft, .topRight])
                        .background(self.viewModel.isSelected ? self.viewModel.data.color : Color.clear),
                    heroId: "\(self.viewModel.data.id).bg",
                    modifiers: [.useLayerRenderSnapshot]))
                
            }
            .frame(width: width, alignment: .bottom)
            .scaleEffect(myOpacity, anchor: .bottom)
            .opacity(Double(myOpacity))
            .animation(.linear)
//            .background(self.viewModel.data.color)
            .edgesIgnoringSafeArea(.all)
                .onReceive(viewModel.$opacity) { (o) in
                    self.myOpacity = o
        }
//        }
    }
}

struct RestaurantCard_Previews: PreviewProvider {
    static var previews: some View {
        let rest = RestaurantRepo.all[4]
        let item = RestaurantCarouselItem(rest, index: 4, totalMovement: 300, maxOffset: 1)
        return RestaurantCard(item, width: 300, bottomOffset: 30)
    }
}
