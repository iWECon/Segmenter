//
//  Created by iWw on 2021/1/21.
//

import UIKit

extension Segmenter.Segment {
    
    class Image: View {
        
        required init(_ segment: Segmenter.Segment, configure: Segmenter.SegmentConfigure) {
            guard let info = segment.kind.userInfo as? ImageInfo,
                  segment.kind.segmentViewType == Image.self
            else {
                fatalError("UserInfo and segmentViewType do not match.")
            }
            
            func makeImageView(_ image: UIImage?) -> UIImageView? {
                guard let image = image else { return nil }
                
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.layer.anchorPoint = .init(x: 0, y: 1)
                imageView.image = image
                return imageView
            }
            
            let viewInfo = ViewInfo(activeView: makeImageView(info.activeImage)!,
                                    inactiveView: makeImageView(info.inactiveImage),
                                    activeSize: info.activeSize, inactiveSize: info.inactiveSize)
            super.init(Segmenter.Segment(kind: .view(viewInfo)), configure: configure)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}
