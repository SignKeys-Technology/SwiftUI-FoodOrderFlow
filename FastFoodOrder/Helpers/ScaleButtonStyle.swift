//
//  ScaleButtonStyle.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/30/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import Foundation
import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    var step: CGFloat = 0.8
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? step : 1)
    }
}
