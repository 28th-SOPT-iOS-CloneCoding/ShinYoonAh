//
//  UIButton+SetHeaderButton.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/12.
//

import UIKit

extension UIButton {
    func setHeaderButton(title: String) {
        if title == "현재상영작보기" {
            self.setImage(UIImage(systemName: "checkmark"), for: .normal)
            self.setPreferredSymbolConfiguration(.init(pointSize: 12, weight: .bold, scale: .medium), forImageIn: .normal)
            self.setTitle(title, for: .normal)
        } else {
            self.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            self.setPreferredSymbolConfiguration(.init(pointSize: 3, weight: .regular, scale: .small), forImageIn: .normal)
            self.setTitle(" \(title)", for: .normal)
        }
        
        self.titleLabel?.font = .systemFont(ofSize: 13)
    }
}
