//
//  CreateStoryVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/30.
//

import UIKit
import SnapKit

class CreateStoryVC: UIViewController {
    lazy private var plusView = CreateStoryView(root: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupConfigure()
    }
    
    override func viewWillLayoutSubviews() {
        plusView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupConfigure() {
        view.addSubview(plusView)
    }
}
