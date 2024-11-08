//
//  RecapCollectionViewCell.swift
//  EICChallenge
//
//  Created by Justine Rangel on 11/7/24.
//

import UIKit

class RecapCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var label: UILabel!
    
    var data: Activity.Screen.Item? {
        didSet {
            label.font = .euclid(style: .medium(16.0))
            label.textColor = .textPrimary
            label.text = data?.text
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                label.isHidden = true
                backgroundColor = UIColor.black.withAlphaComponent(0.06)
            } else {
                label.isHidden = false
                backgroundColor = .white
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius  = 8.0
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.black.withAlphaComponent(0.06).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
    }
}
