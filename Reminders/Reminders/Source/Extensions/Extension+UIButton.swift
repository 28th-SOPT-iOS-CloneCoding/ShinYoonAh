//
//  Extension+UIButton.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/29.
//

import UIKit

extension UIButton {
    func setGredient(color: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color.withAlphaComponent(0.3).cgColor, color.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        gradient.cornerRadius = 45
        layer.insertSublayer(gradient, above: self.layer)
    }
}
