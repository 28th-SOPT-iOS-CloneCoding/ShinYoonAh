//
//  StoryDetailCVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/03.
//

import UIKit
import SnapKit

class StoryDetailCVC: UICollectionViewCell {
    static let identifier = "StoryDetailCVC"
    
    var delegate: ModalFromCellDelegate?
    
    private var titleButton: UIButton = {
        let button = UIButton()
        button.setTitle("제목", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .myBoldSystemFont(ofSize: 19)
        return button
    }()
    private var contentButton: UIButton = {
        let button = UIButton()
        button.setTitle("내용", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .myRegularSystemFont(ofSize: 15)
        button.titleLabel?.numberOfLines = 0
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConfigure()
        setupButtonAction()
    }
    
    override func layoutSubviews() {
        titleButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25)
            make.leading.equalToSuperview().inset(25)
        }
        
        contentButton.snp.makeConstraints { make in
            make.top.equalTo(titleButton.snp.bottom).offset(25)
            make.leading.equalToSuperview().inset(25)
        }
    }
    
    private func setupConfigure() {
        self.addSubview(titleButton)
        self.addSubview(contentButton)
    }
    
    private func setupButtonAction() {
        let titleAction = UIAction { _ in
            let storyboard = UIStoryboard(name: "StoryPage", bundle: nil)
            guard let vc = storyboard.instantiateViewController(identifier: "CreateContentVC") as? CreateContentVC else { return}
            self.delegate?.presentViewController(with: vc)
        }
        titleButton.addAction(titleAction, for: .touchUpInside)
    }
}
