//
//  SettingSubView.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/02.
//

import UIKit
import SnapKit

class SettingSubView: UIView {
    private var contentButton: UIButton = {
        let button = UIButton()
        button.setTitle("글 추가", for: .normal)
        button.titleLabel?.font = .myRegularSystemFont(ofSize: 15)
        button.setTitleColor(.systemTeal, for: .normal)
        return button
    }()
    
    private var storyButton: UIButton = {
        let button = UIButton()
        button.setTitle("이야기 제거", for: .normal)
        button.titleLabel?.font = .myRegularSystemFont(ofSize: 15)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    
    private var middleLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        return view
    }()
    
    private var vc: SettingVC?
    private var pageVC: StoryPageVC?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(root viewController: SettingVC, page pageController: StoryPageVC) {
        super.init(frame: .zero)
        vc = viewController
        pageVC = pageController
        addSubviews()
        setupButtonAction()
    }
    
    override func layoutSubviews() {
        middleLine.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(1)
        }
        
        storyButton.snp.makeConstraints { make in
            make.top.equalTo(middleLine.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        contentButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func addSubviews() {
        addSubview(contentButton)
        addSubview(storyButton)
        addSubview(middleLine)
    }
    
    private func setupButtonAction() {
        let storyAction = UIAction { _ in
            self.vc?.makeRemoveAlert(title: "이야기 제거", message: "정말 제거하시겠습니까? 제거를 하면 이야기 내 모든 글도 함께 삭제됩니다.", okAction: { _ in
                self.vc?.makeRemoveAlert(title: "이야기 제거", message: "다시 확인합니다. 정말 제거하시겠습니까?", okAction: { _ in
                    self.pageVC?.removeViewController()
                })
            })
        }
        storyButton.addAction(storyAction, for: .touchUpInside)
        
        let contentAction = UIAction { _ in
            print("글 생성")
            guard let dvc = self.vc?.storyboard?.instantiateViewController(withIdentifier: "CreateContentVC") as? CreateContentVC else { return }
            dvc.modalPresentationStyle = .fullScreen
            self.vc?.present(dvc, animated: true, completion: nil)
        }
        contentButton.addAction(contentAction, for: .touchUpInside)
    }
}
