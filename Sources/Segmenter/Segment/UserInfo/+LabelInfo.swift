//
//  Created by iWw on 2021/1/21.
//

import UIKit

// MARK:- LabelInfo
public extension Segmenter.Segment {
    
    struct LabelInfo: SegmentUserInfo {
        public var title: String?
        
        public var activeFont: UIFont?
        public var activeColor: UIColor?
        public var inactiveFont: UIFont?
        public var inactiveColor: UIColor?
        
        public init(title: String, activeFont: UIFont? = nil, activeColor: UIColor? = nil, inactiveFont: UIFont? = nil, inactiveColor: UIColor? = nil) {
            self.title = title
            
            self.activeFont = activeFont
            self.activeColor = activeColor
            self.inactiveFont = inactiveFont
            self.inactiveColor = inactiveColor
        }
    }
    
}
