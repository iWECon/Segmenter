//
//  Created by iWw on 2021/1/21.
//

import UIKit

public protocol SegmentInfoProvider {
    
    var viewType: (SegmentView).Type { get }
}
