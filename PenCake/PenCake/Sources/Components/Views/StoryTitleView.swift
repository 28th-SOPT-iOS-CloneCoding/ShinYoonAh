//
//  StoryTitleView.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/01.
//

import UIKit
import SnapKit
import Then

class StoryTitleView: UIView {
    private var titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .myRegularSystemFont(ofSize: 15)
    }
    
    var titleTextField = UITextField().then {
        $0.setTextFieldUnderLine()
        $0.textAlignment = .center
        $0.font = .myRegularSystemFont(ofSize: 15)
        $0.removeAuto()
    }

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
            make.width.equalTo(250)
        }
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(titleTextField)
        
        titleTextField.becomeFirstResponder()
    }
}
