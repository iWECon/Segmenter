//
//  File.swift
//  
//
//  Created by iWw on 2021/1/4.
//

import UIKit

public typealias SegmentView = UIControl & SegmentViewProvider

public struct Segment {
    
    enum Kind {
        case label(_ info: _LabelInfo)
        case image(_ info: _ImageInfo)
        case view(_ info: _ViewInfo)
        case custom(_ info: SegmentInfoProvider)
        
        var segmentInfo: SegmentInfoProvider {
            switch self {
            case .label(let info):
                return info
            case .image(let info):
                return info
            case .view(let info):
                return info
            case .custom(let info):
                return info
            }
        }
    }
    
    let kind: Kind
    public let isShouldHideShadow: Bool
    public let supplementaryViews: [SupplementView]
    
    public var info: SegmentInfoProvider {
        kind.segmentInfo
    }
    
    init(kind: Kind,
         supplementaryViews: [SupplementView] = [],
         shadowHidden: Bool = false) {
        self.kind = kind
        self.isShouldHideShadow = shadowHidden
        self.supplementaryViews = supplementaryViews
    }
    
    // MARK: convenience init
    /// for default label
    public init(title: String,
                supplementaryViews: [SupplementView] = [], shadowHidden: Bool = false,
                activeFont: UIFont = UIFont.systemFont(ofSize: 24, weight: .medium), activeColor: UIColor = UIColor.black,
                inactiveFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular), inactiveColor: UIColor = UIColor.gray) {
        self.init(
            kind: .label(_LabelInfo(title: title, activeFont: activeFont, activeColor: activeColor, inactiveFont: inactiveFont, inactiveColor: inactiveColor)),
            supplementaryViews: supplementaryViews,
            shadowHidden: shadowHidden
        )
    }
    
    /// for custom image
    public init(image: UIImage, inactiveImage: UIImage? = nil,
                activeSize: CGSize, inactiveSize: CGSize,
                supplementaryViews: [SupplementView] = [], shadowHidden: Bool = false) {
        self.init(
            kind: .image(_ImageInfo(activeImage: image, inacitveImage: inactiveImage, activeSize: activeSize, inactiveSize: inactiveSize)),
            supplementaryViews: supplementaryViews,
            shadowHidden: shadowHidden
        )
    }
    
    /// for custom view
    public init(view: UIView, inactiveView: UIView? = nil,
                activeSize: CGSize, inactiveSize: CGSize,
                supplementaryViews: [SupplementView] = [], shadowHidden: Bool = false) {
        self.init(
            kind: .view(_ViewInfo(activeView: view, inactiveView: inactiveView, activeSize: activeSize, inactiveSize: inactiveSize)),
            supplementaryViews: supplementaryViews,
            shadowHidden: shadowHidden
        )
    }
    
    /// for custom view with (UIControl & SegmentViewProvider)
    public init(custom: SegmentInfoProvider,
                supplementaryViews: [SupplementView] = [], shadowHidden: Bool = false) {
        self.init(
            kind: .custom(custom),
            supplementaryViews: supplementaryViews,
            shadowHidden: shadowHidden
        )
    }
}

public extension Segment {
    
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
