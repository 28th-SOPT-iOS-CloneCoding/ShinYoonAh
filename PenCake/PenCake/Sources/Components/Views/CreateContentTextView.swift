//
//  CreateContentTextView.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/31.
//

import UIKit
import SnapKit

class CreateContentTextView: UIView {
    lazy var contentTextView: UITextView = {
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
    
    var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .myBoldSystemFont(ofSize: 19)
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.attributedPlaceholder = NSAttributedString(string: "제목", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        
        textField.removeAuto()
        return textField
    }()
    
    private var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private var viewController: CreateContentVC?
    private var isEditMode = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(root viewController: CreateContentVC, title: String, content: String) {
        super.init(frame: .zero)
        self.viewController = viewController
        addSubviews()
        
        if !title.isEmpty {
            titleTextField.text = title
            isEditMode = true
        }
        
        if !content.isEmpty {
            contentTextView.text = content
            contentTextView.textColor = UIColor.black
            isEditMode = true
        }
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
    
    private func addSubviews() {
        addSubview(titleTextField)
        addSubview(bottomLine)
        addSubview(contentTextView)
    }
}

extension CreateContentTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !isEditMode {
            if textView.textColor == UIColor.systemGray2 {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
        titleTextField.isHidden = true
        viewController?.didSelectTextView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력하세요"
            textView.textColor = UIColor.systemGray2
        }
    }
}
