//
//  DefaultSupplementaryViewsTransition.swift
//  Segmenter
//
//  Created by iww on 2022/3/23.
//

import UIKit

public struct DefaultSupplementaryViewsTransition: SupplementaryViewsTransitionProvider {
    
    public func transition(invisibleViews: [UIView], visibleViews: [UIView]) {
        invisibleViews.forEach({ makeView(view: $0, show: false) })
        visibleViews.forEach({ makeView(view: $0, show: true) })
    }
    
    private func makeView(view: UIView, show: Bool) {
        // 由于 Segment 切换的时候，会导致 SupplementaryViews 的 Container 的 frame 也会跟着改变（根据子视图内容大小进行匹配）
        // 所以默认看上去会带有这个 translationX 的位移效果，这里就不再二次重复了
        // 若切换后的 container.frame 没有变化才需要进行这项处理
        view.transform = show ? CGAffineTransform.identity : CGAffineTransform(translationX: 10, y: 0)
        view.alpha = show ? 1 : 0
    }
}

