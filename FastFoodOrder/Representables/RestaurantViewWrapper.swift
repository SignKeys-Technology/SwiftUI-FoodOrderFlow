//
//  RestaurantViewWrapper.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/29/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import Foundation
import SwiftUI
import Hero

class RestaurantNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        modalPresentationStyle = .fullScreen
        isHeroEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.tintColor = UIColor.white
        navigationBar.shadowImage = UIImage()
    }
}
class RestaurantViewWrapper: UIHostingController<RestaurantView> {

    required init(_ restaurant: Restaurant) {
        super.init(rootView: RestaurantView(restaurant))
        rootView.onBack = {
            self.hero.dismissViewController()
        }
  }
  
  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
