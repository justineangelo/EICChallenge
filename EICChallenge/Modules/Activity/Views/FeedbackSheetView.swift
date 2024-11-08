//
//  SheetView.swift
//  EICChallenge
//
//  Created by Justine Rangel on 11/6/24.
//

import UIKit

protocol FeedbackSheetViewProtocol: AnyObject {
    var feedback: Feeback { get set }
}

enum Feeback: Equatable {
    case wrong(String)
    case correct(String)
    case none
}

class FeedbackSheetView: UIView {
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var indicatorView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    var data: Feeback?
    var onTapped: (() -> Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func reload() {
        guard let data else { return }
        switch data {
        case .correct(let message):
            indicatorView.backgroundColor = .correct
            updateMessage(message)
            show()
        case .wrong(let message):
            indicatorView.backgroundColor = .wrong
            updateMessage(message)
            show()
        case .none:
            hide()
        }
    }
    
    private func setupUI() {
        loadNib(Self.self)
        addSubview(view)
        view.addSideConstraintsWithContainer()
        hide(false)
    }
    
    private func updateMessage(_ message: String) {
//        let style = NSMutableParagraphStyle()
//        style.minimumLineHeight = 30
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.euclid(style: .medium(18)),
            .foregroundColor: UIColor.textPrimary,
//            .paragraphStyle: style,
        ]
        messageLabel.attributedText = NSAttributedString(string: message, attributes: attributes)
    }
    
    private func hide(_ animated: Bool = true) {
        let transform = CGAffineTransform.identity.translatedBy(x: 0.0, y: 300.0)
        if animated {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.transform = transform
            }
        } else {
            self.transform = transform
        }
    }
    
    private func show() {
        let transform = CGAffineTransform.identity.translatedBy(x: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.transform = transform
        }
    }
    
    @IBAction private func tapped(_ sender: Any) {
        onTapped?()
    }
}
