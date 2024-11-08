//
//  ProgressView.swift
//  EICChallenge
//
//  Created by Justine Rangel on 11/8/24.
//

import UIKit

class ProgressView: UIView {
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var mainStack: UIStackView!
    @IBOutlet private weak var progressView: UIProgressView! {
        didSet {
            progressView.progressTintColor = .primary
            progressView.transform = CGAffineTransformMakeScale(1, 2)
            layer.cornerRadius = 8.0
        }
    }
    
    var isActive: Bool = false {
        didSet {
            if isActive {
                layer.borderWidth = 1.0
                layer.borderColor = UIColor.black.withAlphaComponent(0.06).cgColor
            } else {
                layer.borderWidth = 0.0
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        loadNib(Self.self)
        addSubview(view)
        view.addSideConstraintsWithContainer()

    }
}
