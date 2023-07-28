//
//  LineIndicator.swift
//  Segmenter
//
//  Created by i on 2023/4/25.
//

import UIKit

public final class LineIndicator: UIView, Indicator {
    
    public static var defaultColors: [CGColor] = [UIColor.systemPink.cgColor, UIColor.systemPink.cgColor]
    
    public var transitionDelegate: IndicatorTransitionDelegate?
    
    public override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
    
    public final var gradientLayer: CAGradientLayer {
        self.layer as! CAGradientLayer
    }
    
    /// Set background for LineIndicator with `[CGColor]`
    public var backgroundColors: [CGColor] = LineIndicator.defaultColors {
        didSet {
            if backgroundColors.count == 1 {
                self.gradientLayer.colors = [backgroundColors.first!, backgroundColors.first!]
            } else {
                self.gradientLayer.colors = backgroundColors
            }
        }
    }
    
    public var spacing: CGFloat { 4 }
    
    @available(*, unavailable, message: "Use `gradientLayer.colors`")
    public override var backgroundColor: UIColor? {
        get { nil } set { }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame.size = CGSize(width: 20, height: 4)
        self.gradientLayer.colors = Self.defaultColors
        self.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        self.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.cornerRadius = 3
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func install(withSementView segmentView: SegmentView) {
        self.frame.size = CGSize(width: segmentView.frame.width, height: 4)
        self.frame.origin.x = segmentView.frame.minX
    }
    
    public func change(from: SegmentView, to: SegmentView) {
        var right: CGFloat = 0
        let behavior: IndicatorDirection
        if from.frame.minX < to.frame.minX {
            behavior = .forward
        } else {
            behavior = .backward
            right = self.frame.maxX
        }
        
        UIView.animateKeyframes(withDuration: Segmenter.default.animateDuration, delay: 0, options: [.beginFromCurrentState, .calculationModeCubicPaced]) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                
                self.transitionDelegate?.indicatorTransition(self, from: from, to: to, direction: behavior)
                
                switch behavior {
                case .forward:
                    self.frame.size.width = (to.frame.midX - from.frame.minX)
                case .backward:
                    self.frame.size.width = (from.frame.maxX - to.frame.midX)
                    self.frame.origin.x = right - self.frame.width
                }
            }
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7) {
                self.frame.size.width = to.frame.width
                self.frame.origin.x = to.frame.minX
            }
        }
    }
}
