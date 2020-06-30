//
//  PropertyWrapper.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/25/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import Foundation

@propertyWrapper
struct Clamping<Value: Comparable> {
    var value: Value
    let range: ClosedRange<Value>

    init(initialValue value: Value, _ range: ClosedRange<Value>) {
        precondition(range.contains(value))
        self.value = value
        self.range = range
    }
    
    init(_ range: ClosedRange<Value>) {
        self.init(initialValue: range.lowerBound, range);
    }

    var wrappedValue: Value {
        get { value }
        set { value = range.clamp(newValue) }
    }
}
