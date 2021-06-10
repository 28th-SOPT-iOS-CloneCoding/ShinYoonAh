//
//  CreateContentVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/31.
//

import UIKit
import SnapKit

class CreateContentVC: UIViewController {
    var saveContent: ((String, String) -> ())?
    
    lazy private var header = StorySubViewHeader(root: self, embed: self)
    lazy private var contentView = CreateContentTextView(root: self, title: contentTitle, content: content)
    
    var contentTitle: String = ""
    var content: String = ""
    var isContentMode = false
    
    let manager = StoryManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigure()
    }
    
    override func viewWillLayoutSubviews() {
        header.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupConfigure() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(header)
        view.addSubview(contentView)
        
        if isContentMode {
            presentInContentMode()
            contentView.contentTextView.becomeFirstResponder()
        } else {
            contentView.titleTextField.becomeFirstResponder()
        }
    }
    
    func didSelectTextView() {
        UIView.animate(withDuration: 0.1, animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -60)
        })
        
        if let text = contentView.titleTextField.text {
            header.titleButton.isHidden = false
            if text.isEmpty {
                header.titleButton.setTitle("제목", for: .normal)
                header.titleButton.setTitleColor(.systemGray, for: .normal)
            } else {
                header.titleButton.setTitle(text, for: .normal)
                header.titleButton.setTitleColor(.black, for: .normal)
            }
        }
        
        view.bringSubviewToFront(header)
    }
    
    func backToOriginalPosition() {
        UIView.animate(withDuration: 0.1, animations: {
            self.contentView.transform = .identity
            self.header.titleButton.isHidden = true
        }) { _ in
            self.contentView.titleTextField.isHidden = false
            self.contentView.titleTextField.becomeFirstResponder()
        }
    }
    
    func didClickCancel() {
        if let hasTextfield = contentView.titleTextField.text,
           let hasTextView = contentView.contentTextView.text {
            if hasTextfield.isEmpty && (hasTextView.isEmpty || hasTextView == "내용을 입력하세요" || hasTextView == content){
                dismiss(animated: true, completion: nil)
            } else {
                print(hasTextView.isEmpty)
                makeActionSheet(message: "작성중인 글이 있습니다.")
            }
        }
    }
    
    func presentInContentMode() {
        UIView.animate(withDuration: 0.1, animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -60)
        })
        
        header.titleButton.isHidden = false
        contentView.titleTextField.isHidden = true
        
        if contentTitle.isEmpty {
            header.titleButton.setTitle("제목", for: .normal)
            header.titleButton.setTitleColor(.systemGray, for: .normal)
        } else {
            header.titleButton.setTitle(contentTitle, for: .normal)
            header.titleButton.setTitleColor(.black, for: .normal)
        }
        
        view.bringSubviewToFront(header)
    }
    
    func saveEditContent() {
        if let text = contentView.titleTextField.text,
           let content = contentView.contentTextView.text {
            manager.insertContent(content: Content(title: text, content: content, date: Date()))
            saveContent?(text, content)
        }
    }
}
