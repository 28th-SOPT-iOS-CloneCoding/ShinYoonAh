//
//  CreateStoryVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/30.
//

import UIKit
import SnapKit

class CreateStoryVC: UIViewController {
    lazy private var plusView = CreateStoryView(root: self, page: pageController ?? UIPageViewController() as! StoryPageVC)
    var pageController: StoryPageVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        plusView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(180)
        }
    }
    
    private func addSubviews() {
        view.addSubview(plusView)
    }
}
