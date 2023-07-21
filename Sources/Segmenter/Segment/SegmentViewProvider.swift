//
//  Created by iWw on 2021/1/21.
//

import UIKit

public protocol SegmentViewProvider {
    
    init(_ segment: Segment, info: SegmentInfoProvider)
    var activeSize: CGSize { get }
    var inactiveSize: CGSize { get }
    
    // override
    var isSelected: Bool { get set }
    func layoutSubviews()
    func sizeThatFits(_ size: CGSize) -> CGSize
}
