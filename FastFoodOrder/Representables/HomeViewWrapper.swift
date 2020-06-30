//
//  HomeViewWrapper.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/29/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import Foundation
import SwiftUI
import Hero

class HomeViewWrapper: UIHostingController<HomeView> {

  required init() {
        super.init(rootView: HomeView())
    
        rootView.onOrder = { restaurant in
            let dest = RestaurantNavigationController(rootViewController: RestaurantViewWrapper(restaurant))
            self.present(dest, animated: true, completion: nil)
        }
  }
  
  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

