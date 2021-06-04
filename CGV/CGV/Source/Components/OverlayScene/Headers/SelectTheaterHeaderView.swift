//
//  SelectTheaterHeaderView.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/06/04.
//

import UIKit
import SnapKit

class SelectTheaterHeaderView: UIView {
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = "극장선택"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        headerLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).inset(3)
            make.leading.equalTo(self.snp.leading).inset(15)
        }
    }
    
    private func setupConfigure() {
        backgroundColor = .white
        
        addSubview(headerLabel)
    }
}
