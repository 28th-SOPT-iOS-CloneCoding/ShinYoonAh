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
}
