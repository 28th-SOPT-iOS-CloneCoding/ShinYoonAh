//
//  CreateContentTextView.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/31.
//

import UIKit
import SnapKit

class CreateContentTextView: UIView {
    lazy private var contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .myRegularSystemFont(ofSize: 14)
        textView.textColor = .systemGray2
        textView.text = "내용을 입력하세요"
        textView.backgroundColor = .clear
        
        textView.delegate = self
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.spellCheckingType = .no
        textView.textContentType = .none
        return textView
    }()
    
    private var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .myBoldSystemFont(ofSize: 19)
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.attributedPlaceholder = NSAttributedString(string: "제목", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        textField.textContentType = .none
        return textField
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
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(18)
            make.height.equalTo(50)
        }
        
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(2)
            make.leading.trailing.equalTo(titleTextField)
            make.height.equalTo(1)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(bottomLine.snp.bottom).offset(25)
            make.leading.trailing.equalTo(titleTextField)
            make.height.equalTo(200)
        }
    }
    
    private func setupConfigure() {
        titleTextField.becomeFirstResponder()
        
        addSubviews()
    }
    
    private func addSubviews() {
        addSubview(titleTextField)
        addSubview(bottomLine)
        addSubview(contentTextView)
    }
}

extension CreateContentTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray2 {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력하세요"
            textView.textColor = UIColor.systemGray2
        }
    }
}
