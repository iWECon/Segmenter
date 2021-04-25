//
//  Created by iWw on 2021/1/6.
//

import UIKit

public class SegmenterGradientView: UIView {
    
    override public class var layerClass: AnyClass {
        get { CAGradientLayer.self } set { }
    }
    
    public var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint, locations: [NSNumber]? = nil) {
        super.init(frame: .zero)
        
        self.set(colors: colors, startPoint: startPoint, endPoint: endPoint, locations: locations)
    }
    
    public func set(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint, locations: [NSNumber]? = nil) {
        gradientLayer.colors = colors.map({ $0.cgColor })
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
