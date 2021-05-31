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
    
    private func setupConfigure() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(header)
        view.addSubview(contentView)
        
        header.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
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
}
