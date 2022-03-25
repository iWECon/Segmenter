//
//  FadePopSupplementaryViewsTransition.swift
//  Segmenter
//
//  Created by iww on 2022/3/23.
//

import UIKit

public struct FadePopSupplementaryViewsTransition: SupplementaryViewsTransitionProvider {
    
    public func transition(invisibleViews: [UIView], visibleViews: [UIView]) {
        invisibleViews.forEach({ makeView(view: $0, show: false) })
        visibleViews.forEach({ makeView(view: $0, show: true) })
    }
    
    private func makeView(view: UIView, show: Bool) {
        view.transform = show ? CGAffineTransform.identity : CGAffineTransform(scaleX: 0.8, y: 0.8)
        view.alpha = show ? 1 : 0
    }
}
