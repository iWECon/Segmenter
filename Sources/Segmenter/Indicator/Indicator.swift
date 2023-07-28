//
//  Indicator.swift
//  Segmenter
//
//  Created by i on 2023/4/25.
//

import UIKit

public protocol Indicator: UIView {
    
    /// Spacing between `Indicator` and `SegmentView`, default is 2
    var spacing: CGFloat { get }
    
    func install(withSementView sementView: SegmentView)
    
    func change(from: SegmentView, to: SegmentView)
}

extension Indicator {
    public var spacing: CGFloat { 2 }
}
