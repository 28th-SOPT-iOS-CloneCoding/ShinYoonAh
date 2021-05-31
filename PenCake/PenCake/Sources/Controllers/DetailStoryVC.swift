//
//  DetailStoryVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/31.
//

import UIKit

class DetailStoryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupConfigure()
    }
    
    private func setupConfigure() {
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 8
    }
}
