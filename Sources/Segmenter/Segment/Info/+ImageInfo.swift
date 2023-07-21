//
//  Created by iWw on 2021/1/21.
//

import UIKit

public protocol SegmentImageInfoProvider: SegmentInfoProvider {
    var activeImage: UIImage { get }
    var inactiveImage: UIImage? { get }
    
    var activeSize: CGSize { get }
    var inactiveSize: CGSize { get }
}

// MARK: ImageInfo
extension Segment {
    
    struct _ImageInfo: SegmentImageInfoProvider {
        var viewType: (SegmentView).Type {
            Image.self
        }
        
        var activeImage: UIImage
        var inactiveImage: UIImage?
        
        var activeSize: CGSize
        var inactiveSize: CGSize
        
        init(
            activeImage: UIImage,
            inacitveImage: UIImage? = nil,
            activeSize: CGSize,
            inactiveSize: CGSize
        ) {
            self.activeImage = activeImage
            self.activeSize = activeSize
            self.inactiveSize = inactiveSize
            self.inactiveImage = inacitveImage
        }
    }
    
}
