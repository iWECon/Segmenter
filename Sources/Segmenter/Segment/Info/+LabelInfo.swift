//
//  Created by iWw on 2021/1/21.
//

import UIKit

public protocol SegmentLabelInfoProvider: SegmentInfoProvider {
    var title: String? { get }
    
    var activeFont: UIFont? { get }
    var activeColor: UIColor? { get }
    var inactiveFont: UIFont? { get }
    var inactiveColor: UIColor? { get }
}

// MARK:- LabelInfo
extension Segment {
    
    struct _LabelInfo: SegmentLabelInfoProvider {
        var viewType: (SegmentView).Type {
            Label.self
        }
        
        var title: String?
        
        var activeFont: UIFont?
        var activeColor: UIColor?
        var inactiveFont: UIFont?
        var inactiveColor: UIColor?
        
        init(title: String, activeFont: UIFont? = nil, activeColor: UIColor? = nil, inactiveFont: UIFont? = nil, inactiveColor: UIColor? = nil) {
            self.title = title
            
            self.activeFont = activeFont
            self.activeColor = activeColor
            self.inactiveFont = inactiveFont
            self.inactiveColor = inactiveColor
        }
    }
    
}
