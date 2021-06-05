//
//  StoryDetailCVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/03.
//

import UIKit
import SnapKit
import Then

class StoryDetailCVC: UICollectionViewCell {
    static let identifier = "StoryDetailCVC"
    
    var delegate: ModalFromCellDelegate?
    
    private var titleButton = UIButton().then {
        $0.setTitle("제목", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .myBoldSystemFont(ofSize: 19)
    }
    
    private var contentButton = UIButton().then {
        $0.setTitle("내용", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .myRegularSystemFont(ofSize: 15)
        $0.titleLabel?.numberOfLines = 0
    }
    
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
            self.presentCreateContent(contentMode: false)
        }
        titleButton.addAction(titleAction, for: .touchUpInside)
        
        let contentAction = UIAction { _ in
            print("double tap ! ! !")
            self.presentCreateContent(contentMode: true)
        }
        contentButton.addAction(contentAction, for: .touchDownRepeat)
    }
    
    private func presentCreateContent(contentMode: Bool) {
        let storyboard = UIStoryboard(name: "StoryPage", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "CreateContentVC") as? CreateContentVC else { return}
        if let title = titleButton.titleLabel?.text,
           let content = contentButton.titleLabel?.text {
            vc.contentTitle = title
            vc.content = content
        }
        vc.isContentMode = contentMode
        vc.saveContent = { title, content in
            self.titleButton.setTitle(title, for: .normal)
            self.contentButton.setTitle(content, for: .normal)
        }
        delegate?.presentViewController(with: vc)
    }
}
