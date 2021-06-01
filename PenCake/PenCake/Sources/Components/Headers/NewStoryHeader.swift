//
//  NewStoryHeader.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/01.
//

import UIKit

class NewStoryHeader: UIView {
    private var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = .myRegularSystemFont(ofSize: 14)
        return button
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.systemTeal, for: .normal)
        button.titleLabel?.font = .myRegularSystemFont(ofSize: 14)
        return button
    }()
    
    private var viewController: UIViewController?
    private var newStoryVC: NewStoryVC?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(root viewController: UIViewController, with newStoryVC: NewStoryVC) {
        super.init(frame: .zero)
        self.viewController = viewController
        self.newStoryVC = newStoryVC
        addSubviews()
        setupButtonAction()
    }
    
    override func layoutSubviews() {
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalToSuperview().inset(18)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalToSuperview().inset(18)
        }
    }
    
    private func addSubviews() {
        addSubview(cancelButton)
        addSubview(nextButton)
    }
    
    private func setupButtonAction() {
        let cancelAction = UIAction { _ in
            self.viewController?.dismiss(animated: true, completion: nil)
        }
        cancelButton.addAction(cancelAction, for: .touchUpInside)
        
        let nextAction = UIAction { _ in
            print("next")
            self.newStoryVC?.moveStoryView()
        }
        nextButton.addAction(nextAction, for: .touchUpInside)
    }
}
