//
//  Font+Ext.swift
//  EICChallenge
//
//  Created by Justine Rangel on 11/6/24.
//

import Foundation
import UIKit

//    100 – Thin
//    200 – Extra Light (Ultra Light)
//    300 – Light
//    400 – Normal
//    500 – Medium
//    600 – Semi Bold (Demi Bold)
//    700 – Bold
//    800 – Extra Bold (Ultra Bold)
//    900 – Black (Heavy)
enum EuclidFontStyle {
    case regular(CGFloat)
    case medium(CGFloat)
}

extension UIFont {
    static func euclid(style: EuclidFontStyle) -> UIFont {
        switch style {
        case .regular(let size):
            return UIFont(name: "EuclidCircularB-Regular", size: size)!
        case .medium(let size):
            return UIFont(name: "EuclidCircularB-Medium", size: size)!
        }
    }
}
