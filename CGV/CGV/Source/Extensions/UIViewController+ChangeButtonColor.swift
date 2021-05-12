//
//  UIViewController+ChangeButtonColor.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/12.
//

import UIKit

extension UIViewController {
    func changeButtonTextColor(selectedButton: UIButton,
                                     unselectedButton1: UIButton,
                                     unselectedButton2: UIButton) {
        selectedButton.setTitleColor(.black, for: .normal)
        unselectedButton1.setTitleColor(.gray, for: .normal)
        unselectedButton2.setTitleColor(.gray, for: .normal)
    }
}
