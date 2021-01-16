//
//  File.swift
//  
//
//  Created by iWw on 2021/1/4.
//

import UIKit

public struct SegmentView {
    
    public var activeView: UIView
    public var inactiveView: UIView?
    
    public var activeSize: CGSize
    public var inactiveSize: CGSize
    
    /// SegmentView 自定义视图
    /// - Parameters:
    ///   - activeView: 激活状态的视图
    ///   - inactiveView: 可选，未激活状态的视图
    ///   - activeSize: 激活状态的大小
    ///   - inactiveSize: 未激活状态的大小
    ///                 两个大小需要宽高比一致，否则动画会出现异常情况
    public init(activeView: UIView, inactiveView: UIView? = nil, activeSize: CGSize, inactiveSize: CGSize) {
        self.activeView = activeView
        self.activeSize = activeSize
        self.inactiveView = inactiveView
        self.inactiveSize = inactiveSize
    }
}

public extension Segmenter {
    
    struct Segment {
        public var title: String
        public var isShouldHideShadow = false
        
        // Independent control properties
        // use Segmenter's segmentConfigure if nil
        public var activeFont: UIFont?
        public var inactiveFont: UIFont?
        public var activeColor: UIColor?
        public var inactiveColor: UIColor?
        
        public var supplementaryViews: [SupplementView] = []
        
        public var view: SegmentView?
        
        // TODO:
        public var customView: UIView?
        public var customViewOffset = CGPoint(x: -5, y: -5)
        // -------
        
        public init(title: String? = nil, view: SegmentView? = nil,
                    supplementaryViews: [SupplementView] = [],
                    activeColor aColor: UIColor? = nil, inactiveColor iaColor: UIColor? = nil,
                    activeFont aFont: UIFont? = nil, inactiveFont iaFont: UIFont? = nil,
                    isShouldHideShadow: Bool = false) {
            self.title = title ?? ""
            self.isShouldHideShadow = isShouldHideShadow
            
            self.activeColor = aColor
            self.inactiveColor = iaColor
            self.activeFont = aFont
            self.inactiveFont = iaFont
            
            self.view = view
            
            self.supplementaryViews = supplementaryViews
        }
    }
    
}

public extension Segmenter.Segment {
    
    enum SupplementView {
        case view(_ view: UIView, _ verticalOffset: CGFloat = 0)
        
        var view: UIView {
            switch self {
            case let .view(view, _):
                return view
            }
        }
        
        var offset: CGFloat {
            switch self {
            case let .view(_, offset):
                return offset
            }
        }
    }
    
}
