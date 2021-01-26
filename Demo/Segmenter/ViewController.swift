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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        func makeButton(_ title: String, verticallyOffset: CGFloat = 0) -> Segmenter.Segment.SupplementView {
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
            .init(title: "歌曲 Songs", supplementaryViews: [makeButton("黑色毛衣"), makeButton("大笨钟"), makeButton("听妈妈的话")]),
            .init(title: "歌词 LRC", supplementaryViews: [makeButton("你突然释怀的笑"), makeButton("笑声盘旋半山腰")]),
            .init(title: "简介 Brief", supplementaryViews: [makeButton("周 杰 伦 简 介")]),
        ]
        segmenter.supplementaryVerticallyOffset = 5
        segmenter.distribution = .default
        segmenter.delegate = self
        view.addSubview(segmenter)
        
        minorSegmenter.isShadowShouldShow = false
        minorSegmenter.distribution = .default
        minorSegmenter.segmentConfigure = .minor
        minorSegmenter.supplementaryViews = [makeButton("你好"), makeButton("来了老弟")]
        minorSegmenter.segments = [
            .init(title: "周杰伦,周杰伦,周杰伦"),
            .init(title: "林俊杰,周杰伦"),
            .init(title: "胡彦斌,周杰伦"),
        ]
        view.addSubview(minorSegmenter)
        
        minorCenteredSegmenter.backgroundView.backgroundColor = .clear
        minorCenteredSegmenter.distribution = .centered
        minorCenteredSegmenter.segmentConfigure = .main
        minorCenteredSegmenter.segments = [
            .init(title: "过去 Event"),
            .init(title: "现在 Now"),
            .init(title: "未来 Future"),
        ]
        view.addSubview(minorCenteredSegmenter)
        
        aroundEvenedSegmenter.distribution = .aroundEvened
        aroundEvenedSegmenter.segmentConfigure = .minor
        aroundEvenedSegmenter.segments = [
            .init(title: "周杰伦"),
            .init(title: "林俊杰"),
            .init(title: "胡彦斌")
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
        
        segmenter.frame.size = .init(width: UIScreen.main.bounds.size.width, height: UIApplication.shared.statusBarFrame.height + 44)
        minorSegmenter.frame = .init(x: 0, y: segmenter.frame.size.height, width: segmenter.frame.width, height: Segmenter.Height)
        minorCenteredSegmenter.frame = .init(x: 100, y: minorSegmenter.frame.maxY, width: segmenter.frame.width - 200, height: Segmenter.Height)
        aroundEvenedSegmenter.frame = .init(x: 0, y: minorCenteredSegmenter.frame.maxY, width: segmenter.frame.width, height: Segmenter.Height)
        
        button.frame = .init(x: (self.view.frame.width - 80) / 2, y: 400, width: 80, height: 40)
    }
}



extension ViewController: SegmenterSelectedDelegate {
    func segmenter(_ segmenter: Segmenter, didSelect index: Int, withSegment: Segmenter.Segment, fromIndex: Int, fromSegment: Segmenter.Segment) {
//        print("tapped: \(index), title: \(withSegment.title)")
    }
    
}
