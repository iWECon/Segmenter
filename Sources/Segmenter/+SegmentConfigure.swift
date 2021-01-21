//
//  Segmenter+SegmentConfigure.swift
//  Segmenter
//
//  Created by iWw on 2021/1/11.
//

import UIKit

public extension Segmenter {
    
    struct SegmentConfigure {
        public var activeColor: UIColor = .black
        public var activeFont: UIFont = .systemFont(ofSize: 24, weight: .medium)
        
        public var inactiveColor: UIColor = .gray
        public var inactiveFont: UIFont = .systemFont(ofSize: 16, weight: .regular)
        
        public var segmentView: (UIView & SegmentViewProvider)?
        
        public init(activeColor: UIColor = .black,
                    inactiveColor: UIColor = .gray,
                    activeFont: UIFont = .systemFont(ofSize: 24, weight: .medium),
                    inactiveFont: UIFont = .systemFont(ofSize: 16, weight: .regular)) {
            self.activeColor = activeColor
            self.inactiveColor = inactiveColor
            self.activeFont = activeFont
            self.inactiveFont = inactiveFont
        }
    }
}

public extension Segmenter.SegmentConfigure {
    
    static let main = Segmenter.SegmentConfigure()
    
    static let minor = Segmenter.SegmentConfigure(activeFont: .systemFont(ofSize: 12, weight: .medium), inactiveFont: .systemFont(ofSize: 12, weight: .regular))
    
}
    
