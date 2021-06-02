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
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        return button
    }()
    
    private var subTitleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .myRegularSystemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        return button
    }()
    
    private var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleButton.setTitle("이야기1", for: .normal)
        subTitleButton.setTitle("부제목", for: .normal)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, subTitle: String) {
        super.init(frame: .zero)
        titleButton.setTitle(title, for: .normal)
        subTitleButton.setTitle(subTitle, for: .normal)
        addSubviews()
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
            make.top.equalTo(titleButton.snp.bottom).offset(85)
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(titleButton.snp.leading)
            make.trailing.equalTo(titleButton.snp.trailing)
            make.height.equalTo(1)
        }
    }
    
    private func addSubviews() {
        addSubview(titleButton)
        addSubview(subTitleButton)
        addSubview(bottomLine)
    }
    
    func updateHeaderLayout(offset: CGFloat) {
        if offset > 44 {
            titleButton.transform = CGAffineTransform(translationX: 0, y: -44)
        } else {
            titleButton.transform = CGAffineTransform(translationX: 0, y: -offset)
            titleButton.titleLabel?.font = .myBoldSystemFont(ofSize: 19 - offset/20)
            
            subTitleButton.transform = CGAffineTransform(translationX: 0, y: -offset)
            subTitleButton.titleLabel?.font = .myRegularSystemFont(ofSize: 15 - offset/20)
        }
        
        if offset > 35 {
            bottomLine.transform = CGAffineTransform(translationX: 0, y: -115)
        } else {
            bottomLine.transform = CGAffineTransform(translationX: 0, y: -offset*2.6)
        }
        
        if offset > 30 {
            subTitleButton.isHidden = true
        } else {
            subTitleButton.isHidden = false
        }
    }
    
    func backToOriginalHeaderLayout() {
        titleButton.transform = .identity
        bottomLine.transform = .identity
        subTitleButton.transform = .identity
    }
}
