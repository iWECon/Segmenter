//
//  Created by iWw on 2021/1/21.
//

import UIKit

extension Segment {
    
    class _ImageInfo: SegmentInfoProvider {
        var viewType: (SegmentView).Type {
            _Image.self
        }
        
        let activeImage: UIImage
        let inactiveImage: UIImage?
        
        let activeSize: CGSize
        let inactiveSize: CGSize
        
        init(activeImage: UIImage, inacitveImage: UIImage? = nil, activeSize: CGSize, inactiveSize: CGSize) {
            self.activeImage = activeImage
            self.activeSize = activeSize
            self.inactiveSize = inactiveSize
            self.inactiveImage = inacitveImage
        }
    }
    
}
