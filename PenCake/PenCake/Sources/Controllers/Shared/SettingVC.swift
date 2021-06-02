//
//  SettingVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/02.
//

import UIKit
import SnapKit

class SettingVC: UIViewController {
    private var exitButton = ExitButton()
    
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
    }
    
    private func setupConfigure() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(exitButton)
        
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
