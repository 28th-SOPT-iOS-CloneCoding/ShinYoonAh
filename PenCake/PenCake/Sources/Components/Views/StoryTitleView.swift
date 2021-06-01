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
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .myRegularSystemFont(ofSize: 15)
        return label
    }()
    
    var titleTextField: UITextField = {
        let textField = UITextField()
        textField.setTextFieldUnderLine(width: UIScreen.main.bounds.size.width - 120)
        textField.textAlignment = .center
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
    
    init(content: String, placeholder: String) {
        super.init(frame: .zero)
        titleLabel.text = content
        titleTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        addSubviews()
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
