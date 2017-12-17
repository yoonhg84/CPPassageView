//
// Created by Chope on 2017. 12. 12..
// Copyright (c) 2017 Chope. All rights reserved.
//

import UIKit

public class CPPassageView: UIView {
    public weak var viewCreator: CPPassageViewCreatable? {
        didSet {
            createViews()
            setFirstValue()
        }
    }
    public weak var valueUpdater: CPPassageViewValueUpdateable? {
        didSet {
            setFirstValue()
        }
    }
    public weak var delegate: CPPassageViewDelegate?
    public var transitional: CPPassageViewTransitional?

    private var currentValueView: UIView?
    private var nextValueView: UIView?

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    private func configure() {
        clipsToBounds = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        currentValueView?.frame = bounds
        nextValueView?.frame = bounds
    }

    public func refresh() {
        guard let currentValueView = currentValueView else {
            assertionFailure()
            return
        }
        guard let nextValueView = nextValueView else {
            assertionFailure()
            return
        }

        updateCurrentValue(for: nextValueView)

        if let transitional = transitional {
            transitional.transit(from: currentValueView, to: nextValueView) { [weak self] in
                guard let ss = self else { return }

                ss.currentValueView?.frame.size = ss.bounds.size
                ss.nextValueView?.frame.size = ss.bounds.size
                ss.switchViews()
            }
        } else {
            nextValueView.frame = bounds
            switchViews()
            delegate?.didUpdatedValue(passageView: self)
        }
    }

    private func switchViews() {
        let view: UIView? = currentValueView
        currentValueView = nextValueView
        nextValueView = view
    }

    private func createViews() {
        self.currentValueView?.removeFromSuperview()
        self.nextValueView?.removeFromSuperview()

        guard let viewCreator = viewCreator else { return }

        let currentValueView: UIView = viewCreator.createView(passageView: self)
        let nextValueView: UIView = viewCreator.createView(passageView: self)

        addSubview(currentValueView)
        addSubview(nextValueView)

        self.currentValueView = currentValueView
        self.nextValueView = nextValueView

    }

    private func setFirstValue() {
        updateCurrentValue(for: currentValueView)
        delegate?.didUpdatedValue(passageView: self)
    }

    private func updateCurrentValue(for view: UIView?) {
        guard let view = view else { return }
        guard let valueUpdater = valueUpdater else { return }
        valueUpdater.updateCurrentValue(for: view, in: self)
    }
}