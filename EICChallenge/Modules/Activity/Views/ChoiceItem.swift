//
//  ChoiceItem.swift
//  EICChallenge
//
//  Created by Justine Rangel on 11/7/24.
//

import UIKit

class ChoiceItem: UIView {
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var emojiLabel: UILabel!
    @IBOutlet private weak var choiceLabel: UILabel!
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                view.layer.borderWidth = 2.0
                view.layer.borderColor = UIColor.borderActive.cgColor
            } else {
                view.layer.borderWidth = 1.0
                view.layer.borderColor = UIColor.borderInactive.cgColor
            }
        }
    }
    
    var multipleChoiceItem: Bool = false

    var data: Activity.Screen.Item? {
        didSet {
            let style = NSMutableParagraphStyle()
            style.minimumLineHeight = 22
            style.alignment = .left
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.euclid(style: .medium(14)),
                .foregroundColor: UIColor.textPrimary,
                .paragraphStyle: style,
            ]
            var text = String(data?.text?.prefix(Constants.Activity.maxChoiceTextLen) ?? "")
            if multipleChoiceItem {
                text = "\"\(text)\""
            }
            choiceLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
            emojiLabel.text = data?.emoji
        }
    }
    
    var onTapped: ((Activity.Screen.Item) -> Void)?
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        loadNib(ChoiceItem.self)
        addSubview(view)
        view.addSideConstraintsWithContainer()
        view.layer.cornerRadius = 12
        isSelected = false
    }
    
    @IBAction private func tapped(_ sender: UIButton) {
        guard let data else { return }
        onTapped?(data)
    }
}
