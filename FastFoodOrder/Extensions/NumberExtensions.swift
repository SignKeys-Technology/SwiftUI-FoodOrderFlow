//
//  NumberExtensions.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/26/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import Foundation

extension ClosedRange {
    func clamp(_ value : Bound) -> Bound {
        return self.lowerBound > value ? self.lowerBound
            : self.upperBound < value ? self.upperBound
            : value
    }
}
