//
//  EmptyView.swift
//  EICChallenge
//
//  Created by Justine Rangel on 11/7/24.
//

import UIKit


class EmptyView: UIView {
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    let viewModel: ActivityNavigation
    
    init(_ viewModel: ActivityViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        loadNib(Self.self)
        addSubview(view)
        view.addSideConstraintsWithContainer()
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 36
        style.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.euclid(style: .medium(22.0)),
            .foregroundColor: UIColor.textPrimary,
            .paragraphStyle: style,
        ]
        messageLabel.attributedText = NSAttributedString(string: "Module not found!", attributes: attributes)
    }
    
    @IBAction private func goBackTapped(_ sender: Any) {
        viewModel.navigateBack(.transitionCrossDissolve)
    }
}
