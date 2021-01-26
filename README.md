# Segmenter

![Preview](Demo/shot.gif)


## Demo

Download the project and then open `Demo/Segmenter.xcodeproj`


## Features

· 背景透明时也支持阴影效果

· SupplementaryView 支持独立控制，且同一个 view 只需初始化一次即可出现在任意 Segment 中

· 背景视图使用 backgroundView 设置，已为其添加 gradientLayer 属性，支持渐变色

· Segment 支持自定义 View

· segments 长度超出范围时可滚动显示，对 SupplementaryView 做了优化/适配

· 支持全局配置默认属性，可被实例自定义配置覆盖
```swift
/// `提供  `default`  静态属性，可配置的属性，配置后全局生效，单个实例重写对应的属性时，会覆盖全局配置`
///
///  Segmenter.default.xxxx


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
}
public static var `default` = Appearance()
```


## Installation

#### Swift Package Manager
`.package(url: https://github.com/iWECon/Segmenter", from: "1.0.0")`
