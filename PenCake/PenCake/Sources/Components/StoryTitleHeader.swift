//
//  StoryTitleHeader.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/30.
//

import UIKit
import SnapKit

class StoryTitleHeader: UIView {
    private var titleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .myBoldSystemFont(ofSize: 19)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private var subTitleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .myRegularSystemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleButton.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).inset(45)
            make.leading.equalTo(self.snp.leading).inset(15)
            make.trailing.equalTo(self.snp.trailing).inset(15)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        subTitleButton.snp.makeConstraints { make in
            make.top.equalTo(titleButton.snp.bottom).offset(25)
            make.leading.equalTo(titleButton.snp.leading)
            make.trailing.equalTo(titleButton.snp.trailing)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(subTitleButton.snp.bottom).offset(40)
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(titleButton.snp.leading)
            make.trailing.equalTo(titleButton.snp.trailing)
            make.height.equalTo(1)
        }
    }
    
    private func setupConfigure() {
        titleButton.setTitle("제목", for: .normal)
        subTitleButton.setTitle("부제목", for: .normal)
        
        addSubviews()
    }
    
    private func addSubviews() {
        addSubview(titleButton)
        addSubview(subTitleButton)
        addSubview(bottomLine)
    }
}
