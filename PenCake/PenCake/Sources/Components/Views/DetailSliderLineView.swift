//
//  DetailSliderLineView.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/03.
//

import UIKit

class DetailSliderLineView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConfigure() {
        backgroundColor = .systemGray4
    }
}
