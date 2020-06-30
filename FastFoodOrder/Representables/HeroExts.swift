//
//  HeroModifier.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/30/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import Foundation
import SwiftUI
import Hero

extension View {
    func heroWrap(_ id: String? = nil, modifiers: [HeroModifier]? = nil, fitHeight: Bool = false) -> some View {
        if fitHeight {
            return AnyView(AutoHeightHeroView(self, heroId: id, modifiers: modifiers))
        }
        else {
            return AnyView(HeroViewWrapper(self, heroId: id, modifiers: modifiers))
        }
    }
}
