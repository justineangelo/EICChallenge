//
//  Button.swift
//  EICChallenge
//
//  Created by Justine Rangel on 11/6/24.
//

import UIKit

class Button: UIButton {
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.7 : 1.0
        }
    }
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .buttonActive: .buttonInactive
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        layer.cornerRadius = 8.0
        backgroundColor = isEnabled ? .buttonActive: .buttonInactive
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.euclid(style: .medium(16.0)),
            .foregroundColor: UIColor.white]
        setAttributedTitle(NSAttributedString(string: titleLabel?.text ?? "", attributes: attributes), for: .normal)
    }
}
