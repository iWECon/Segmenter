//
//  SupplementaryViewsTransitionProvider.swift
//  Segmenter
//
//  Created by iww on 2022/3/23.
//

import UIKit

public protocol SupplementaryViewsTransitionProvider {
    
    func transition(invisibleViews: [UIView], visibleViews: [UIView])
    
}
