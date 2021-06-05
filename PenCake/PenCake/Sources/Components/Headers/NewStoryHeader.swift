//
//  NewStoryHeader.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/01.
//

import UIKit
import SnapKit
import Then

class NewStoryHeader: UIView {
    var cancelButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.systemGray, for: .normal)
        $0.titleLabel?.font = .myRegularSystemFont(ofSize: 14)
    }
    
    var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.systemTeal, for: .normal)
        $0.titleLabel?.font = .myRegularSystemFont(ofSize: 14)
    }
    
    var previousButton = UIButton().then {
        $0.setTitle("이전", for: .normal)
        $0.setTitleColor(.systemGray, for: .normal)
        $0.titleLabel?.font = .myRegularSystemFont(ofSize: 14)
        $0.isHidden = true
    }
    
    var saveButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.systemTeal, for: .normal)
        $0.titleLabel?.font = .myRegularSystemFont(ofSize: 14)
        $0.isHidden = true
    }
    
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
        
        previousButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalToSuperview().inset(18)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalToSuperview().inset(18)
        }
    }
    
    private func addSubviews() {
        addSubview(cancelButton)
        addSubview(nextButton)
        addSubview(previousButton)
        addSubview(saveButton)
    }
    
    private func setupButtonAction() {
        let cancelAction = UIAction { _ in
            self.viewController?.dismiss(animated: true, completion: nil)
        }
        cancelButton.addAction(cancelAction, for: .touchUpInside)
        
        let nextAction = UIAction { _ in
            self.newStoryVC?.moveStoryView()
        }
        nextButton.addAction(nextAction, for: .touchUpInside)
        
        let previousAction = UIAction { _ in
            self.newStoryVC?.undoStoryView()
        }
        previousButton.addAction(previousAction, for: .touchUpInside)
        
        let saveAction = UIAction { _ in
            self.newStoryVC?.saveStoryView()
        }
        saveButton.addAction(saveAction, for: .touchUpInside)
    }
}
