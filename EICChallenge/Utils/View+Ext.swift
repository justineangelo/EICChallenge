//
//  View+Ext.swift
//  EICChallenge
//
//  Created by Justine Rangel on 11/6/24.
//

import Foundation
import UIKit

extension UIView {
    func loadNib<T: UIView>(_ owner: T.Type) {
        Bundle(for: type(of: self)).loadNibNamed(String(describing: T.self), owner: self, options: nil)
    }
    
    func addSideConstraintsWithContainer(_ container: UIView? = nil) {
        guard let superView = container ?? self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor),
            self.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
