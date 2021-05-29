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
    
    func changeHeaderButtonColor(selectedButton: UIButton,
                                 unselectedButton1: UIButton,
                                 unselectedButton2: UIButton) {
        if selectedButton.titleLabel?.text == "현재상영작보기" {
            selectedButton.setTitleColor(.systemRed, for: .normal)
            selectedButton.tintColor = .systemRed
        } else {
            selectedButton.setTitleColor(.black, for: .normal)
            selectedButton.tintColor = .darkGray
        }
        unselectedButton1.setTitleColor(.systemGray2, for: .normal)
        unselectedButton1.tintColor = .lightGray
        unselectedButton2.setTitleColor(.systemGray2, for: .normal)
        unselectedButton2.tintColor = .lightGray
    }
}
