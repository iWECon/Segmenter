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
    
    let printButton = UIButton(type: .custom)
    let print2Button = UIButton(type: .custom)
    let print3Button = UIButton(type: .custom)
    let print4Button = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        view.backgroundColor = .magenta
        
        printButton.setTitle("按钮1", for: .normal)
        printButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        printButton.setTitleColor(.red, for: .normal)
        printButton.addTarget(self, action: #selector(printButton(_:)), for: .touchUpInside)
        
        print2Button.setTitle("按钮2", for: .normal)
        print2Button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        print2Button.setTitleColor(.blue, for: .normal)
        print2Button.addTarget(self, action: #selector(printButton(_:)), for: .touchUpInside)
        
        print3Button.setTitle("按钮3", for: .normal)
        print3Button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        print3Button.setTitleColor(.red, for: .normal)
        print3Button.addTarget(self, action: #selector(printButton(_:)), for: .touchUpInside)
        
        print4Button.setTitle("按钮4", for: .normal)
        print4Button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        print4Button.setTitleColor(.red, for: .normal)
        print4Button.addTarget(self, action: #selector(printButton(_:)), for: .touchUpInside)
        
        let v = UIView()
        v.backgroundColor = .red
        let r = UIView()
        r.backgroundColor = .blue
        
        segmenter.isShadowShouldShow = false
        segmenter.segments = [
            .init(view: v, inactiveView: r, activeSize: CGSize(width: 44, height: 24), inactiveSize: CGSize(width: 34, height: 18.57)),
            .init(image: UIImage(named: "chuanghua")!, inactiveImage: UIImage(named: "chuanghua-2")!, activeSize: CGSize(width: 32, height: 32), inactiveSize: CGSize(width: 24, height: 24)),
            .init(title: "专辑", supplementaryViews: [.view(print2Button), .view(print3Button, 5)]),
            .init(title: "歌曲", supplementaryViews: [.view(printButton), .view(print2Button), .view(print3Button)])
        ]
        segmenter.supplementaryVerticallyOffset = 5
        segmenter.distribution = .default
        segmenter.delegate = self
        view.addSubview(segmenter)
        
        minorSegmenter.isShadowShouldShow = false
        minorSegmenter.distribution = .evened
        minorSegmenter.segmentConfigure = .minor
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
            .init(title: "过去"),
            .init(title: "现在"),
            .init(title: "未来"),
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
        minorCenteredSegmenter.frame = .init(x: 0, y: minorSegmenter.frame.maxY, width: segmenter.frame.width, height: Segmenter.Height)
        aroundEvenedSegmenter.frame = .init(x: 0, y: minorCenteredSegmenter.frame.maxY, width: segmenter.frame.width, height: Segmenter.Height)
        
        button.frame = .init(x: (self.view.frame.width - 80) / 2, y: 400, width: 80, height: 40)
    }
}



extension ViewController: SegmenterSelectedDelegate {
    func segmenter(_ segmenter: Segmenter, didSelect index: Int, withSegment: Segmenter.Segment, fromIndex: Int, fromSegment: Segmenter.Segment) {
//        print("tapped: \(index), title: \(withSegment.title)")
    }
    
}
