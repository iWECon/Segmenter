//
//  Created by iWw on 2021/1/21.
//

import UIKit

// MARK:- ImageInfo
public extension Segmenter.Segment {
    
    class ImageInfo: SegmentUserInfo {
        public var activeImage: UIImage
        public var inactiveImage: UIImage?
        
        public var activeSize: CGSize
        public var inactiveSize: CGSize
        
        public init(activeImage: UIImage, inacitveImage: UIImage? = nil, activeSize: CGSize, inactiveSize: CGSize) {
            self.activeImage = activeImage
            self.activeSize = activeSize
            self.inactiveSize = inactiveSize
            self.inactiveImage = inacitveImage
        }
    }
    
}
