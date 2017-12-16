//
// Created by Chope on 2017. 12. 12..
// Copyright (c) 2017 Chope. All rights reserved.
//

import UIKit
import SnapKit

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
    public weak var delegate: PassageViewDelegate?

    public var passType: CPPassDirection = .topToBottom {
        didSet {
            updateValueViewConstraints()
        }
    }

    private var currentValueView: UIView?
    private var nextValueView: UIView?
    private var offsetConstraint: Constraint?

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

    public func refresh() {
        updateCurrentValue(for: nextValueView)

        switch passType {
        case .topToBottom:
            offsetConstraint?.update(offset: bounds.height)
        case .bottomToTop:
            offsetConstraint?.update(offset: -bounds.height)
        case .leadingToTrailing:
            offsetConstraint?.update(offset: bounds.width)
        case .trailingToLeading:
            offsetConstraint?.update(offset: -bounds.width)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [UIViewAnimationOptions.curveEaseInOut], animations: { [weak self] in
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.switchViews()
            self?.updateValueViewConstraints()

            DispatchQueue.main.async {
                if let ss = self {
                    ss.delegate?.didUpdatedValue(passageView: ss)
                }
            }
        })
    }

    private func switchViews() {
        let view: UIView? = currentValueView
        currentValueView = nextValueView
        nextValueView = view
    }

    private func createViews() {
        currentValueView?.removeFromSuperview()
        nextValueView?.removeFromSuperview()

        guard let viewCreator = viewCreator else { return }

        currentValueView = viewCreator.createView()
        nextValueView = viewCreator.createView()

        addSubview(currentValueView!)
        addSubview(nextValueView!)

        updateValueViewConstraints()
    }

    private func updateValueViewConstraints() {
        updateCurrentValueConstraint()
        updateNextValueConstraint()
    }

    private func updateCurrentValueConstraint() {
        guard let view = currentValueView else { return }
        view.snp.remakeConstraints { maker in
            maker.size.equalToSuperview()

            switch passType {
            case .topToBottom:
                maker.leading.equalToSuperview()
                offsetConstraint = maker.bottom.equalToSuperview().constraint
            case .bottomToTop:
                maker.leading.equalToSuperview()
                offsetConstraint = maker.top.equalToSuperview().constraint
            case .leadingToTrailing:
                maker.top.equalToSuperview()
                offsetConstraint = maker.trailing.equalToSuperview().constraint
            case .trailingToLeading:
                maker.top.equalToSuperview()
                offsetConstraint = maker.leading.equalToSuperview().constraint
            }
        }
    }

    private func updateNextValueConstraint() {
        guard let currentValueView = currentValueView else { return }
        guard let nextValueView = nextValueView else { return }
        nextValueView.snp.remakeConstraints { maker in
            maker.size.equalToSuperview()

            switch passType {
            case .topToBottom:
                maker.leading.equalToSuperview()
                maker.bottom.equalTo(currentValueView.snp.top)
            case .bottomToTop:
                maker.leading.equalToSuperview()
                maker.top.equalTo(currentValueView.snp.bottom)
            case .leadingToTrailing:
                maker.top.equalToSuperview()
                maker.trailing.equalTo(currentValueView.snp.leading)
            case .trailingToLeading:
                maker.top.equalToSuperview()
                maker.leading.equalTo(currentValueView.snp.trailing)
            }
        }
    }

    private func setFirstValue() {
        guard let creator = viewCreator else { return }
        guard let updater = valueUpdater else { return }
        updateCurrentValue(for: currentValueView)
        delegate?.didUpdatedValue(passageView: self)
    }

    private func updateCurrentValue(for view: UIView?) {
        guard let view = view else { return }
        guard let valueUpdater = valueUpdater else { return }
        valueUpdater.updateCurrentValue(for: view, in: self)
    }
}