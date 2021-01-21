//
//  Created by iWw on 2021/1/21.
//

import UIKit

extension Segmenter.Segment {
    
    class View: UIControl & SegmentViewProvider {
        
        var activeView: UIView
        
        var inactiveView: UIView?
        
        var isSingleView = false
        
        var activeSize: CGSize = .zero
        
        var inactiveSize: CGSize = .zero
        
        override var isSelected: Bool {
            didSet {
                sizeToFit()
                
                if isSingleView {
                    activeView.alpha = 1
                    activeView.frame.size = isSelected ? activeSize : inactiveSize
                } else {
                    activeView.alpha = isSelected ? 1 : 0
                    inactiveView?.alpha = isSelected ? 0 : 1
                    
                    let zoomScale = activeSize.width / inactiveSize.width
                    guard zoomScale != 1 else { return }
                    activeView.transform = isSelected ? CGAffineTransform(translationX: 0, y: zoomScale) : CGAffineTransform(scaleX: 1 / zoomScale, y: 1 / zoomScale)
                    inactiveView?.transform = isSelected ? CGAffineTransform(scaleX: zoomScale, y: zoomScale).concatenating(CGAffineTransform(translationX: 0, y: zoomScale)) : .identity
                }
            }
        }
        
        required init(_ segment: Segmenter.Segment, configure: Segmenter.SegmentConfigure) {
            guard let info = segment.kind.userInfo as? Segmenter.Segment.ViewInfo,
                  segment.kind.segmentViewType == View.self
            else {
                fatalError("UserInfo and segmentViewType do not match")
            }
            
            self.isSingleView = true
            self.activeView = info.activeView
            self.activeView.frame.size = info.activeSize
            self.activeView.layer.anchorPoint = .init(x: 0, y: 1)
            super.init(frame: .zero)
            
            addSubview(self.activeView)
            
            self.activeSize = info.activeSize
            self.inactiveSize = info.inactiveSize
            
            if let inactiveView = info.inactiveView {
                self.isSingleView = false
                
                self.inactiveView = inactiveView
                self.inactiveView?.frame.size = info.inactiveSize
                self.inactiveView?.layer.anchorPoint = .init(x: 0, y: 1)
                addSubview(self.inactiveView!)
            }
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            layoutIfNeeded()
            return isSelected ? activeSize : inactiveSize
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            if !isSingleView {
                inactiveView?.frame.origin = .init(x: 0, y: self.frame.height - (inactiveView?.frame.height ?? 0))
            }
            activeView.frame.origin = .init(x: 0, y: self.frame.height - activeView.frame.height)
        }
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
