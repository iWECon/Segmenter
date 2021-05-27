//
//  Created by iWw on 2021/1/21.
//

import UIKit

public protocol SegmentViewProvider {
    
    var activeSize: CGSize { get }
    var inactiveSize: CGSize { get }
    
    init(_ segment: Segmenter.Segment, configure: Segmenter.SegmentConfigure)
    
    func layoutSubviews()
    func sizeThatFits(_ size: CGSize) -> CGSize
}
