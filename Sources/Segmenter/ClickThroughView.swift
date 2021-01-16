//
//  Created by iWw on 2021/1/8.
//

import UIKit

protocol SegmenterSupplementaryContainer { }

class ClickThroughView: UIView, SegmenterSupplementaryContainer {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subview in subviews.reversed() {
            let isValidResponderView = !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled
            guard isValidResponderView else {
                continue
            }
            
            if let subviewHitTest = subview.hitTest(point, with: event) {
                return subviewHitTest
            }
            if subview.frame.contains(point) {
                return subview
            }
            return super.hitTest(point, with: event)
        }
        return nil
    }
}
