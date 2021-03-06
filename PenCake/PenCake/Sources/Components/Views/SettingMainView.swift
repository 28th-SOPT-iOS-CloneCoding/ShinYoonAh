//
//  SettingMainView.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/02.
//

import UIKit
import SnapKit
import Then

class SettingMainView: UIView {
    private var settingButton = UIButton().then {
        $0.setTitle("앱 설정", for: .normal)
        $0.titleLabel?.font = .myRegularSystemFont(ofSize: 15)
        $0.setTitleColor(.black, for: .normal)
    }
    
    private var storyButton = UIButton().then {
        $0.setTitle("이야기 추가", for: .normal)
        $0.titleLabel?.font = .myRegularSystemFont(ofSize: 15)
        $0.setTitleColor(.black, for: .normal)
    }
    
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
        settingButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        storyButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func addSubviews() {
        addSubview(settingButton)
        addSubview(storyButton)
    }
    
    private func setupButtonAction() {
        let storyAction = UIAction { _ in
            print("나타나라 Story 쇽샥")
            guard let dvc = self.vc?.storyboard?.instantiateViewController(withIdentifier: "NewStoryVC") as? NewStoryVC else { return }
            dvc.storyPageVC = self.pageVC
            dvc.modalPresentationStyle = .fullScreen
            self.vc?.present(dvc, animated: true, completion: nil)
        }
        storyButton.addAction(storyAction, for: .touchUpInside)
    }
}
