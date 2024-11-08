//
//  ChoiceView.swift
//  EICChallenge
//
//  Created by Justine Rangel on 11/6/24.
//

import UIKit

private extension ActivityChildViewModelProtocol {
    var isContinueShown: Bool {
        guard let selectedScreen else { return false }
        return selectedScreen.multipleChoicesAllowed ?? false
    }
    
    var isContinueEnabled: Bool {
        guard let selectedScreen else { return false }
        return selectedChoices(forScreen: selectedScreen.id).count > 0
    }
}

class ChoiceView: UIView {
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var choicesStack: UIStackView!
    @IBOutlet private weak var continueButton: Button!
    
    let viewModel: ActivityChildViewModelProtocol
    
    init(_ viewModel: ActivityChildViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("deinit ChoiceView")
    }

    private func setupUI() {
        loadNib(Self.self)
        addSubview(view)
        view.addSideConstraintsWithContainer()
        guard let selectedScreen = viewModel.selectedScreen else { return }
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 36
        style.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.euclid(style: .medium(22.0)),
            .foregroundColor: UIColor.textPrimary,
            .paragraphStyle: style,
        ]
        questionLabel.attributedText = NSAttributedString(string: String(selectedScreen.question?.prefix(Constants.Activity.maxQuestionLen) ?? ""),
                                                          attributes: attributes)
        continueButton.isHidden = !viewModel.isContinueShown
        updateUI(selectedScreen: selectedScreen)
    }
    
    private func updateUI(selectedScreen: Activity.Screen) {
        for view in choicesStack.subviews {
            view.removeFromSuperview()
        }
        let isContinueShown = viewModel.isContinueShown
        for item in selectedScreen.choices ?? [] {
            let choiceItem = ChoiceItem()
            choiceItem.multipleChoiceItem = selectedScreen.multipleChoicesAllowed ?? false
            choiceItem.data = item
            choiceItem.isSelected = viewModel.selectedChoices(forScreen: selectedScreen.id)[item.id] ?? false
            choiceItem.onTapped = { [weak self] item in
                if selectedScreen.multipleChoicesAllowed ?? false {
                    self?.viewModel.toggleChoice(item.id, forScreen: selectedScreen.id)
                } else {
                    self?.viewModel.selectChoice(item.id, forScreen: selectedScreen.id)
                }
                self?.updateUI(selectedScreen: selectedScreen)
                if !isContinueShown {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        self?.viewModel.navigateNext(.transitionCurlUp)
                    }
                }
            }
            choicesStack.addArrangedSubview(choiceItem)
        }
        choicesStack.isHidden = choicesStack.subviews.isEmpty
        if isContinueShown {
            continueButton.isEnabled = viewModel.isContinueEnabled
        }
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        viewModel.navigateNext(.transitionCurlUp)
    }
}
