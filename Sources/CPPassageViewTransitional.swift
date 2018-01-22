//
// Created by Chope on 2017. 12. 16..
// Copyright (c) 2017 Chope. All rights reserved.
//

import UIKit

public protocol CPPassageViewTransitional {
    func transit(from fromView: UIView, to toView: UIView, completion: @escaping () -> ())
}

public protocol CPPassageViewDefaultTransitional {
    var duration: TimeInterval { get set }
    var delay: TimeInterval { get set }
    var options: UIViewAnimationOptions { get set }
}

public struct CPPassageViewBottomToTopTransition: CPPassageViewTransitional, CPPassageViewDefaultTransitional {
    public var duration: TimeInterval = 0.3
    public var delay: TimeInterval = 0
    public var options: UIViewAnimationOptions = [ UIViewAnimationOptions.curveEaseOut ]

    public init() {}

    public func transit(from fromView: UIView, to toView: UIView, completion: @escaping () -> ()) {
        toView.frame.origin.x = 0
        toView.frame.origin.y = fromView.bounds.height

        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            fromView.frame.origin.y -= fromView.frame.height
            toView.frame.origin.y = 0
        }, completion: { _ in
            completion()
        })
    }
}

public struct CPPassageViewTopToBottomTransition: CPPassageViewTransitional, CPPassageViewDefaultTransitional {
    public var duration: TimeInterval = 0.3
    public var delay: TimeInterval = 0
    public var options: UIViewAnimationOptions = [ UIViewAnimationOptions.curveEaseInOut ]

    public init() {}

    public func transit(from fromView: UIView, to toView: UIView, completion: @escaping () -> ()) {
        toView.frame.origin.x = 0
        toView.frame.origin.y = -fromView.bounds.height

        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            fromView.frame.origin.y = fromView.frame.height
            toView.frame.origin.y = 0
        }, completion: { _ in
            completion()
        })
    }
}

public struct CPPassageViewLeadingToTrailingTransition: CPPassageViewTransitional, CPPassageViewDefaultTransitional {
    public var duration: TimeInterval = 0.3
    public var delay: TimeInterval = 0
    public var options: UIViewAnimationOptions = [ UIViewAnimationOptions.curveEaseInOut ]

    public init() {}

    public func transit(from fromView: UIView, to toView: UIView, completion: @escaping () -> ()) {
        let isRTL: Bool = (UIView.userInterfaceLayoutDirection(for: toView.semanticContentAttribute) == .rightToLeft)

        toView.frame.origin.x = isRTL ? fromView.bounds.width : -fromView.bounds.width
        toView.frame.origin.y = 0

        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            fromView.frame.origin.x = isRTL ? -fromView.bounds.width : fromView.bounds.width
            toView.frame.origin.x = 0
        }, completion: { _ in
            completion()
        })
    }
}

public struct CPPassageViewTrailingToLeadingTransition: CPPassageViewTransitional, CPPassageViewDefaultTransitional {
    public var duration: TimeInterval = 0.3
    public var delay: TimeInterval = 0
    public var options: UIViewAnimationOptions = [ UIViewAnimationOptions.curveEaseInOut ]

    public init() {}

    public func transit(from fromView: UIView, to toView: UIView, completion: @escaping () -> ()) {
        let isRTL: Bool = (UIView.userInterfaceLayoutDirection(for: toView.semanticContentAttribute) == .rightToLeft)

        toView.frame.origin.x = isRTL ? -fromView.bounds.width : fromView.bounds.width
        toView.frame.origin.y = 0

        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            fromView.frame.origin.x = isRTL ? fromView.bounds.width : -fromView.bounds.width
            toView.frame.origin.x = 0
        }, completion: { _ in
            completion()
        })
    }
}
