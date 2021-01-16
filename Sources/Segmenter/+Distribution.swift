//
//  Segmenter+Distribution.swift
//  Segmenter
//
//  Created by iWw on 2021/1/11.
//

import UIKit

public extension Segmenter {
    
    enum Distribution: Int {
        
        /// Items are packed at the beginning of the main-axis.
        /// 从左到右, 默认值
        case `default`
        
        /// items are centered along the main-axis.
        /// 居中显示，超出最大宽度后不会显示
        case centered
        
        /// Space between: Items are evenly distributed in the main-axis; first item is at the beginning, last item at the end.
        /// 每两个之间的间距平均，不包括与 superView 的间距
        case evened
        
        /// Space around: Evenly distributed on the main axis (horizontal), with spacing on the left and right sides
        /// 所有间距平均，包括第一个和最后一个与 superView.left/.right 都有间距
        case aroundEvened
        
    }
    
}
