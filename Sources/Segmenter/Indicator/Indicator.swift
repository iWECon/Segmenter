//
//  Indicator.swift
//  Segmenter
//
//  Created by i on 2023/4/25.
//

import UIKit

public protocol Indicator: UIView {
    
    /// Spacing between `Indicator` and `SegmentView`, default is 6
    var spacing: CGFloat { get }
    
    var initialSize: CGSize { get }
    
    func install(withSementView sementView: SegmentView)
    
    func change(from: SegmentView, to: SegmentView)
}

extension Indicator {
    public var spacing: CGFloat { 4 }
}
