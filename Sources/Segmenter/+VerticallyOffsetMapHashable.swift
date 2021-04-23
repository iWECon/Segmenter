//
//  VerticallyOffsetMapHashable.swift
//  Segmenter
//
//  Created by iWw on 2021/1/12.
//

import UIKit

extension Segmenter {
    
    struct VerticallyOffsetMapHashable: Hashable {
        
        static func == (lhs: VerticallyOffsetMapHashable, rhs: VerticallyOffsetMapHashable) -> Bool {
            lhs.index == rhs.index && lhs.view == rhs.view
        }
        
        
        var index: Int
        var view: UIView
        
        init(index: Int, view: UIView) {
            self.index = index
            self.view = view
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(index)
        }
    }

}
