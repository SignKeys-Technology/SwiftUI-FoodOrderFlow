//
//  RestaurantView.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/26/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import SwiftUI

struct RestaurantView: View {
    @ObservedObject var viewModel: RestaurantViewModel
    @State var isHeaderCollapsed = false
    var onBack : (() -> Void)? = nil
    
    init(_ restaurant: Restaurant) {
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = .white
        UITableViewCell.appearance().selectionStyle = .none
        UITableView.appearance().backgroundColor = .white
        viewModel = RestaurantViewModel(restaurant)
    }
    
    var body: some View {
        VStack {
            if !isHeaderCollapsed {
                Image(viewModel.restaurant.photo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100, alignment: .center)
                    .heroWrap("\(viewModel.restaurant.id).photo")
                    .frame(height: 100, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .zIndex(1)
            }
            VStack(alignment: .center, spacing: 12) {
                AutoHeightHeroView(
                    Text(self.viewModel.restaurant.name)
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(.black)
                    , heroId: "\(viewModel.restaurant.id).name"
                )
                
                HStack(alignment: .center, spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)))
                    
                    Text(String(format:"%.1f", self.viewModel.restaurant.rating))
                        .font(.system(size: 12))
                    
                    Circle()
                        .frame(width: 3, height: 3, alignment: .center)
                        .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
                    
                    Text(self.viewModel.restaurant.description)
                        .font(.system(size: 12))
                    
                    Circle()
                        .frame(width: 3, height: 3, alignment: .center)
                        .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
                    
                    Text(self.viewModel.restaurant.priceString)
                        .font(.system(size: 12))
                }
                .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                .heroWrap("\(self.viewModel.restaurant.id).info", fitHeight: true)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                Text(self.viewModel.restaurant.orderTimeString)
                    .font(.system(size: 13))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
                    .background(
                        Capsule()
                            .foregroundColor(Color.secondaryBackground)
                )
                    .heroWrap("\(viewModel.restaurant.id).orderTime", fitHeight: true)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16))
                
                GeometryReader { proxy in
                    List {
                        HorizontalList(self.$viewModel.categories, selectedItem: .init(get: { () -> FoodCategory? in
                            self.viewModel.currentCategory
                        }, set: { (cate) in
                            if let cate = cate {
                                self.viewModel.currentCategory = cate
                            }
                        }), selectionColor: self.viewModel.restaurant.color) { (item, color) -> CategoryCard in
                            CategoryCard(item, selectionColor: color)
                        }
                        .frame(height: 100)
                        .onDisappear {
                            self.onCategoriesDisappear()
                        }
                        .listRowBackground(Color.white)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        
                        Text(self.viewModel.currentCategory.title)
                            .foregroundColor(.black)
                            .font(.system(size: 14))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .listRowBackground(Color.white)
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        
                        ForEach(self.viewModel.meals) { column in
                            self.getMealView(proxy, row: column)
                        }
                    }
                    .background(Color.white)
                    .padding(.bottom, 20)
                }
            }
            .padding(.top, 20)
            .background(ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .background(self.viewModel.restaurant.color)
                
                Rectangle()
                    .foregroundColor(isHeaderCollapsed ? Color.blue : .white)
                    .offset(x: 0, y: 10)
                    .edgesIgnoringSafeArea(.bottom)
            }
            .heroWrap("\(self.viewModel.restaurant.id).bg",
                modifiers: [.useLayerRenderSnapshot])
                .edgesIgnoringSafeArea(.bottom)
                .overlay(isHeaderCollapsed ? Color.white : Color.clear))
        }
        .animation(.easeInOut)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            (self.isHeaderCollapsed ? Color.white : viewModel.restaurant.color)
                .edgesIgnoringSafeArea(.all))
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    self.onBack?()
                }, label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(isHeaderCollapsed ? .black : .white)
                        .frame(width: 22, height: 22, alignment: .leading)
                }),
                trailing: Button(action: {
                    //TODO
                }, label: {
                    Image(systemName: "magnifyingglass").resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(isHeaderCollapsed ? .black : .white)
                        .frame(width: 22, height: 22, alignment: .trailing)
                }))
        
        
    }
    
    func onCategoriesDisappear() {
        
        guard !isHeaderCollapsed
            else {
                return
        }
        withAnimation { 
            self.isHeaderCollapsed = true
        }
    }
    
    
    
    func getMealView(_ proxy: GeometryProxy, row: CollectionRow<Meal>) -> some View {
        let spacing =  (row.items.count - 1) * 8
        let remainingWidth = proxy.size.width - CGFloat(32 + spacing)
        let itemWidth = remainingWidth / CGFloat(row.items.count)
        return HStack {
            ForEach(row.items) { meal in
                MealCard(meal) { (m) in
                    //TODO
                }
                .frame(width: itemWidth, height: itemWidth + 30)
            }
        }
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
}

struct RestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantView(RestaurantRepo.all[0])
    }
}
