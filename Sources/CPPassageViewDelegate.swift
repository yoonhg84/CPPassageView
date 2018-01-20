//
// Created by Chope on 2017. 12. 16..
// Copyright (c) 2017 Chope. All rights reserved.
//

import UIKit

public protocol CPPassageViewDelegate: class {
    func updateCurrent(view: UIView, in passageView: CPPassageView)
    func willDisappear(view: UIView, in passageView: CPPassageView)
    func didUpdated(passageView: CPPassageView)
}