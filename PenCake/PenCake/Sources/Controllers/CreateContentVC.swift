//
//  CreateContentVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/31.
//

import UIKit
import SnapKit

class CreateContentVC: UIViewController {
    lazy private var header = StorySubViewHeader(root: self, embed: self)
    lazy private var contentView = CreateContentTextView(root: self)

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
            if hasTextfield.isEmpty && (hasTextView.isEmpty || hasTextView == "내용을 입력하세요"){
                dismiss(animated: true, completion: nil)
            } else {
                print(hasTextView.isEmpty)
                makeActionSheet(message: "작성중인 글이 있습니다.")
            }
        }
    }
}
