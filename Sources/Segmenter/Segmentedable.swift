//
//  Created by iWw on 2021/1/6.
//

import UIKit

struct SegmenterKeys {
    static var segmenterKey = "SegmenterKeys.segmenterKey"
}

public protocol Segmentedable {
    var segmenter: Segmenter { get set }
}

public extension Segmentedable {
    
    var segmenter: Segmenter {
        get {
            guard let segmenter = objc_getAssociatedObject(self, &SegmenterKeys.segmenterKey) as? Segmenter else {
                let segmenter = Segmenter()
                objc_setAssociatedObject(self, &SegmenterKeys.segmenterKey, segmenter, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return segmenter
            }
            return segmenter
        }
        set {
            objc_setAssociatedObject(self, &SegmenterKeys.segmenterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension Segmentedable where Self: UIViewController {
    
    var segmenter: Segmenter {
        get {
            guard let segmenter = objc_getAssociatedObject(self, &SegmenterKeys.segmenterKey) as? Segmenter else {
                let segmenter = Segmenter()
                objc_setAssociatedObject(self, &SegmenterKeys.segmenterKey, segmenter, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.view.addSubview(segmenter)
                return segmenter
            }
            return segmenter
        }
        set {
            objc_setAssociatedObject(self, &SegmenterKeys.segmenterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
