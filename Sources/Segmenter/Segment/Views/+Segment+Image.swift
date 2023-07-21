//
//  Created by iWw on 2021/1/21.
//

import UIKit

extension Segment {
    
    open class Image: View {
        
        public required init(_ segment: Segment, info: SegmentInfoProvider) {
            guard let info = info as? SegmentImageInfoProvider else {
                fatalError("SegmentInfoProvider do not match as `SegmentImageInfoProvider`.")
            }
            
            func makeImageView(_ image: UIImage?) -> UIImageView? {
                guard let image = image else { return nil }
                
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.layer.anchorPoint = .init(x: 0, y: 1)
                imageView.image = image
                return imageView
            }
            
            let viewInfo = _ViewInfo(activeView: makeImageView(info.activeImage)!,
                                    inactiveView: makeImageView(info.inactiveImage),
                                    activeSize: info.activeSize, inactiveSize: info.inactiveSize)
            super.init(Segment(kind: .view(viewInfo)), info: viewInfo)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}
