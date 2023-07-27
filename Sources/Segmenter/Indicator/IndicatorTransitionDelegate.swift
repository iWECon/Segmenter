//
//  File.swift
//  
//
//  Created by i on 2023/7/27.
//

import UIKit

public protocol IndicatorTransitionDelegate {
    
    func indicatorTransition(_ indicator: Indicator, from: SegmentView, to: SegmentView, direction: IndicatorDirection)
    
}
