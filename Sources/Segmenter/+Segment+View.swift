//
//  Created by iWw on 2021/1/4.
//

import UIKit

extension Segmenter.Segment {
    
    typealias Segment = Segmenter.Segment
    
    class View: UIControl {
        
        lazy var activeLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.alpha = 0
            label.font = .systemFont(ofSize: 22, weight: .medium)
            label.textColor = .darkText
            label.layer.anchorPoint = .init(x: 0, y: 1)
            return label
        }()
        
        lazy var inactiveLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.alpha = 0
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.textColor = .red
            label.layer.anchorPoint = .init(x: 0, y: 1)
            return label
        }()
        
        override var isSelected: Bool {
            didSet {
                let selected = isSelected
                super.isSelected = selected
                
                sizeToFit()
                
                if !isCustomView {
                    activeLabel.alpha = selected ? 1 : 0
                    inactiveLabel.alpha = selected ? 0 : 1
                    
                    let zoomScale: CGFloat = activeLabel.font.pointSize / inactiveLabel.font.pointSize
                    guard zoomScale != 1 else { return }
                    activeLabel.transform = selected ? CGAffineTransform(translationX: 0, y: zoomScale) : CGAffineTransform(scaleX: 1 / zoomScale, y: 1 / zoomScale)
                    inactiveLabel.transform = selected ? CGAffineTransform(scaleX: zoomScale, y: zoomScale).concatenating(CGAffineTransform(translationX: 0, y: zoomScale)) : .identity
                    
                } else {
                    let isSingleView = customActiveView == nil || customInactiveView == nil
                    
                    if isSingleView {
                        customActiveView?.alpha = 1
                        customActiveView?.frame.size = selected ? customViewActiveSize : customViewInactiveSize
                    } else {
                        customActiveView?.alpha = selected ? 1 : 0
                        customInactiveView?.alpha = selected ? 0 : 1
                        
                        let zoomScale = customViewActiveSize.width / customViewInactiveSize.width
                        guard zoomScale != 1 else { return }
                        customActiveView?.transform = selected ? CGAffineTransform(translationX: 0, y: zoomScale) : CGAffineTransform(scaleX: 1 / zoomScale, y: 1 / zoomScale)
                        customInactiveView?.transform = selected ? CGAffineTransform(scaleX: zoomScale, y: zoomScale).concatenating(CGAffineTransform(translationX: 0, y: zoomScale)) : .identity
                    }
                }
            }
        }
        
        var activeSize: CGSize {
            activeLabel.frame.size
        }
        var inactiveSize: CGSize {
            inactiveLabel.frame.size
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            layoutIfNeeded()
            if isCustomView {
                return isSelected ? customViewActiveSize : customViewInactiveSize
            }
            return isSelected ? activeLabel.intrinsicContentSize : inactiveLabel.intrinsicContentSize
        }
        
        var isCustomView = false
        var customActiveView: UIView?
        var customInactiveView: UIView?
        var customViewActiveSize: CGSize = .zero
        var customViewInactiveSize: CGSize = .zero
        
        required init(_ segment: Segment, configure: Segmenter.SegmentConfigure) {
            super.init(frame: .zero)
            
            isCustomView = segment.view != nil
            
            if !isCustomView {
                addSubview(inactiveLabel)
                addSubview(activeLabel)
                
                activeLabel.text = segment.title
                inactiveLabel.text = segment.title
                
                activeLabel.font = segment.activeFont ?? configure.activeFont
                inactiveLabel.font = segment.inactiveFont ?? configure.inactiveFont
                
                activeLabel.textColor = segment.activeColor ?? configure.activeColor
                inactiveLabel.textColor = segment.inactiveColor ?? configure.inactiveColor
                
            } else {
                customActiveView = segment.view?.activeView
                if segment.view?.activeView == segment.view?.inactiveView {
                    let viewArchived = NSKeyedArchiver.archivedData(withRootObject: segment.view!.activeView)
                    let view = NSKeyedUnarchiver.unarchiveObject(with: viewArchived) as? UIView
                    customInactiveView = view
                } else {
                    customInactiveView = segment.view?.inactiveView
                }
                
                customViewActiveSize = segment.view!.activeSize
                customViewInactiveSize = segment.view!.inactiveSize
                
                if let caView = customActiveView {
                    addSubview(caView)
                    caView.layer.anchorPoint = .init(x: 0, y: 1)
                    caView.frame.size = segment.view!.activeSize
                }
                if let ciaView = customInactiveView {
                    addSubview(ciaView)
                    ciaView.layer.anchorPoint = .init(x: 0, y: 1)
                    ciaView.frame.size = segment.view!.inactiveSize
                }
            }
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            if !isCustomView {
                activeLabel.sizeToFit()
                inactiveLabel.sizeToFit()
                
                activeLabel.frame.origin = .init(x: 0, y: self.frame.height - activeLabel.frame.height)
                inactiveLabel.frame.origin = .init(x: 0, y: self.frame.height - inactiveLabel.frame.height)
            } else {
                if let caView = customActiveView {
                    caView.frame.origin = .init(x: 0, y: self.frame.height - caView.frame.height)
                }
                if let ciaView = customInactiveView {
                    ciaView.frame.origin = .init(x: 0, y: self.frame.height - ciaView.frame.height)
                }
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
}
