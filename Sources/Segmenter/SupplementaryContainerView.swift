//
//  Created by iWw on 2021/1/8.
//

import UIKit

protocol SegmenterSupplementaryContainer { }

public class SupplementaryContainerView: UIView, SegmenterSupplementaryContainer {
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subview in subviews.reversed() {
            let isValidResponderView = !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled
            guard isValidResponderView else {
                continue
            }
            
            if let subviewHitTest = subview.hitTest(point, with: event) {
                return subviewHitTest
            }
            if subview.frame.contains(point) {
                return subview
            }
            return super.hitTest(point, with: event)
        }
        return nil
    }
    
    override public class var layerClass: AnyClass {
        CAGradientLayer.self
    }
    
    public func setColors(_ colors: [UIColor], startPoint: CGPoint = .init(x: 1, y: 0.5), endPoint: CGPoint = .init(x: 0, y: 0.5)) {
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        gradientLayer.colors = colors.count > 0 ? colors.map({ $0.cgColor }) : nil
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = [0.8, 1.0]
        
        guard colors.count > 0 else { return }
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
}
