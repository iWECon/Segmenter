//
//  FadePopSupplementaryViewsTransition.swift
//  Segmenter
//
//  Created by iww on 2022/3/23.
//

import UIKit

public struct FadePopSupplementaryViewsTransition: SupplementaryViewsTransitionProvider {
    
    public func transition(invisibleViews: [UIView], visibleViews: [UIView]) {
        func makeView(view: UIView, show: Bool) {
            view.transform = show ? .identity : .init(scaleX: 0.8, y: 0.8)
            view.alpha = show ? 1 : 0
        }
        
        invisibleViews.forEach({ makeView(view: $0, show: false) })
        visibleViews.forEach({ makeView(view: $0, show: true) })
    }
}
