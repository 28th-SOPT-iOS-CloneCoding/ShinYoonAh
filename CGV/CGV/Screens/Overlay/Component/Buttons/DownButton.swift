//
//  DownButton.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/06/04.
//

import UIKit

class DownButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConfigure() {
        setImage(UIImage(systemName: "chevron.down"), for: .normal)
        tintColor = .gray
        backgroundColor = .white
        setPreferredSymbolConfiguration(.init(pointSize: 15,
                                              weight: .regular,
                                              scale: .small),
                                         forImageIn: .normal)
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: -2, height: 2)
        layer.shadowRadius = 3
    }
}
