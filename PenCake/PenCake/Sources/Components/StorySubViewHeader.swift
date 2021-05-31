//
//  StorySubViewHeader.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/31.
//

import UIKit
import SnapKit

class StorySubViewHeader: UIView {
    private var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.systemGray4, for: .normal)
        button.titleLabel?.font = .myRegularSystemFont(ofSize: 14)
        return button
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.systemTeal, for: .normal)
        button.titleLabel?.font = .myRegularSystemFont(ofSize: 14)
        return button
    }()
    
    private var titleButton: UIButton = {
        let button = UIButton()
        button.setTitle("제목", for: .normal)
        button.setTitleColor(.systemGray4, for: .normal)
        button.titleLabel?.font = .myRegularSystemFont(ofSize: 14)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalToSuperview().inset(15)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalToSuperview().inset(15)
        }
        
        titleButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    private func addSubviews() {
        addSubview(cancelButton)
        addSubview(titleButton)
        addSubview(saveButton)
    }
}
