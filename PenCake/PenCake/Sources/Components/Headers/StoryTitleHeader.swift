//
//  StoryTitleHeader.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/30.
//

import UIKit
import SnapKit
import Then

class StoryTitleHeader: UIView {
    var titleButton = UIButton().then {
        $0.titleLabel?.font = .myBoldSystemFont(ofSize: 19)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    var subTitleButton = UIButton().then {
        $0.titleLabel?.font = .myRegularSystemFont(ofSize: 15)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    private var bottomLine = UIView().then {
        $0.backgroundColor = .systemGray4
    }
    
    private var vc: UIViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, subTitle: String, root viewController: UIViewController) {
        super.init(frame: .zero)
        vc = viewController
        titleButton.setTitle(title, for: .normal)
        subTitleButton.setTitle(subTitle, for: .normal)
        addSubviews()
        setupButtonAction()
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        titleButton.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).inset(45)
            make.leading.equalTo(self.snp.leading).inset(15)
            make.trailing.equalTo(self.snp.trailing).inset(15)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        subTitleButton.snp.makeConstraints { make in
            make.top.equalTo(titleButton.snp.bottom).offset(25)
            make.leading.equalTo(titleButton.snp.leading)
            make.trailing.equalTo(titleButton.snp.trailing)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(titleButton.snp.bottom).offset(85)
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(titleButton.snp.leading)
            make.trailing.equalTo(titleButton.snp.trailing)
            make.height.equalTo(1)
        }
    }
    
    private func addSubviews() {
        addSubview(titleButton)
        addSubview(subTitleButton)
        addSubview(bottomLine)
    }
    
    private func setupButtonAction() {
        let titleAction = UIAction { _ in
            guard let dvc = self.vc?.storyboard?.instantiateViewController(withIdentifier: "ChangeTitleVC") as? ChangeTitleVC else { return }
            
            if let title = self.titleButton.titleLabel?.text,
               let subTitle = self.subTitleButton.titleLabel?.text {
                dvc.titleData = title
                dvc.subTitleData = subTitle
            }
           
            dvc.changeTitle = { title, subTitle in
                self.titleButton.setTitle(title, for: .normal)
                self.subTitleButton.setTitle(subTitle, for: .normal)
            }
            
            dvc.modalPresentationStyle = .fullScreen
            self.vc?.present(dvc, animated: true, completion: nil)
        }
        titleButton.addAction(titleAction, for: .touchUpInside)
        subTitleButton.addAction(titleAction, for: .touchUpInside)
    }
    
    func updateHeaderLayout(offset: CGFloat) {
        if offset > 44 {
            titleButton.transform = CGAffineTransform(translationX: 0, y: -44)
        } else {
            titleButton.transform = CGAffineTransform(translationX: 0, y: -offset)
            titleButton.titleLabel?.font = .myBoldSystemFont(ofSize: 19 - offset/20)
            
            subTitleButton.transform = CGAffineTransform(translationX: 0, y: -offset)
            subTitleButton.titleLabel?.font = .myRegularSystemFont(ofSize: 15 - offset/20)
        }
        
        if offset > 35 {
            bottomLine.transform = CGAffineTransform(translationX: 0, y: -115)
        } else {
            bottomLine.transform = CGAffineTransform(translationX: 0, y: -offset*2.6)
        }
        
        if offset > 30 {
            subTitleButton.isHidden = true
        } else {
            subTitleButton.isHidden = false
        }
    }
    
    func backToOriginalHeaderLayout() {
        titleButton.transform = .identity
        bottomLine.transform = .identity
        subTitleButton.transform = .identity
    }
}
