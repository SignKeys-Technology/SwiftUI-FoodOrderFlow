//
//  HorizontalList.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/26/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import SwiftUI

fileprivate struct MyTextPreferenceKey: PreferenceKey {
    typealias Value = [MyTextPreferenceData]
    
    static var defaultValue: [MyTextPreferenceData] = []
    
    static func reduce(value: inout [MyTextPreferenceData], nextValue: () -> [MyTextPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

fileprivate struct MyTextPreferenceData: Equatable {
    let viewIdx: Int
    let rect: CGRect
}

struct HorizontalList<ItemTemplate: View, ItemType: Identifiable>: View {
    let itemTemplate: (ListItem<ItemType>, Color) -> ItemTemplate
    let spacing: CGFloat
    @State private var rects: [CGRect]
    @State private var isLayouted = false
    @Binding var itemsSource: [ItemType] {
        didSet {
            rects = Array<CGRect>(repeating: CGRect(), count: itemsSource.count)
            items = HorizontalList.createItemsList(itemsSource)
        }
    }
    @Binding var selectedIndex: Int?
    @Binding var selectedItem: ItemType?
    @State private var items: [ListItem<ItemType>]
    @State private var offset: CGFloat = 0
    @State private var calculatedWidth: CGFloat = 0
    @State private var calculatedTotalWidth: CGFloat = 0
    @State private var defaultOffset: CGFloat = 0
    @State private var enableAnimation = false
    @State private var accumulated : CGFloat = 0
    let selectionColor: Color
    
    @inlinable public init(
        _ itemSource: Binding<[ItemType]>,
        selectedIndex: Binding<Int?>? = nil,
        selectedItem: Binding<ItemType?>? = nil,
        spacing: CGFloat = 10,
        selectionColor: Color,
        @ViewBuilder _ itemTemplate: @escaping (ListItem<ItemType>, Color) -> ItemTemplate) {
        _itemsSource = itemSource
        
        _rects = .init(initialValue: Array<CGRect>(repeating: CGRect(), count: _itemsSource.wrappedValue.count))
        
        self.spacing = spacing
        self.itemTemplate = itemTemplate
        self.selectionColor = selectionColor
        _items = .init(initialValue: HorizontalList.createItemsList(_itemsSource.wrappedValue)
        )
        if let selectedIndex = selectedIndex {
            _selectedIndex = selectedIndex
            if let index = selectedIndex.wrappedValue {
                _selectedItem = .constant(_itemsSource.wrappedValue[index])
            }
            else {
                _selectedItem = .constant(nil)
            }
        }
        else {
            if let selectedItem = selectedItem {
                _selectedItem = selectedItem
                if let item = selectedItem.wrappedValue {
                    _selectedIndex = .constant(itemSource.wrappedValue.firstIndex(where: {
                        $0.id == item.id
                    }))
                }
                else {
                    _selectedIndex = .constant(nil)
                }
            }
            else {
                _selectedIndex = .constant(nil)
                _selectedItem = .constant(nil)
            }
        }
        
        if let index = _selectedIndex.wrappedValue {
            items[index].isSelected = true
        }
    }
    var body: some View {
        if items.isEmpty {
            return AnyView(Text(""))
        }
        return AnyView(
            GeometryReader { proxy in
                HStack(alignment: .center, spacing: self.spacing) {
                    ForEach(self.items, id: \.data.id) { item in
                        self.itemTemplate(item, self.selectionColor)
                            .onTapGesture {
                                guard !item.isSelected else {
                                    return
                                }
                                self.items.forEach { (other) in
                                    other.isSelected = false
                                }
                                self.selectedItem = item.data
                                self.selectedIndex = self.items.firstIndex(where: { $0.data.id == item.data.id
                                })
                                print("Selected: \(item.index)")
                                item.isSelected = true
                                self.scrollRectToVisible(self.expandedRect(self.rects[item.index]), width: proxy.size.width)
                        }
                        .transition(.slide)
                        .background(MyPreferenceViewSetter(idx: item.index))
                    }
                }
                .coordinateSpace(name: "horizontal_list")
                .offset(x: self.offset)
                .gesture(DragGesture()
                .onChanged({
                    self.offset = max(min(self.accumulated + $0.translation.width, self.defaultOffset), 0 - self.defaultOffset)
                })
                    .onEnded { _ in
                        self.accumulated = self.offset
                })
                    .animation(self.enableAnimation ? .easeInOut : .none)
                    .onPreferenceChange(MyTextPreferenceKey.self) { preferences in
                        var totalWidth : CGFloat = CGFloat(self.itemsSource.count - 1) * self.spacing
                        for p in preferences {
                            self.rects[p.viewIdx] = p.rect
                            totalWidth += p.rect.width
                        }
                        if self.calculatedWidth != proxy.size.width
                            || self.calculatedTotalWidth != totalWidth {
                            self.enableAnimation = false
                            self.calculatedWidth = proxy.size.width
                            self.calculatedTotalWidth = totalWidth
                            self.defaultOffset = (totalWidth - proxy.size.width) / 2
//                            print("total width = \(totalWidth)")
//                            print("default offset = \(self.defaultOffset)")
                            if let index = self.selectedIndex {
                                self.scrollRectToVisible(self.expandedRect(self.rects[index]), width: proxy.size.width)
                            }
                            else {
                                self.offset = self.defaultOffset
                                self.accumulated = self.offset
                            }
                            self.isLayouted = true
                            self.enableAnimation = true
                        }
                }
                .opacity(self.isLayouted ? 1 : 0)
            }
        )
    }
    
    func expandedRect(_ rect: CGRect) -> CGRect {
        return rect.insetBy(dx: -self.spacing * 2, dy: 0)
    }
    
    func scrollRectToVisible(_ rect: CGRect, width: CGFloat) {
//        print(offset)
//        print(rect)
        let adjustedX = min(defaultOffset - rect.origin.x, defaultOffset)
//        print(adjustedX)
        if adjustedX > offset {
            offset = adjustedX
        }
        else {
            let adjustedMaxX = max(adjustedX - rect.size.width + width, 0 - defaultOffset)
//            print(adjustedMaxX)
            if adjustedMaxX < offset {
                offset = adjustedMaxX
            }
        }
        self.accumulated = self.offset
    }
    
    static func createItemsList(_ source: [ItemType]) -> [ListItem<ItemType>] {
        var lst = [ListItem<ItemType>]()
        for (index, data) in source.enumerated() {
            let item = ListItem<ItemType>(data)
            item.index = index
            lst.append(item)
        }
        return lst
    }
}

struct HorizontalList_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalList(.constant(RestaurantRepo.categories), selectionColor: RestaurantRepo.all[0].color) { (item, color) -> CategoryCard in
            CategoryCard(item, selectionColor: color)
        }
    }
}

struct MyPreferenceViewSetter: View {
    let idx: Int
    let cpName = "horizontal_list"
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(key: MyTextPreferenceKey.self,
                            value: [MyTextPreferenceData(viewIdx: self.idx, rect: geometry.frame(in: CoordinateSpace.named(self.cpName)))])
        }
    }
}
