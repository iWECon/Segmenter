
import UIKit

extension UIEdgeInsets {
    
    var vertical: CGFloat {
        top + bottom
    }
    var horizontal: CGFloat {
        left + right
    }
    
}

public protocol SegmenterSelectedDelegate: class {
    
    func segmenter(_ segmenter: Segmenter,
                   didSelect index: Int,
                   withSegment segment: Segmenter.Segment,
                   fromIndex: Int,
                   fromSegment: Segmenter.Segment)
    
}

public class Segmenter: UIControl {
    
    /// The style here is the overall default style, and the configuration information is taken from here if the Segmenter is not configured as follows after initialization
    /// Even if the default style is configured, it can be configured independently in the Segmenter instance
    public struct Appearance {
        public var segmentSpacing: CGFloat = 15
        public var contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 6, right: 15)
        public var animateDuration: TimeInterval = 0.34
        public var shadowColor: UIColor = UIColor.black.withAlphaComponent(0.2)
        
        /// Spacing between SupplementaryViews
        public var supplementaryViewSpacing: CGFloat = 10
        /// SupplementaryViews are shifted vertically as a whole, positive numbers down, negative numbers up
        public var supplementaryVerticallyOffset: CGFloat = 0
        /// SupplementaryViews are shifted horizontally as a whole, with positive numbers to the right and negative numbers to the left
        public var supplementaryHorizontallyOffset: CGFloat = 0
    }
    public static var `default` = Appearance()
    
    public static let Height: CGFloat = 44
    public static let SupplementaryButtonHeight: CGFloat = 24
    
    // MARK: - Custom properties
    public weak var delegate: SegmenterSelectedDelegate?
    
    @IBInspectable public var isShadowShouldShow = true {
        didSet {
            shadowView.alpha = isShadowShouldShow ? 1 : 0
        }
    }
    
    /// use `backgroundView.background` or `backgroundView.set(colors:startPoint:endPoint:locations:)` to set backgroundColor
    public let backgroundView = GradientView()
    
    /// some property(left/right) won’t be join calculate when use `.cetered` or `.evened`
    /// default is .init(top: 0, left: 15, bottom: 6, right: 15)
    @IBInspectable public lazy var contentInset: UIEdgeInsets = Self.default.contentInset {
        didSet {
            layoutSubviews()
        }
    }
    
    /// won't be join calculate when use `.evened` and `.aroundEvened`, default is 15
    @IBInspectable public lazy var segmentSpacing: CGFloat = Self.default.segmentSpacing {
        didSet {
            layoutSubviews()
        }
    }
    
    /// default is 10
    /// 附加视图之间的间距
    @IBInspectable public lazy var supplementaryViewSpacing: CGFloat = Self.default.supplementaryViewSpacing {
        didSet {
            reloadSupplementaryViews()
        }
    }
    
    /// Positive numbers are shifted downward, negative numbers are shifted upward, default is 3
    /// 附加视图的垂直偏移量，正数向下偏移，负数向上偏移，默认为 3
    @IBInspectable public lazy var supplementaryVerticallyOffset: CGFloat = Self.default.supplementaryVerticallyOffset {
        didSet {
            reloadSupplementaryViews()
        }
    }
    
    /// Positive numbers are shifted right, negative numbers are shifted, and the default is 3.
    /// 附加视图的横向偏移量，正数向右偏移，负数向左偏移，默认为 3
    @IBInspectable public lazy var supplementaryHorizontallyOffset: CGFloat = Self.default.supplementaryHorizontallyOffset {
        didSet {
            reloadSupplementaryViews()
        }
    }
    
    /// animate duration of segmented change, default is 0.34
    @IBInspectable public lazy var animateDuration: TimeInterval = Self.default.animateDuration
    
    /// default is UIColor.black.withAlphaComponent(0.2)
    @IBInspectable public lazy var shadowShadowColor: UIColor = Self.default.shadowColor {
        didSet {
            shadowView.subviews.first?.layer.shadowColor = shadowShadowColor.cgColor
        }
    }
    
    public var distribution: Distribution = .default {
        didSet {
            self.layoutSubviews()
        }
    }
    
    public var isShadowHidden: Bool = false {
        didSet {
            var shouldContinue = true
            if segments.count > 0, segments[currentIndex].isShouldHideShadow {
                shouldContinue = false
            }
            
            guard shouldContinue else {
                UIView.animate(withDuration: animateDuration) {
                    self.shadowView.alpha = 0
                }
                return
            }
            
            guard isShadowShouldShow,
                  (isShadowHidden && shadowView.alpha != 0.0) ||
                    (!isShadowHidden && shadowView.alpha != 1.0)
            else {
                return
            }
            
            UIView.animate(withDuration: animateDuration) {
                self.shadowView.alpha = self.isShadowHidden ? 0 : 1
            }
        }
    }
    
    public var segmentConfigure: SegmentConfigure = .main {
        didSet {
            reloadSegments()
        }
    }
    
    @IBInspectable public var currentIndex: Int = 0 {
        willSet {
            layer.removeAllAnimations()
            
            previousIndex = currentIndex
        }
        didSet {
            let from = segmentViews.enumerated().first(where: { $0.offset == previousIndex })?.element
            let to = segmentViews.enumerated().first(where: { $0.offset == currentIndex })?.element
            
            let fromIndex = previousIndex
            let toIndex = currentIndex
            
            var centeredRect: CGRect?
            if let to = to {
                let viewRect = to.convert(to.bounds, to: scrollView)
                centeredRect = CGRect(x: viewRect.origin.x + viewRect.width / 2 - bounds.width / 2,
                                      y: viewRect.origin.y + viewRect.height / 2 - bounds.height / 2,
                                      width: bounds.width,
                                      height: bounds.height)
            }
            
            // do animate
            UIView.animate(withDuration: animateDuration, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState]) {
                from?.isSelected = false
                to?.isSelected = true
                
                if !self.isAllOfOne, self.isIndependentControls {
                    // make supplementary view to visiable
                    let fromSupViews = (self.subSupplementaryViewMaps[fromIndex] ?? []) ?? []
                    let toSupViews = (self.subSupplementaryViewMaps[toIndex] ?? []) ?? []
                    
                    let fromContains = fromSupViews.filter({ toSupViews.contains($0) })
                    let fromUnContains = fromSupViews.filter({ !toSupViews.contains($0) })
                    
                    func makeView(view: UIView, show: Bool) {
                        view.transform = show ? .identity : .init(translationX: 10, y: 0)
                        view.alpha = show ? 1 : 0
                    }
                    fromUnContains.forEach({ makeView(view: $0, show: false) })
                    (fromContains + toSupViews).forEach({ makeView(view: $0, show: true) })
                }
                
                self.layoutSubviews()
                
                if let centeredRect = centeredRect {
                    self.scrollView.scrollRectToVisible(centeredRect, animated: false)
                }
            }
        }
    }
    
    public var segments: [Segment] = [] {
        didSet {
            // update segmentViews, and install
            reloadSegments()
        }
    }
    
    public var supplementaryViews: [Segmenter.Segment.SupplementView] = [] {
        didSet {
            // all segments show one supplementary view
            reloadSupplementaryViews()
        }
    }
    
    // MARK:- Private properties
    private let shadowView = UIView()
    private let scrollView = UIScrollView()
    private let scrollContainer = UIView()
    private var previousIndex = -1
    
    private var segmentViews: [UIControl & SegmentViewProvider] = []
    
    private let supplementaryView = ClickThroughView()
    private var subSupplementaryViewMaps: [Int: [UIView]?] = [:]
    // Int: index, UIView: view, CGFloat: offset of vertically
    private var subSupplementarySubviewsVerticallyOffsetMaps: [VerticallyOffsetMapHashable: CGFloat] = [:]
    
    private var isAllOfOne: Bool {
        supplementaryViews.count > 0
    }
    private var isIndependentControls: Bool {
        segments.filter({ $0.supplementaryViews.count > 0 }).count > 0
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    func commonInit() {
        clipsToBounds = false
        backgroundColor = .clear
        
        shadowView.backgroundColor = .clear
        addSubview(shadowView)
        
        backgroundView.backgroundColor = .white
        addSubview(backgroundView)
        
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.addSubview(scrollContainer)
        addSubview(scrollView)
        
        supplementaryView.backgroundColor = .clear
        addSubview(supplementaryView)
    }
    
    func addShadow() {
        guard self.frame != .zero else { return }
        
        let shadowRadius: CGFloat = 4
        let shadowOpacity: Float = 1
        let cornerRadius: CGFloat = 0
        let originShadowFrame = CGRect(x: 0, y: self.frame.height - 4, width: self.frame.width, height: 4)
        self.shadowView.frame = originShadowFrame.insetBy(dx: -shadowRadius * 2, dy: -shadowRadius * 2)
        let frame = self.shadowView.frame
        
        let shadowFrame = CGRect(x: shadowRadius * 2, y: shadowRadius * 2,
                                 width: frame.width - shadowRadius * 4, height: frame.height - shadowRadius * 4)
        var _shadow: UIView
        if let sdv = shadowView.subviews.first {
            sdv.frame = shadowFrame
            _shadow = sdv
        } else {
            _shadow = UIView(frame: shadowFrame)
            _shadow.backgroundColor = .black
            _shadow.layer.cornerRadius = cornerRadius
            _shadow.layer.borderWidth = 1.0
            _shadow.layer.borderColor = UIColor.clear.cgColor
            
            _shadow.layer.shadowOpacity = shadowOpacity
            _shadow.layer.shadowRadius = shadowRadius
            _shadow.layer.shadowOffset = .zero
            _shadow.layer.masksToBounds = false
            self.shadowView.addSubview(_shadow)
        }
        _shadow.layer.shadowColor = shadowShadowColor.cgColor
        
        let mask = (self.shadowView.layer.mask as? CAShapeLayer) ?? CAShapeLayer()
        mask.frame = .init(x: _shadow.frame.minX, y: _shadow.frame.maxY, width: _shadow.frame.width, height: shadowRadius * 2)
        
        guard mask.superlayer == nil else { return }
        
        mask.backgroundColor = UIColor.black.cgColor
        mask.fillRule = CAShapeLayerFillRule.evenOdd
        self.shadowView.layer.mask = mask
        self.shadowView.backgroundColor = .clear
    }
    
    func clearSupplementaryView() {
        subSupplementaryViewMaps.removeAll()
        supplementaryView.subviews.forEach({ $0.removeFromSuperview() })
        subSupplementarySubviewsVerticallyOffsetMaps.removeAll()
    }
    
    func reloadSegments() {
        segmentViews.forEach({ $0.removeFromSuperview() })
        segmentViews = segments.map({ $0.kind.segmentViewType.init($0, configure: segmentConfigure) })
        for (index, segmentView) in segmentViews.enumerated() {
            segmentView.tag = index + 100
            segmentView.isSelected = index == currentIndex
            segmentView.addTarget(self, action: #selector(segmentViewTapAction(_:)), for: .touchUpInside)
            scrollContainer.addSubview(segmentView)
        }
        
        reloadSupplementaryViews()
    }
    
    func reloadSupplementaryViews() {
        guard isAllOfOne || isIndependentControls else { return }
        
        // load sub supplmentaryViews
        func clear() {
            subSupplementaryViewMaps.removeAll()
            subSupplementarySubviewsVerticallyOffsetMaps.removeAll()
            supplementaryView.subviews.forEach({ $0.removeFromSuperview() })
        }
        clear()
        
        if isAllOfOne {
            supplementaryViewAllOfOne()
        } else {
            supplementaryViewIndependentControls()
        }
        
        layoutSubviews()
    }
    
    /// check the segment item size
    func checkSize(view: UIView) {
        // TODO: maybe can optmize for those codes
        if view.frame == .zero {
            view.sizeToFit()
        }
        if view.frame == .zero {
            view.frame.size = view.intrinsicContentSize
        }
        if view.frame == .zero {
            fatalError("the view's frame is zero.")
        }
    }
    
    // 每个 segment 的 supplemnt view 都是同一(多)个
    func supplementaryViewAllOfOne() {
        for viewInfo in supplementaryViews {
            checkSize(view: viewInfo.view)
            supplementaryView.addSubview(viewInfo.view)
        }
    }
    
    // 独立控制
    func supplementaryViewIndependentControls() {
        
        func saveSupplementaryView(from: Segmenter.Segment.SupplementView, index: Int) -> UIView {
            let hashable = VerticallyOffsetMapHashable(index: index, view: from.view)
            subSupplementarySubviewsVerticallyOffsetMaps[hashable] = from.offset
            return from.view
        }
        
        // 独立控制，从每个 segment 的配置中取 supplementaryViews, 并添加到视图中
        for (index, subSupplementaryViews) in segments.enumerated().map({ ($0.offset, $0.element.supplementaryViews) }) {
            guard subSupplementaryViews.count > 0 else {
                subSupplementaryViewMaps[index] = nil
                continue
            }
            
            let subSuplementViews = subSupplementaryViews.map({ $0.view })
            subSupplementaryViewMaps[index] = subSuplementViews
            
            for subviewInfo in subSupplementaryViews {
                let view = saveSupplementaryView(from: subviewInfo, index: index)
                supplementaryView.addSubview(view)
                view.alpha = 0
                
                checkSize(view: subviewInfo.view)
            }
        }
        
        // 全部添加完成后，再根据 currentIndex 进行初始化的显示
        (subSupplementaryViewMaps[currentIndex] ?? [])?.forEach({ $0.alpha = 1 })
    }
    
    // MARK:- segment view's tap action
    @objc private func segmentViewTapAction(_ sender: UIControl) {
        let fromIndex = self.segmentViews.enumerated().first(where: { $0.element.isSelected })?.offset ?? 0
        let segmentViewEnumerated = self.segmentViews.enumerated().first(where: { $0.element == sender })
        let tappedIndex = segmentViewEnumerated?.offset ?? 0
        self.currentIndex = tappedIndex
        
        // send events
        delegate?.segmenter(self, didSelect: currentIndex, withSegment: segments[currentIndex], fromIndex: fromIndex, fromSegment: segments[fromIndex])
    }
    
    private func layoutSubSupplementaryViewsIfNeeded() {
        guard !isAllOfOne, isIndependentControls else { return }
        
        for map in subSupplementaryViewMaps where map.key == currentIndex {
            guard let views = map.value else { continue }
            for (idx, supplementSubview) in views.enumerated() {
                let isAnimate = supplementSubview.frame.origin != .zero
                let hashable = VerticallyOffsetMapHashable(index: map.key, view: supplementSubview)
                let verticallyOffset = subSupplementarySubviewsVerticallyOffsetMaps[hashable] ?? 0
                
                func setPosition(idx: Int) {
                    if idx == 0 {
                        // right, bottom
                        supplementSubview.frame.origin = .init(x: supplementaryView.frame.width - supplementSubview.frame.width + supplementaryHorizontallyOffset,
                                                               y: supplementaryView.frame.height - supplementSubview.frame.height + supplementaryVerticallyOffset + verticallyOffset)
                    } else {
                        // right, bottom of previous
                        let previousView = views[idx - 1]
                        supplementSubview.frame.origin = .init(x: previousView.frame.minX - supplementaryViewSpacing - supplementSubview.frame.width,
                                                               y: supplementaryView.frame.height - supplementSubview.frame.height + supplementaryVerticallyOffset + verticallyOffset)
                    }
                }
                
                if isAnimate {
                    setPosition(idx: idx)
                    continue
                }
                UIView.performWithoutAnimation {
                    setPosition(idx: idx)
                }
            }
        }
    }
    
    private func layoutSupplementaryViewsIfNeeded() {
        guard isAllOfOne else { return }
        
        for (index, map) in supplementaryViews.enumerated() {
            if index == 0 {
                map.view.frame.origin = .init(x: supplementaryView.frame.width - map.view.frame.width,
                                              y: supplementaryView.frame.height - map.view.frame.height + supplementaryVerticallyOffset + map.offset)
            } else {
                let previousView = supplementaryViews[index - 1].view
                map.view.frame.origin = .init(x: previousView.frame.minX - supplementaryViewSpacing - map.view.frame.width,
                                              y: supplementaryView.frame.height - map.view.frame.height + supplementaryVerticallyOffset + map.offset)
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        defer {
            supplementaryView.frame = .init(x: scrollView.center.x,
                                            y: scrollView.frame.minY + contentInset.top,
                                            width: (scrollView.frame.width / 2) - contentInset.right,
                                            height: scrollView.frame.height - contentInset.vertical)
            
            layoutSupplementaryViewsIfNeeded()
            layoutSubSupplementaryViewsIfNeeded()
        }
        
        backgroundView.frame = self.bounds
        
        shadowView.frame = .init(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1)
        addShadow()
        let scrollHeight = min(self.frame.height, 44)
        scrollView.frame = .init(x: 0, y: self.frame.height - scrollHeight, width: self.frame.width, height: scrollHeight)
        
        var scrollFrame = scrollView.frame
        var allItemWidth: CGFloat = 0
        segmentViews.forEach({ $0.sizeToFit(); allItemWidth += $0.frame.width })
        let allSpacingPx: CGFloat = CGFloat(segmentViews.count - 1) * segmentSpacing
        
        // caclculate segment view's layout for `.default` and `.centered`
        func segmentViewLayout() {
            for (index, segmentView) in segmentViews.enumerated() {
                if index == 0 {
                    segmentView.frame.origin = .init(x: 0, y: scrollContainer.frame.height - segmentView.frame.height)
                } else {
                    let previousView = segmentViews[index - 1]
                    segmentView.frame.origin = .init(x: previousView.frame.maxX + segmentSpacing, y: scrollContainer.frame.height - segmentView.frame.height)
                }
            }
        }
        
        switch distribution {
        case .default:
            scrollFrame.origin.y = contentInset.top
            scrollFrame.origin.x = contentInset.left
            scrollFrame.size.height -= contentInset.vertical
            // width
            scrollFrame.size.width = allItemWidth + allSpacingPx
            scrollContainer.frame = scrollFrame
            scrollView.contentSize = .init(width: scrollFrame.maxX + contentInset.right, height: scrollFrame.height)
            segmentViewLayout()
            
        case .centered:
            // calculator segment view's height first
            var w: CGFloat = 0
            segmentViews.forEach({ $0.sizeToFit(); w += $0.frame.width })
            w += (CGFloat(segmentViews.count - 1) * segmentSpacing)
            
            let centerX = (scrollView.frame.width - w) / 2
            scrollFrame.origin.x = max(0, centerX)
            scrollFrame.origin.y = contentInset.top
            scrollFrame.size.height -= contentInset.vertical
            scrollFrame.size.width = scrollFrame.origin.x == 0 ? w + centerX : w
            scrollContainer.frame = scrollFrame
            scrollView.contentSize = .init(width: w, height: scrollFrame.height)
            segmentViewLayout()
            
        case .evened:
            scrollFrame.origin.x = contentInset.left
            scrollFrame.origin.y = contentInset.top
            scrollFrame.size.height -= contentInset.vertical
            scrollFrame.size.width -= contentInset.horizontal
            scrollContainer.frame = scrollFrame
            
            // all segmentViews are of equal spacing
            var allItemWidth: CGFloat = 0
            segmentViews.forEach({ $0.sizeToFit(); allItemWidth += $0.frame.width })
            let spacing: CGFloat = (scrollFrame.width - allItemWidth) / CGFloat(segmentViews.count - 1)
            for (index, segmentView) in segmentViews.enumerated() {
                if index == 0 { // first
                    segmentView.frame.origin = .init(x: 0, y: scrollContainer.frame.height - segmentView.frame.height)
                } else {
                    // center
                    let previousSegmentView = segmentViews[index - 1]
                    let diff = (previousSegmentView.activeSize.width - previousSegmentView.inactiveSize.width) / 2
                    segmentView.frame.origin = .init(x: previousSegmentView.frame.maxX + spacing - diff,
                                                     y: scrollContainer.frame.height - segmentView.frame.height)
                }
            }
        case .aroundEvened:
            scrollFrame.origin.x = contentInset.left
            scrollFrame.origin.y = contentInset.top
            scrollFrame.size.height -= contentInset.vertical
            scrollFrame.size.width -= contentInset.horizontal
            scrollContainer.frame = scrollFrame
            
            // all segmentViews are of equal spacing
            let count = segmentViews.count + 1
            var allItemWidth: CGFloat = 0
            segmentViews.forEach({ $0.sizeToFit(); allItemWidth += $0.frame.width })
            let spacing: CGFloat = (scrollFrame.width - allItemWidth) / CGFloat(count)
            for (index, segmentView) in segmentViews.enumerated() {
                if index == 0 { // first
                    segmentView.frame.origin = .init(x: spacing, y: scrollContainer.frame.height - segmentView.frame.height)
                } else {
                    // center
                    let previousSegmentView = segmentViews[index - 1]
                    let diff = (previousSegmentView.activeSize.width - previousSegmentView.inactiveSize.width) / 2
                    segmentView.frame.origin = .init(x: previousSegmentView.frame.maxX + spacing - diff,
                                                     y: scrollContainer.frame.height - segmentView.frame.height)
                }
            }
            break
        }
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let containerPoint = convert(point, to: scrollContainer)
        for subview in scrollContainer.subviews {
            if subview.frame.inset(by: .init(top: -10, left: -10, bottom: -10, right: -10)).contains(containerPoint) {
                return subview
            }
        }
        return super.hitTest(point, with: event)
    }
}
