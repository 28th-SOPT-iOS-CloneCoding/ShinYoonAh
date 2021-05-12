//
//  UIViewController+ChangeButtonColor.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/12.
//

import UIKit

extension UIViewController {
    func changeButtonState(selectedButton: UIButton,
                                     unselectedButton1: UIButton,
                                     unselectedButton2: UIButton) {
        selectedButton.setTitleColor(.black, for: .normal)
        unselectedButton1.setTitleColor(.lightGray, for: .normal)
        unselectedButton2.setTitleColor(.lightGray, for: .normal)
        
        selectedButton.isSelected = true
        unselectedButton1.isSelected = false
        unselectedButton2.isSelected = false
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
