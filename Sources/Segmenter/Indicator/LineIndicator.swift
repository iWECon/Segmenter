//
//  LineIndicator.swift
//  Segmenter
//
//  Created by i on 2023/4/25.
//

import UIKit

public final class LineIndicator: UIView, Indicator {
    
    public var spacing: CGFloat { 4 }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame.size = CGSize(width: 20, height: 4)
        self.backgroundColor = .systemPink
        self.layer.cornerRadius = 3
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func install(withSementView segmentView: SegmentView) {
        UIView.animate(withDuration: Segmenter.default.animateDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9) {
            self.frame.size = CGSize(width: segmentView.frame.width, height: 4)
        }
    }
    
    enum Behavior {
        case forward, backward
    }
    
    public func change(from: SegmentView, to: SegmentView) {
        var right: CGFloat = 0
        let behavior: Behavior
        if from.frame.minX < to.frame.minX {
            behavior = .forward
        } else {
            behavior = .backward
            right = self.frame.maxX
        }
        
        UIView.animateKeyframes(withDuration: Segmenter.default.animateDuration, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                switch behavior {
                case .forward:
                    self.frame.size.width = (from.frame.maxX - from.frame.minX) + (to.frame.maxX - to.frame.minX)
                case .backward:
                    self.frame.size.width = (from.frame.maxX - to.frame.minX)
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
