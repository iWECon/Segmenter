//
//  SegmentTransitionProvider.swift
//  Segmenter
//
//  Created by iww on 2022/3/23.
//

import UIKit

public protocol SupplementaryTransitionProvider {
    
    func transition(invisibleViews: [UIView], visibleViews: [UIView])
    
}


public struct DefaultSupplementaryTransition: SupplementaryTransitionProvider {
    
    public func transition(invisibleViews: [UIView], visibleViews: [UIView]) {
        func makeView(view: UIView, show: Bool) {
            // 由于 Segment 切换的时候，会导致 SupplementaryViews 的 Container 的 frame 也会跟着改变（根据子视图内容大小进行匹配）
            // 所以默认看上去会带有这个 translationX 的位移效果，这里就不再二次重复了
            // 若切换后的 container.frame 没有变化才需要进行这项处理
            // view.transform = show ? .identity : .init(translationX: 10, y: 0)
            view.alpha = show ? 1 : 0
        }
        
        invisibleViews.forEach({ makeView(view: $0, show: false) })
        visibleViews.forEach({ makeView(view: $0, show: true) })
    }
}


public struct FadePopSupplementaryTransition: SupplementaryTransitionProvider {
    
    public func transition(invisibleViews: [UIView], visibleViews: [UIView]) {
        func makeView(view: UIView, show: Bool) {
            view.transform = show ? .identity : .init(scaleX: 0.8, y: 0.8)
            view.alpha = show ? 1 : 0
        }
        
        invisibleViews.forEach({ makeView(view: $0, show: false) })
        visibleViews.forEach({ makeView(view: $0, show: true) })
    }
}
