//
//  ListItem.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/26/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import Foundation
import SwiftUI

class ListItem<T: Identifiable>: ObservableObject {
    @Published var isSelected: Bool = false
    let data: T
    var index: Int = 0
    
    init(_ data: T) {
        self.data = data
    }
}
