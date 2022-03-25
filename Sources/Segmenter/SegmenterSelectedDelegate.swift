//
//  Created by i on 2022/3/24.
//

import UIKit

public protocol SegmenterSelectedDelegate: AnyObject {
    
    func segmenter(_ segmenter: Segmenter, didSelect index: Int, withSegment segment: Segment, fromIndex: Int, fromSegment: Segment)
    
}
