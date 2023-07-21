//
//  Created by iWw on 2021/1/21.
//

import UIKit

public protocol SegmentViewInfoProvier: SegmentInfoProvider {
    var activeView: UIView { get }
    var inactiveView: UIView? { get }
    
    var activeSize: CGSize { get }
    var inactiveSize: CGSize { get }
}

// MARK: ViewInfo
extension Segment {
    
    struct _ViewInfo: SegmentViewInfoProvier {
        var viewType: (SegmentView).Type {
            View.self
        }
        
        var activeView: UIView
        var inactiveView: UIView?
        
        var activeSize: CGSize
        var inactiveSize: CGSize
        
        init(
            activeView: UIView,
            inactiveView: UIView? = nil,
            activeSize: CGSize,
            inactiveSize: CGSize
        ) {
            self.activeView = activeView
            self.inactiveView = inactiveView
            
            // bugfix: tap the custome view not respond
            activeView.isUserInteractionEnabled = false
            inactiveView?.isUserInteractionEnabled = false
            
            self.activeSize = activeSize
            self.inactiveSize = inactiveSize
        }
    }
    
}
