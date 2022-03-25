//
//  Created by iWw on 2021/1/21.
//

import UIKit

// MARK:- LabelInfo
extension Segment {
    
    struct _LabelInfo: SegmentInfoProvider {
        var viewType: (SegmentView).Type {
            _Label.self
        }
        
        let title: String?
        
        let activeFont: UIFont?
        let activeColor: UIColor?
        let inactiveFont: UIFont?
        let inactiveColor: UIColor?
        
        init(title: String, activeFont: UIFont? = nil, activeColor: UIColor? = nil, inactiveFont: UIFont? = nil, inactiveColor: UIColor? = nil) {
            self.title = title
            
            self.activeFont = activeFont
            self.activeColor = activeColor
            self.inactiveFont = inactiveFont
            self.inactiveColor = inactiveColor
        }
    }
    
}
