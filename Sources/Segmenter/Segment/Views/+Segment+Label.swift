//
//  Created by iWw on 2021/1/4.
//

import UIKit

extension Segment {
    
    open class Label: UIControl, SegmentViewProvider {
        
        public required init(_ segment: Segment, info: SegmentInfoProvider) {
            super.init(frame: .zero)
            
            guard let labelInfo = info as? SegmentLabelInfoProvider else {
                fatalError("SegmentInfoProvider do not match as `SegmentLabelInfoProvider`.")
            }
            
            addSubview(activeLabel)
            addSubview(inactiveLabel)
            
            activeLabel.text = labelInfo.title
            inactiveLabel.text = labelInfo.title
            
            activeLabel.font = labelInfo.activeFont
            inactiveLabel.font = labelInfo.inactiveFont
            
            activeLabel.textColor = labelInfo.activeColor
            inactiveLabel.textColor = labelInfo.inactiveColor
        }
        
        open lazy var activeLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.alpha = 0
            label.font = .systemFont(ofSize: 22, weight: .medium)
            label.textColor = .darkText
            label.layer.anchorPoint = .init(x: 0, y: 1)
            return label
        }()
        
        open lazy var inactiveLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.alpha = 0
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.textColor = .red
            label.layer.anchorPoint = .init(x: 0, y: 1)
            return label
        }()
        
        open var activeSize: CGSize {
            activeLabel.frame.size
        }
        
        open var inactiveSize: CGSize {
            inactiveLabel.frame.size
        }
        
        open override func sizeThatFits(_ size: CGSize) -> CGSize {
            invalidateIntrinsicContentSize()
            layoutIfNeeded()
            return isSelected ? activeLabel.intrinsicContentSize : inactiveLabel.intrinsicContentSize
        }
        
        open override var isSelected: Bool {
            didSet {
                sizeToFit()
                
                activeLabel.alpha = isSelected ? 1 : 0
                inactiveLabel.alpha = isSelected ? 0 : 1
                
                let zoomScale: CGFloat = activeLabel.font.pointSize / inactiveLabel.font.pointSize
                guard zoomScale != 1 else { return }
                activeLabel.transform = isSelected ? CGAffineTransform(translationX: 0, y: zoomScale) : CGAffineTransform(scaleX: 1 / zoomScale, y: 1 / zoomScale)
                inactiveLabel.transform = isSelected ? CGAffineTransform(scaleX: zoomScale, y: zoomScale).concatenating(CGAffineTransform(translationX: 0, y: zoomScale)) : .identity
            }
        }
        
        open override func layoutSubviews() {
            super.layoutSubviews()
            
            activeLabel.sizeToFit()
            inactiveLabel.sizeToFit()
            
            activeLabel.frame.origin = .init(x: 0, y: self.frame.height - activeLabel.frame.height)
            inactiveLabel.frame.origin = .init(x: 0, y: self.frame.height - inactiveLabel.frame.height)
        }
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
        }
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
