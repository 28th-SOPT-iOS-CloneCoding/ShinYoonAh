//
//  SettingVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/02.
//

import UIKit
import SnapKit

class SettingVC: UIViewController {
    lazy private var settingMainView = SettingMainView(root: self, page: pageController ?? UIPageViewController() as! StoryPageVC)
    lazy private var settingSubView = SettingSubView(root: self, page: pageController ?? UIPageViewController() as! StoryPageVC)
    var pageController: StoryPageVC?
    
    private var exitButton = ExitButton()
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    var isCreateView = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfigure()
    }
    
    override func viewWillLayoutSubviews() {
        exitButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(60)
            make.trailing.equalToSuperview().inset(20)
            make.height.width.equalTo(55)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.lessThanOrEqualTo(250)
        }
        
        settingMainView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(80)
        }

        settingSubView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(120)
        }
    }
    
    private func setupConfigure() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(exitButton)
        view.addSubview(stackView)
        stackView.addArrangedSubview(settingMainView)
        stackView.addArrangedSubview(settingSubView)
        
        if isCreateView {
            settingSubView.isHidden = true
        }
        
        let exitAction = UIAction { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.exitButton.transform = CGAffineTransform(rotationAngle: -(.pi/4))
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        }
        exitButton.addAction(exitAction, for: .touchUpInside)
    }
}
