//
//  ViewController.swift
//  CPPassageView
//
//  Created by Chope on 2017. 12. 12..
//  Copyright © 2017 Chope. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private lazy var passageViews: [CPPassageView] = {
        return [
            hourFirstPassageView,
            hourSecondPassageView,
            minuteFirstPassageView,
            minuteSecondPassageView,
            secondFirstPassageView,
            secondSecondPassageView
        ]
    }()

    private var timer: Timer?
    private var timeString: String? {
        didSet {
            guard let newTime = timeString else { return }
            updateClockViewWith(oldTime: oldValue, newTime: newTime)
        }
    }

    private let hourFirstPassageView = CPPassageView()
    private let hourSecondPassageView = CPPassageView()
    private let minuteFirstPassageView = CPPassageView()
    private let minuteSecondPassageView = CPPassageView()
    private let secondFirstPassageView = CPPassageView()
    private let secondSecondPassageView = CPPassageView()
    private let hourAndMinuteSeparatorLabel = UILabel()
    private let minuteAndSecondSeparatorLabel = UILabel()
    private let clockStackView = UIStackView()
    private let backgroundView = UIView()
    private let bottomToTopButton = UIButton(type: .system)
    private let topToBottomButton = UIButton(type: .system)
    private let leadingToTrailingButton = UIButton(type: .system)
    private let trailingToLeadingButton = UIButton(type: .system)
    private let buttonStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backgroundView)
        view.addSubview(clockStackView)
        view.addSubview(buttonStackView)

        passageViews.forEach { view in
            clockStackView.addArrangedSubview(view)
            view.viewCreator = self
            view.delegate = self
            view.transitional = CPPassageViewBottomToTopTransition()

            view.snp.makeConstraints { maker in
                maker.height.equalTo(30)
                maker.width.equalTo(24)
            }
        }

        clockStackView.insertArrangedSubview(hourAndMinuteSeparatorLabel, at: 2)
        clockStackView.insertArrangedSubview(minuteAndSecondSeparatorLabel, at: 5)
        clockStackView.alignment = .fill
        clockStackView.axis = .horizontal

        backgroundView.backgroundColor = UIColor.black

        [ hourAndMinuteSeparatorLabel,
          minuteAndSecondSeparatorLabel ].forEach { label in
            label.textColor = UIColor.white
            label.text = ":"
            label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        }

        buttonStackView.distribution = .fillEqually
        buttonStackView.axis = .horizontal

        bottomToTopButton.setTitle("↑", for: .normal)
        topToBottomButton.setTitle("↓", for: .normal)
        leadingToTrailingButton.setTitle("→", for: .normal)
        trailingToLeadingButton.setTitle("←", for: .normal)

        [bottomToTopButton,
         topToBottomButton,
         leadingToTrailingButton,
         trailingToLeadingButton].forEach { button in
            buttonStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(changePassType(button:)), for: .touchUpInside)
        }

        clockStackView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }

        backgroundView.snp.makeConstraints { maker in
            maker.size.equalTo(clockStackView.snp.size)
            maker.center.equalTo(clockStackView.snp.center)
        }

        buttonStackView.snp.makeConstraints { maker in
            maker.bottom.leading.trailing.equalToSuperview().inset(20)
        }

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    @objc
    func updateTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hhmmss"
        timeString = dateFormatter.string(from: Date())
    }

    @objc
    func changePassType(button: UIButton) {
        let transitional: CPPassageViewTransitional = {
            switch button {
            case bottomToTopButton:
                return CPPassageViewBottomToTopTransition()
            case topToBottomButton:
                return CPPassageViewTopToBottomTransition()
            case leadingToTrailingButton:
                return CPPassageViewLeadingToTrailingTransition()
            case trailingToLeadingButton:
                return CPPassageViewTrailingToLeadingTransition()
            default:
                return CPPassageViewBottomToTopTransition()
            }
        }()

        passageViews.forEach {
            $0.transitional = transitional
        }
    }

    private func updateClockViewWith(oldTime: String?, newTime: String) {
        guard let oldTime = oldTime else {
            passageViews.forEach {
                $0.refresh()
            }
            return
        }

        (0..<passageViews.count)
                .filter { index in
                    let stringIndex = oldTime.index(oldTime.startIndex, offsetBy: index)
                    return oldTime[stringIndex] != newTime[stringIndex]
                }
                .map {
                    return passageViews[$0]
                }
                .forEach {
                    $0.refresh()
                }
    }
}

extension ViewController: CPPassageViewCreatable {
    func createView(passageView: CPPassageView) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textColor = UIColor.white
        return label
    }
}

extension ViewController: CPPassageViewDelegate {
    func updateCurrent(view: UIView, in passageView: CPPassageView) {
        guard let label = view as? UILabel else { return }
        guard let timeString = timeString else {
            label.text = "-"
            return
        }
        guard let index = passageViews.index(of: passageView) else {
            label.text = "-"
            return
        }

        let stringIndex = timeString.index(timeString.startIndex, offsetBy: index)
        let digitCharacter = timeString[stringIndex]
        label.text = "\(digitCharacter)"
    }

    func willDisappear(view: UIView, in passageView: CPPassageView) {
        guard let label = view as? UILabel else { return }
        label.text = "*"
    }

    func didUpdated(passageView: CPPassageView) {
        print("didUpdated")
    }
}