//
//  DetailStoryVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/31.
//

import UIKit
import SnapKit

class DetailStoryVC: UIViewController {
    lazy private var backButton: UIButton = {
        let button = UIButton()
        let action = UIAction { _ in
            self.navigationController?.popViewController(animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 18,
                                                    weight: .light,
                                                    scale: .large),
                                               forImageIn: .normal)
        button.tintColor = .lightGray
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupConfigure()
    }
    
    override func viewWillLayoutSubviews() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(40)
        }
    }
    
    private func setupConfigure() {
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 8
        
        view.addSubview(backButton)
    }
}
