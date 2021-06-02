//
//  ChangeTitleVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/03.
//

import UIKit
import SnapKit

class ChangeTitleVC: UIViewController {
    lazy private var header = StorySubViewHeader(root: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfigure()
    }
    
    override func viewWillLayoutSubviews() {
        header.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
    }
    
    private func setupConfigure() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(header)
    }
}
