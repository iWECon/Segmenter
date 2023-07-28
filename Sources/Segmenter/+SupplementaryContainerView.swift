//
//  Created by iWw on 2021/1/8.
//

import UIKit

protocol SegmenterSupplementaryContainer { }

public extension Segmenter {
    
    class SupplementaryContainerView: UIView, SegmenterSupplementaryContainer {
        
        public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let filteredSubviews = subviews.filter({ !$0.isHidden && $0.alpha > 0 && $0.isUserInteractionEnabled })
            for subview in filteredSubviews {
                if subview.frame.contains(point) {
                    return subview
                }
            }
            return super.hitTest(point, with: event)
        }
        
        override public class var layerClass: AnyClass {
            CAGradientLayer.self
        }
        
        public func setColors(_ colors: [UIColor], startPoint: CGPoint = .init(x: 1, y: 0.5), endPoint: CGPoint = .init(x: 0, y: 0.5)) {
            guard let gradientLayer = layer as? CAGradientLayer else { return }
            gradientLayer.colors = !colors.isEmpty ? colors.map({ $0.cgColor }) : nil
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
            gradientLayer.locations = [0.8, 1.0]
            
            guard !colors.isEmpty else { return }
            previousInfo = (colors, startPoint, endPoint)
        }
        
        var previousInfo: (colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) = ([], .zero, .zero)
        
        public func clearGradientColor() {
            guard let gradientLayer = layer as? CAGradientLayer else { return }
            gradientLayer.colors = nil
        }
        
        public func restoreGradientColor() {
            setColors(previousInfo.colors, startPoint: previousInfo.startPoint, endPoint: previousInfo.endPoint)
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            guard !frame.width.isZero, let gradientLayer = layer as? CAGradientLayer else { return }
            let fromFloat = Double(min(0.9, 1.0 - (25 / frame.width)))
            let from = NSNumber(value: fromFloat)
            gradientLayer.locations = [from, 1.0]
        }
    }

}
