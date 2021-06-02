//
//  ExitButton.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/02.
//

import UIKit

class ExitButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConfigure() {
        tintColor = .darkGray
        setImage(UIImage(systemName: "xmark"), for: .normal)
        setPreferredSymbolConfiguration(.init(pointSize: 20,
                                            weight: .ultraLight,
                                            scale: .large),
                                       forImageIn: .normal)
        transform = CGAffineTransform(rotationAngle: -(.pi/4))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = .identity
            })
        })
    }
}
