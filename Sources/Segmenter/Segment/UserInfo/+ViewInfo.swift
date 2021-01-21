//
//  Created by iWw on 2021/1/21.
//

import UIKit

public extension Segmenter.Segment {
    
    class ViewInfo: SegmentUserInfo {
        public var activeView: UIView
        public var inactiveView: UIView?
        
        public var activeSize: CGSize
        public var inactiveSize: CGSize
        
        public init(activeView: UIView, inactiveView: UIView? = nil, activeSize: CGSize, inactiveSize: CGSize) {
            self.activeView = activeView
            self.inactiveView = inactiveView
            
            self.activeSize = activeSize
            self.inactiveSize = inactiveSize
        }
    }
    
}
