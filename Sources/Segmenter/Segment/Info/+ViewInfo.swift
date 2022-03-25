//
//  Created by iWw on 2021/1/21.
//

import UIKit

extension Segment {
    
    class _ViewInfo: SegmentInfoProvider {
        var viewType: (SegmentView).Type {
            _View.self
        }
        
        let activeView: UIView
        let inactiveView: UIView?
        
        let activeSize: CGSize
        let inactiveSize: CGSize
        
        init(activeView: UIView, inactiveView: UIView? = nil, activeSize: CGSize, inactiveSize: CGSize) {
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
