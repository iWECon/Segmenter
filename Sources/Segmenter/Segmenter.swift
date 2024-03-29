import UIKit

public final class Segmenter: UIControl {
    
    /// The style here is the overall default style, and the configuration information is taken from here if the Segmenter is not configured as follows after initialization
    /// Even if the default style is configured, it can be configured independently in the Segmenter instance
    public struct Appearance {
        public var segmentSpacing: CGFloat = 15
        public var contentInset = UIEdgeInsets(top: 10, left: 15, bottom: 6, right: 15)
        public var animateDuration: TimeInterval = 0.34
        public var shadowColor: UIColor = UIColor.black.withAlphaComponent(0.2)
        
        /// the gradient color of supplementViewContainer
        /// supplementaryContainerView 的渐变色
        public var supplementarViewColors: [UIColor] = [UIColor.white, UIColor.white.withAlphaComponent(0)]
        
        /// spacing of segment and supplementary between
        /// segment 和 supplementaryView 之间的距离(最小距离)
        public var spacingOfSegmentAndSupplementary: CGFloat = 20
        
        /// Spacing between SupplementaryViews
        public var supplementaryViewSpacing: CGFloat = 10
        /// SupplementaryViews are shifted vertically as a whole, positive numbers down, negative numbers up
        public var supplementaryVerticallyOffset: CGFloat = 0
        /// SupplementaryViews are shifted horizontally as a whole, with positive numbers to the right and negative numbers to the left
        public var supplementaryHorizontallyOffset: CGFloat = 0
        
        /// SupplementaryViews transition animation
        public var supplementaryTransitionAnimation: SupplementaryViewsTransitionProvider = DefaultSupplementaryViewsTransition()
        /// This effect is triggered when moving to new Segment without any supplementary views.
        public var supplementaryViewTransition: Segmenter.SupplementaryViewTransition = .default
        
        public init() { }
    }
    
    public static var `default` = Appearance()
    
    public static let Height: CGFloat = 44
    public static let SupplementaryButtonHeight: CGFloat = 24
    
    // MARK: - Custom properties
    public weak var delegate: SegmenterSelectedDelegate?
    
    /// SupplementaryViews transition animation delegate
    public var supplementaryTransitionAnimation: SupplementaryViewsTransitionProvider = Segmenter.default.supplementaryTransitionAnimation
    
    public enum SupplementaryViewTransition {
        /// Default is move to new frame
        case `default`
        /// Fade right now (without move to new frame)
        case fade
    }
    /// This effect is triggered when moving to new Segment without any supplementary views.
    public var supplementaryViewTransition: SupplementaryViewTransition = Segmenter.default.supplementaryViewTransition
    
    @IBInspectable public var isShadowShouldShow = true {
        didSet {
            shadowView.alpha = isShadowShouldShow ? 1 : 0
        }
    }
    
    /// use `backgroundView.background` or `backgroundView.set(colors:startPoint:endPoint:locations:)` to set backgroundColor
    public let backgroundView = SegmenterGradientView()
    
    /// override to set backgroundView.backgroundColor
    public override var backgroundColor: UIColor? {
        get { backgroundView.backgroundColor }
        set {
            backgroundView.backgroundColor = newValue
            if let color = newValue {
                supplementaryViewColors = [color, color.withAlphaComponent(0)]
            } else {
                supplementaryViewColors = [UIColor.white.withAlphaComponent(0), UIColor.white.withAlphaComponent(0)]
            }
        }
    }
    
    /// Indicator, indicating the currently active segment
    public var indicator: Indicator?
    
    /// some property(left/right) won’t be join calculate when use `.cetered` or `.evened`
    /// default is .init(top: 0, left: 15, bottom: 6, right: 15)
    ///
    /// 当 `distribution` 为 `.centered` or `.evened` 时，其 `left` 和 `right` 在计算位置时会被忽略
    @IBInspectable public lazy var contentInset: UIEdgeInsets = Self.default.contentInset
    
    /// won't be join calculate when use `.evened` or `.aroundEvened`, default is 15
    ///
    /// segment 间距，当 `distribution` 为 `.evened` 或 `.aroundEvened` 在计算位置时会被忽略, 默认值为 15
    @IBInspectable public lazy var segmentSpacing: CGFloat = Self.default.segmentSpacing
    
    /// default is 10
    ///
    /// 附加视图之间的间距
    @IBInspectable public lazy var supplementaryViewSpacing: CGFloat = Self.default.supplementaryViewSpacing {
        didSet {
            reloadSupplementaryViews()
        }
    }
    
    /// Positive numbers are shifted downward, negative numbers are shifted upward, default is 0.
    ///
    /// 附加视图的垂直偏移量，正数向下偏移，负数向上偏移，默认为 0
    @IBInspectable public lazy var supplementaryVerticallyOffset: CGFloat = Self.default.supplementaryVerticallyOffset {
        didSet {
            reloadSupplementaryViews()
        }
    }
    
    /// Positive numbers are shifted right, negative numbers are shifted, and the default is 0.
    ///
    /// 附加视图的横向偏移量，正数向右偏移，负数向左偏移，默认为 0
    @IBInspectable public lazy var supplementaryHorizontallyOffset: CGFloat = Self.default.supplementaryHorizontallyOffset {
        didSet {
            reloadSupplementaryViews()
        }
    }
    
    /// segment 与附加视图之间的距离
    @IBInspectable public lazy var spacingOfSegmentAndSupplementary: CGFloat = Self.default.spacingOfSegmentAndSupplementary
    
    /// animate duration of segmented change, default is 0.34
    ///
    /// 动画持续事件，默认为 0.34
    @IBInspectable public lazy var animateDuration: TimeInterval = Self.default.animateDuration
    
    /// default is UIColor.black.withAlphaComponent(0.2)
    ///
    /// 阴影颜色，默认为 UIColor.black.withAlphaComponent(0.2)
    @IBInspectable public lazy var shadowShadowColor: UIColor = Self.default.shadowColor {
        didSet {
            shadowView.subviews.first?.layer.shadowColor = shadowShadowColor.cgColor
        }
    }
    
    public var distribution: Distribution = .default {
        didSet {
            if distribution == .default {
                supplementaryView.restoreGradientColor()
            } else {
                supplementaryView.clearGradientColor()
            }
            layoutSubviews()
        }
    }
    
    public var isShadowHidden: Bool = false {
        didSet {
            var shouldContinue = true
            if segments.count > 0, currentIndex <= segments.count - 1, segments[currentIndex].isShouldHideShadow {
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
            
            // do animate
            UIView.animate(withDuration: animateDuration, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseOut]) {
                from?.isSelected = false
                to?.isSelected = true
                
                let shouldTransitionSupplementaryViews: Bool = !self.isAllOfOne && self.isIndependentControls
                
                if shouldTransitionSupplementaryViews {
                    // make supplementary view to visiable
                    let fromSupViews = (self.subSupplementaryViewMaps[fromIndex] ?? []) ?? []
                    let toSupViews = (self.subSupplementaryViewMaps[toIndex] ?? []) ?? []
                    
                    let fromContains = fromSupViews.filter({ toSupViews.contains($0) })
                    let fromUnContains = fromSupViews.filter({ !toSupViews.contains($0) })
                    
                    self.supplementaryTransitionAnimation
                        .transition(
                            invisibleViews: fromUnContains,
                            visibleViews: (fromContains + toSupViews)
                        )
                }
                
                self.layoutSubviews()
                
                if let from, let to, let indicator = self.indicator {
                    indicator.change(from: from, to: to)
                }
                
                var centeredRect: CGRect?
                if let to = to {
                    let viewRect = to.convert(CGRect(x: 0, y: 0, width: to.activeSize.width, height: to.activeSize.height), to: self.scrollView)
                    let isDefault = self.distribution == .default
                    let rightMargin = isDefault ? self.spacingOfSegmentAndSupplementary + self.segmentSpacing + self.currentSupplementaryViewsWidthWithSpacing * 0.3 : 0
                    centeredRect = CGRect(x: viewRect.origin.x + viewRect.width / 2 - self.bounds.width / 2 + rightMargin,
                                          y: viewRect.origin.y + viewRect.height / 2 - self.bounds.height / 2,
                                          width: self.scrollView.frame.width,
                                          height: self.scrollView.frame.height)
                }
                if self.currentIndex != self.previousIndex, let centeredRect = centeredRect {
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
    
    public var supplementaryViews: [Segment.SupplementView] = [] {
        didSet {
            // all segments show one supplementary view
            reloadSupplementaryViews()
        }
    }
    /// Valid when `distribution == .default`
    /// supplementaryContainerView's gradient colors
    /// 附加视图的渐变背景色，颜色从右到左显示，设置颜色从左到右按顺序即可
    /// 仅当 distribution 为 .default 时生效
    public lazy var supplementaryViewColors: [UIColor] = Self.default.supplementarViewColors {
        didSet {
            guard distribution == .default else {
                supplementaryView.clearGradientColor()
                return
            }
            supplementaryView.setColors(supplementaryViewColors)
        }
    }
    
    /// 获取 segment
    public func getSegment(at index: Int) -> SegmentView {
        segmentViews[index]
    }
    
    /// 替换 segment
    /// 会自动调用 `reloadSegments()`
    public func replaceSegment(_ segment: Segment, at index: Int) {
        // it will calling didSet, so do not manual to call `reloadSegments()`
        segments.replaceSubrange(.init(index ... index), with: [segment])
    }
    
    /// 删除 segment
    /// 会自动调用 `reloadSegments()`
    public func deleteSegment(at index: Int) {
        // it will calling didSet, so do not manual to call `reloadSegments()`
        segments.remove(at: index)
    }
    
    /// 添加 segment
    /// 会自动调用 `reloadSegments()`
    public func insertSegment(_ segment: Segment, at index: Int) {
        segments.insert(segment, at: index)
    }
    
    // MARK: - Private properties
    private let shadowView = UIView()
    private let scrollView = UIScrollView()
    private let scrollContainer = UIView()
    private var previousIndex = -1
    
    private var segmentViews: [SegmentView] = []
    /// container of supplementaryView
    private let supplementaryView = SupplementaryContainerView()
    
    private var subSupplementaryViewMaps: [Int: [UIView]?] = [:]
    // Int: index, UIView: view, CGFloat: offset of vertically
    private var subSupplementarySubviewsVerticallyOffsetMaps: [VerticallyOffsetMapHashable: CGFloat] = [:]
    
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
        supplementaryView.setColors(supplementaryViewColors)
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
        mask.frame = CGRect(x: _shadow.frame.minX, y: _shadow.frame.maxY, width: _shadow.frame.width, height: shadowRadius * 2)
        
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
    
    public func reloadSegments() {
        segmentViews.forEach({ $0.removeFromSuperview() })
        segmentViews = segments.map({ $0.info.viewType.init($0, info: $0.info) })
        for (index, segmentView) in segmentViews.enumerated() {
            segmentView.tag = index + 100
            segmentView.isSelected = index == currentIndex
            segmentView.addTarget(self, action: #selector(segmentViewTapAction(_:)), for: .touchUpInside)
            scrollContainer.addSubview(segmentView)
        }
        
        reloadSupplementaryViews()
        
        reloadIndicator()
    }
    
    public func reloadSupplementaryViews() {
        // hidden supplementaryView when it is empty
        if !isAllOfOne, !isIndependentControls {
            supplementaryView.isHidden = true
            return
        }
        supplementaryView.isHidden = false
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
    
    func installIndicatorIfNeeded() {
        guard !segmentViews.isEmpty, let indicator else { return }
        
        let indexRange = 0 ..< segmentViews.count
        guard indexRange.contains(currentIndex) else { return }
        
        if let spv = indicator.superview {
            // refresh y
            indicator.frame.origin.y = spv.frame.height + indicator.spacing
            return
        }
        
        let selectedSegmentView = segmentViews[currentIndex]
        self.scrollContainer.addSubview(indicator)
        indicator.install(withSementView: selectedSegmentView)
        // set origin.y
        indicator.frame.origin.y = selectedSegmentView.inactiveSize.height + indicator.spacing
    }
    
    public func reloadIndicator() {
        indicator?.removeFromSuperview()
        installIndicatorIfNeeded()
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
        
        func saveSupplementaryView(from: Segment.SupplementView, index: Int) -> UIView {
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
    
    // MARK: - segment view's tap action
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
                        supplementSubview.frame.origin = CGPoint(
                            x: supplementaryView.frame.width - supplementSubview.frame.width + supplementaryHorizontallyOffset - contentInset.right,
                            y: supplementaryView.frame.height - supplementSubview.frame.height + supplementaryVerticallyOffset + verticallyOffset
                        )
                    } else {
                        // right, bottom of previous
                        let previousView = views[idx - 1]
                        supplementSubview.frame.origin = CGPoint(
                            x: previousView.frame.minX - supplementaryViewSpacing - supplementSubview.frame.width,
                            y: supplementaryView.frame.height - supplementSubview.frame.height + supplementaryVerticallyOffset + verticallyOffset
                        )
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
                map.view.frame.origin = CGPoint(
                    x: supplementaryView.frame.width - map.view.frame.width + supplementaryHorizontallyOffset - contentInset.right,
                    y: supplementaryView.frame.height - map.view.frame.height + supplementaryVerticallyOffset + map.offset
                )
            } else {
                let previousView = supplementaryViews[index - 1].view
                map.view.frame.origin = CGPoint(
                    x: previousView.frame.minX - supplementaryViewSpacing - map.view.frame.width,
                    y: supplementaryView.frame.height - map.view.frame.height + supplementaryVerticallyOffset + map.offset
                )
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard self.frame.height > 0 else { return }
        
        defer {
            if distribution != .default {
                supplementaryView.frame = CGRect(
                    x: scrollView.center.x,
                    y: scrollView.frame.minY + contentInset.top,
                    width: (scrollView.frame.width / 2),
                    height: scrollView.frame.height - contentInset.vertical
                )
            }
            
            layoutSupplementaryViewsIfNeeded()
            layoutSubSupplementaryViewsIfNeeded()
        }
        
        backgroundView.frame = self.bounds
        
        shadowView.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1)
        addShadow()
        let scrollHeight = min(self.frame.height, 44)
        scrollView.frame = CGRect(x: 0, y: self.frame.height - scrollHeight, width: self.frame.width, height: scrollHeight)
        
        var scrollFrame = scrollView.frame
        
        // caclculate segment view's layout for `.default` and `.centered`
        func segmentViewLayout() {
            for (index, segmentView) in segmentViews.enumerated() {
                if index == 0 {
                    segmentView.frame.origin = CGPoint(x: 0, y: scrollContainer.frame.height - segmentView.frame.height)
                } else {
                    let previousView = segmentViews[index - 1]
                    segmentView.frame.origin = CGPoint(x: previousView.frame.maxX + segmentSpacing, y: scrollContainer.frame.height - segmentView.frame.height)
                }
            }
        }
        
        func supplementaryViewLayout(scrollFrame: CGRect) {
            let scrollViewContentWidth = scrollFrame.maxX + contentInset.right
            func empty() {
                switch supplementaryViewTransition {
                case .`default`:
                    supplementaryView.frame = CGRect(
                        x: frame.width,
                        y: scrollView.frame.minY + contentInset.top,
                        width: 0,
                        height: scrollContainer.frame.height
                    )
                case .fade:
                    UIView.performWithoutAnimation {
                        self.supplementaryView.frame = CGRect(
                            x: frame.width,
                            y: self.scrollView.frame.minY + self.contentInset.top,
                            width: 0,
                            height: self.scrollContainer.frame.height
                        )
                    }
                    supplementaryView.alpha = 0
                }
                scrollView.contentSize = CGSize(width: scrollViewContentWidth, height: scrollFrame.height)
                scrollContainer.frame = scrollFrame
            }
            
            func calculatorSupplementaryViewSize(_ views: [UIView]) {
                let offsetWidth: CGFloat = 20
                switch supplementaryViewTransition {
                case .`default`:
                    supplementaryView.frame = CGRect(
                        x: frame.width - currentSupplementaryViewsWidthWithSpacing - offsetWidth,
                        y: scrollView.frame.minY + contentInset.top,
                        // 20 偏移量，多出来 20，用来给 scrollView 出现做淡出的
                        // 偏移的 20 部分的点击时间会传递到 segmentContainerView 中，已在 hitTest 中处理
                        width: currentSupplementaryViewsWidthWithSpacing + offsetWidth,
                        height: scrollFrame.height
                    )
                case .fade:
                    UIView.performWithoutAnimation {
                        self.supplementaryView.frame = CGRect(
                            x: frame.width - self.currentSupplementaryViewsWidthWithSpacing - offsetWidth,
                            y: self.scrollView.frame.minY + self.contentInset.top,
                            // 20 偏移量，多出来 20，用来给 scrollView 出现做淡出的
                            // 偏移的 20 部分的点击时间会传递到 segmentContainerView 中，已在 hitTest 中处理
                            width: self.currentSupplementaryViewsWidthWithSpacing + offsetWidth,
                            height: scrollFrame.height
                        )
                    }
                    supplementaryView.alpha = 1
                }
                scrollContainer.frame = CGRect(
                    x: scrollFrame.origin.x,
                    y: scrollFrame.minY,
                    width: scrollFrame.width + currentSupplementaryViewsWidthWithSpacing + spacingOfSegmentAndSupplementary,
                    height: scrollFrame.height
                )
                scrollView.contentSize = CGSize(width: scrollContainer.frame.maxX, height: scrollFrame.height)
            }
            
            guard !self.isAllOfOne, self.isIndependentControls else {
                // all of one
                if supplementaryViews.count > 0 {
                    calculatorSupplementaryViewSize(supplementaryViews.map({ $0.view }))
                } else {
                    empty()
                }
                return
            }
            // single control
            guard let map = subSupplementaryViewMaps[currentIndex],
                  let views = map,
                  views.count > 0
            else {
                // single is empty
                empty()
                return
            }
            calculatorSupplementaryViewSize(views)
        }
        
        switch distribution {
        case .`default`:
            scrollFrame.origin = CGPoint(x: contentInset.left, y: contentInset.top)
            scrollFrame.size.height -= contentInset.vertical
            scrollFrame.size.width = allSegmentsWidthWithSegmentSpacing
            supplementaryViewLayout(scrollFrame: scrollFrame)
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
            scrollFrame.size.width = scrollFrame.origin.x == 0 ? w + abs(centerX) : w
            scrollContainer.frame = scrollFrame
            scrollView.contentSize = CGSize(width: w, height: scrollFrame.height)
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
                    segmentView.frame.origin = CGPoint(x: 0, y: scrollContainer.frame.height - segmentView.frame.height)
                } else {
                    // center
                    let previousSegmentView = segmentViews[index - 1]
                    let diff = (previousSegmentView.activeSize.width - previousSegmentView.inactiveSize.width) / 2
                    segmentView.frame.origin = CGPoint(x: previousSegmentView.frame.maxX + spacing - diff,
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
                    segmentView.frame.origin = CGPoint(x: spacing, y: scrollContainer.frame.height - segmentView.frame.height)
                } else {
                    // center
                    let previousSegmentView = segmentViews[index - 1]
                    let diff = (previousSegmentView.activeSize.width - previousSegmentView.inactiveSize.width) / 2
                    segmentView.frame.origin = CGPoint(x: previousSegmentView.frame.maxX + spacing - diff,
                                                       y: scrollContainer.frame.height - segmentView.frame.height)
                }
            }
            break
        }
        
        installIndicatorIfNeeded()
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var responderView = super.hitTest(point, with: event)
        
        if distribution == .default {
            let f = supplementaryView.frame
            // supplementaryContainer 加了 20 的宽度偏移量, 用来给超出的 segment 做淡出/入效果, 不需要响应事件
            // bugfix: 20 + spacing, remove spacing
            let supplementaryContainerInvalidFrame = CGRect(x: f.minX, y: f.minY, width: 20, height: f.height)
            let inSupplementaryContainerInvalidFrame = supplementaryContainerInvalidFrame.contains(point)
            
            if inSupplementaryContainerInvalidFrame {
                responderView = scrollContainer.hitTest(convert(point, to: scrollContainer), with: event)
            } else {
                let inSupplementaryView = supplementaryView.frame.contains(point)
                if inSupplementaryView {
                    // in supplementaryContainerView
                    return supplementaryView.hitTest(convert(point, to: supplementaryView), with: event)
                }
                responderView = scrollContainer.hitTest(convert(point, to: scrollContainer), with: event)
            }
        }
        
        return responderView
    }
}

// MARK: - Helper
private extension Segmenter {
    
    /// 是否设置的主视图的附加视图（所有的分页附加视图都相同）
    var isAllOfOne: Bool {
        !supplementaryViews.isEmpty
    }
    /// 是否设置的单独的附加视图（每个分页的附加视图不同）
    var isIndependentControls: Bool {
        !segments.filter({ !$0.supplementaryViews.isEmpty }).isEmpty
    }
    
    /// all segments width without segmentSpacing
    var allSegmentsWidth: CGFloat {
        var w: CGFloat = 0
        segmentViews.forEach({ $0.sizeToFit(); w += $0.frame.width })
        return w
    }
    
    /// all segments width with segmentSpacing
    var allSegmentsWidthWithSegmentSpacing: CGFloat {
        var w: CGFloat = 0
        segmentViews.forEach({ $0.sizeToFit(); w += $0.frame.width })
        let allSpacing = CGFloat((segmentViews.count - 1)) * segmentSpacing
        return w + allSpacing
    }
    
    /// current supplementaryViews width with spacing and contentInset.right
    var currentSupplementaryViewsWidthWithSpacing: CGFloat {
        var w: CGFloat = contentInset.right
        if self.isAllOfOne {
            supplementaryViews.map({ $0.view }).forEach({  w += ($0.frame.width + self.supplementaryViewSpacing) })
            w -= supplementaryViewSpacing
        } else {
            let views = (subSupplementaryViewMaps[currentIndex] ?? []) ?? []
            views.forEach({ w += $0.frame.width + self.supplementaryViewSpacing })
            w -= supplementaryViewSpacing
        }
        return w
    }
    
}
