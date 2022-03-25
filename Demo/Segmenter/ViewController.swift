//
//  ViewController.swift
//  Segmenter
//
//  Created by iWw on 2021/1/4.
//

import UIKit

class ViewController: UIViewController {
    
    let segmenter = Segmenter()
    let minorSegmenter = Segmenter()
    let minorCenteredSegmenter = Segmenter()
    let aroundEvenedSegmenter = Segmenter()
    
    let button = UIButton()
    
    private func makeMainSegment(title: String) -> Segment {
        Segment(title: title)
    }
    private func makeMinorSegment(title: String) -> Segment {
        Segment(
            title: title,
            activeFont: UIFont.systemFont(ofSize: 12, weight: .medium),
            inactiveFont: UIFont.systemFont(ofSize: 12, weight: .regular)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        func makeButton(_ title: String, verticallyOffset: CGFloat = 0) -> Segment.SupplementView {
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
            btn.setTitleColor(.systemBlue, for: .normal)
            return .view(btn, verticallyOffset)
        }
        
        let v = UIView()
        v.backgroundColor = .red
        let r = UIView()
        r.backgroundColor = .blue
        segmenter.isShadowShouldShow = false
        segmenter.segments = [
            .init(view: v, inactiveView: r, activeSize: CGSize(width: 44, height: 24), inactiveSize: CGSize(width: 34, height: 18.57), supplementaryViews: [makeButton("按钮1"), makeButton("按钮2"), makeButton("按钮3")]),
            .init(image: UIImage(named: "chuanghua")!, inactiveImage: UIImage(named: "chuanghua-2")!, activeSize: CGSize(width: 32, height: 32), inactiveSize: CGSize(width: 24, height: 24), supplementaryViews: [makeButton("按 钮 4"), makeButton("按钮5"), makeButton("按 钮 6")]),
            .init(title: "歌手 Anchor"),
            .init(title: "歌曲 Songs", supplementaryViews: [makeButton("听妈妈的话")]),
            .init(title: "歌词 LRC", supplementaryViews: [makeButton("你突然释怀的笑"), makeButton("笑声盘旋半山腰")]),
            .init(title: "简介 Brief", supplementaryViews: [makeButton("周 杰 伦 简 介")]),
        ]
        segmenter.backgroundColor = .white
        segmenter.supplementaryVerticallyOffset = 5
        segmenter.distribution = .default
        segmenter.delegate = self
        view.addSubview(segmenter)
        
        minorSegmenter.isShadowShouldShow = false
        minorSegmenter.distribution = .evened
        minorSegmenter.segments = [
            makeMinorSegment(title: "周杰伦,周杰伦,周杰伦"),
            makeMinorSegment(title: "林俊杰,周杰伦"),
            makeMinorSegment(title: "胡彦斌,周杰伦")
        ]
        view.addSubview(minorSegmenter)
        
        minorCenteredSegmenter.backgroundView.backgroundColor = .clear
        minorCenteredSegmenter.distribution = .centered
        minorCenteredSegmenter.segments = [
            makeMainSegment(title: "过去 Event"),
            makeMainSegment(title: "现在 Now"),
            makeMainSegment(title: "未来 Future"),
        ]
        view.addSubview(minorCenteredSegmenter)
        
        aroundEvenedSegmenter.distribution = .aroundEvened
        aroundEvenedSegmenter.segments = [
            makeMinorSegment(title: "周杰伦"),
            makeMinorSegment(title: "林俊杰"),
            makeMinorSegment(title: "胡彦斌")
        ]
        view.addSubview(aroundEvenedSegmenter)
        
        // change status
        view.addSubview(button)
        button.setTitle("修改风格", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTap(_:)), for: .touchUpInside)
        
    }
    
    @objc func printButton(_ sender: UIButton) {
        print("print button clicked.")
    }
    
    var current = 0
    @objc func buttonTap(_ sender: UIButton) {
        let styles: [Segmenter.Distribution] = [.default, .centered, .evened]
        current += 1
        if current > styles.count - 1 {
            current = 0
        }
        UIView.animate(withDuration: segmenter.animateDuration) {
            self.segmenter.distribution = styles[self.current]
            self.minorSegmenter.distribution = styles[self.current]
            self.minorCenteredSegmenter.distribution = styles[self.current]
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 13.0, *) {
            if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first,
               let statusBarHeight = keyWindow.windowScene?.statusBarManager?.statusBarFrame.height
            {
                segmenter.frame.size = .init(width: UIScreen.main.bounds.size.width, height: statusBarHeight + 44)
            }
        } else {
            segmenter.frame.size = .init(width: UIScreen.main.bounds.size.width, height: UIApplication.shared.statusBarFrame.height + 44)
        }
        minorSegmenter.frame = .init(x: 0, y: segmenter.frame.size.height, width: segmenter.frame.width, height: Segmenter.Height)
        minorCenteredSegmenter.frame = .init(x: 100, y: minorSegmenter.frame.maxY, width: segmenter.frame.width - 200, height: Segmenter.Height)
        aroundEvenedSegmenter.frame = .init(x: 0, y: minorCenteredSegmenter.frame.maxY, width: segmenter.frame.width, height: Segmenter.Height)
        
        button.frame = .init(x: (self.view.frame.width - 80) / 2, y: 400, width: 80, height: 40)
    }
}



extension ViewController: SegmenterSelectedDelegate {
    
    func segmenter(_ segmenter: Segmenter, didSelect index: Int, withSegment segment: Segment, fromIndex: Int, fromSegment: Segment) {
        
        // do something
    }
}
