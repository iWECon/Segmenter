//
//  File.swift
//  
//
//  Created by iWw on 2021/1/4.
//

import UIKit

public extension Segmenter {
    
    struct Segment {
        
        public enum Kind {
            case label(_ info: LabelInfo)
            case image(_ info: ImageInfo)
            case view(_ info: ViewInfo)
            case custom(_ info: SegmentUserInfo, type: (UIControl & SegmentViewProvider).Type)
            
            var userInfo: SegmentUserInfo {
                switch self {
                case .label(let info):
                    return info
                case .image(let info):
                    return info
                case .view(let info):
                    return info
                case .custom(let info, _):
                    return info
                }
            }
            
            var segmentViewType: (UIControl & SegmentViewProvider).Type {
                switch self {
                case .label:
                    return Segment.Label.self
                case .image:
                    return Segment.Image.self
                case .view:
                    return Segment.View.self
                case .custom(_, let type):
                    return type
                }
            }
        }
        
        public var kind: Kind
        public var isShouldHideShadow = false
        public var supplementaryViews: [SupplementView] = []
        
        public init(kind: Kind,
                    supplementaryViews: [SupplementView] = [],
                    shadowHidden: Bool = false) {
            self.kind = kind
            self.isShouldHideShadow = shadowHidden
            self.supplementaryViews = supplementaryViews
        }
        
        // convenience init
        public init(title: String,
                    supplementaryViews: [SupplementView] = [], shadowHidden: Bool = false,
                    activeFont: UIFont? = nil, activeColor: UIColor? = nil,
                    inactiveFont: UIFont? = nil, inactiveColor: UIColor? = nil) {
            self.init(kind: .label(.init(title: title, activeFont: activeFont, activeColor: activeColor, inactiveFont: inactiveFont, inactiveColor: inactiveColor)), supplementaryViews: supplementaryViews, shadowHidden: shadowHidden)
        }
        
        public init(image: UIImage,
                    inactiveImage: UIImage? = nil, activeSize: CGSize, inactiveSize: CGSize,
                    supplementaryViews: [SupplementView] = [], shadowHidden: Bool = false) {
            self.init(kind: .image(.init(activeImage: image, inacitveImage: inactiveImage, activeSize: activeSize, inactiveSize: inactiveSize)), supplementaryViews: supplementaryViews, shadowHidden: shadowHidden)
        }
        
        public init(view: UIView,
                    inactiveView: UIView? = nil, activeSize: CGSize, inactiveSize: CGSize,
                    supplementaryViews: [SupplementView] = [], shadowHidden: Bool = false) {
            self.init(kind: .view(.init(activeView: view, inactiveView: inactiveView, activeSize: activeSize, inactiveSize: inactiveSize)))
        }
        
        public init(custom: (UIControl & SegmentViewProvider).Type, info: SegmentUserInfo,
                    supplementaryViews: [SupplementView] = [], shadowHidden: Bool = false) {
            self.init(kind: .custom(info, type: custom))
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
