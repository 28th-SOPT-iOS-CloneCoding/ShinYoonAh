//
//  Extension+UITextField.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/01.
//

import UIKit

extension UITextField {
    func setTextFieldUnderLine(width: CGFloat) {
        let border = CALayer()
        border.frame = CGRect(x: -60, y: 22, width: width, height: 1)
        border.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3).cgColor
        self.layer.addSublayer(border)
        self.borderStyle = .none
    }
}
