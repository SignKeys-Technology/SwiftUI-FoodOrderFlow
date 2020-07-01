//
//  HeroWrapperView.swift
//  FastFoodOrder
//
//  Created by Ha Do on 6/30/20.
//  Copyright © 2020 Ha Do. All rights reserved.
//

import Foundation
import SwiftUI
import Hero



struct HeroViewWrapper<TView: View>: UIViewRepresentable {
    var heroId: String?
    var rootView: TView
    var modifiers: [HeroModifier]? = nil
    
    init(_ rootView: TView, heroId: String? = nil, modifiers: [HeroModifier]? = nil) {
        self.rootView = rootView
        self.heroId = heroId
        self.modifiers = modifiers
    }
    
    func makeCoordinator() -> UIHeroView<TView> {
        UIHeroView<TView>(self, view: rootView, heroId: heroId, modifiers: modifiers)
    }
    
    func makeUIView(context: Context) -> UIView {
        return context.coordinator
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.hero.id = heroId
        uiView.hero.modifiers = modifiers
    }
    
    class UIHeroView<TView: View>: UIView {
        var representable: HeroViewWrapper<TView>? = nil
        init(_ representable: HeroViewWrapper<TView>, view: TView, heroId: String? = nil, modifiers: [HeroModifier]? = nil) {
            super.init(frame: CGRect.zero)
            self.representable = representable
            isOpaque = false //! Important for Text / UILabel
            hero.id = heroId
            let hostingView = UIHostingController(rootView: view).view
            hostingView?.backgroundColor = .clear
            addSubview(hostingView!)
            hostingView!.isOpaque = false
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            get {
                let size = subviews[0].intrinsicContentSize
//                print("intrinsicContentSize of \(String(describing: hero.Id)) is \(size)")
                onMeasured(size)
                return size
            }
        }
        
        override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
            let size = subviews[0].systemLayoutSizeFitting(targetSize)
//            print("systemLayoutSizeFitting of \(String(describing: hero.Id)) with targetSize \(targetSize) is \(size)")
            onMeasured(size)
            return size
        }
        
        override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
            let size = subviews[0].systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
//            print("systemLayoutSizeFitting of \(String(describing: hero.Id)) with targetSize \(targetSize) is \(size)")
            onMeasured(size)
            return size
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            let size = subviews[0].sizeThatFits(size)
//            print("sizeThatFits \(size) of \(String(describing: hero.Id)) is \(size)")
            onMeasured(size)
            return size
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            subviews[0].frame = CGRect(origin: CGPoint.zero, size: bounds.size)
//            print("size of \(String(describing: hero.Id)) = \(bounds.size)")
        }
        
        func onMeasured(_ size: CGSize) {
            //Nothing to do
        }
    }
}

struct AutoHeightHeroView<TView: View>: View {
    private var view: TView
    private var heroId: String?
    private var modifiers: [HeroModifier]?
    
    init(_ view: TView, heroId: String? = nil, modifiers: [HeroModifier]? = nil) {
        self.view = view
        self.heroId = heroId
        self.modifiers = modifiers
    }
    
    var body: some View {
        HeroViewWrapper(view, heroId: heroId, modifiers: modifiers)
//            .frame(height: size.height)
        .fixedSize(horizontal: false, vertical: true)
    }
}

//struct ImageViewWrapper: UIViewRepresentable {
//    
//  let name: String
//  let heroID: String?
//    
//    init(_ name: String, heroId: String? = nil) {
//        self.name = name
//        self.heroID = heroId
//    }
//    
//  func makeUIView(context: UIViewRepresentableContext<ImageViewWrapper>) -> UIImageView {
//        let img = UIImageView(frame: .zero)
//        img.contentMode = .scaleAspectFit
//        return img
//  }
//  
//  func updateUIView(_ uiView: UIImageView, context: UIViewRepresentableContext<ImageViewWrapper>) {
//    uiView.image = UIImage(named: name)
//    uiView.hero.id = heroID
//    uiView.contentMode = .scaleAspectFit
//  }
//}
