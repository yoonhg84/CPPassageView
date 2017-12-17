//
// Created by Chope on 2017. 12. 16..
// Copyright (c) 2017 Chope. All rights reserved.
//

import UIKit

public protocol CPPassageViewCreatable: class {
    func createView(passageView: CPPassageView) -> UIView
}