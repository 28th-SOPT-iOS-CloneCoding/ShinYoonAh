//
//  Extension+UITextField.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/01.
//

import UIKit

extension UITextField {
    func setTextFieldUnderLine() {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: 22, width: 250, height: 1)
        border.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3).cgColor
        self.layer.addSublayer(border)
        self.borderStyle = .none
    }
    
    func removeAuto() {
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.spellCheckingType = .no
        self.textContentType = .none
    }
}
