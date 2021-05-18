//
//  UIView+SetViewShadow.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/18.
//

import UIKit

extension UIView {
    func setViewShadow(backView: UIView) {
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 10
        backView.layer.borderWidth = 1
        
        layer.masksToBounds = false
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: -2, height: 2)
        layer.shadowRadius = 3
    }
}
