//
//  NewStoryVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/31.
//

import UIKit
import SnapKit

class NewStoryVC: UIViewController {
    lazy private var header = NewStoryHeader(root: self)
    private var storyView = StoryTitleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfigure()
    }
    
    override func viewWillLayoutSubviews() {
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        storyView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(header.snp.bottom).offset(130)
            make.width.equalTo(UIScreen.main.bounds.size.width - 100)
            make.height.equalTo(90)
        }
    }
    
    private func setupConfigure() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(header)
        view.addSubview(storyView)
    }
}
