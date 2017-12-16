//
// Created by Chope on 2017. 12. 12..
// Copyright (c) 2017 Chope. All rights reserved.
//

import UIKit

public protocol CPPassageViewValueUpdateable: class {
    func updateCurrentValue(for view: UIView, in passageView: CPPassageView)
}