//
//  StoryTitleView.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/01.
//

import UIKit
import SnapKit

class StoryTitleView: UIView {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "새 이야기를 추가합니다.\n이야기의 제목을 입력해주세요."
        label.textAlignment = .center
        label.font = .myRegularSystemFont(ofSize: 15)
        return label
    }()
    
    private var titleTextField: UITextField = {
        let textField = UITextField()
        textField.setTextFieldUnderLine(width: UIScreen.main.bounds.size.width - 100)
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(string: "예) 일기, 일상을 끄적이다", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        textField.font = .myRegularSystemFont(ofSize: 15)
        textField.removeAuto()
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        titleTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
        }
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(titleTextField)
        
        titleTextField.becomeFirstResponder()
    }
}
