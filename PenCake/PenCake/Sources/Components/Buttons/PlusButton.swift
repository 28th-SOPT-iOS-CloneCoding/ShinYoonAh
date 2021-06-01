//
//  PlusButton.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/02.
//

import UIKit

class PlusButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConfigure() {
        self.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        self.setPreferredSymbolConfiguration(.init(pointSize: 20,
                                                   weight: .ultraLight,
                                                   scale: .large),
                                              forImageIn: .normal)
        self.tintColor = .systemGray2
        self.backgroundColor = .secondarySystemBackground
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.cornerRadius = 27.5
    }
}
