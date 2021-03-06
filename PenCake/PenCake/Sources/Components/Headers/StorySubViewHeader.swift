//
//  StorySubViewHeader.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/31.
//

import UIKit
import SnapKit
import Then

class StorySubViewHeader: UIView {
    private var cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.systemGray, for: .normal)
        $0.titleLabel?.font = .myRegularSystemFont(ofSize: 14)
    }
    
    private var saveButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.systemTeal, for: .normal)
        $0.titleLabel?.font = .myRegularSystemFont(ofSize: 14)
    }
    
    var titleButton = UIButton().then {
        $0.titleLabel?.font = .myRegularSystemFont(ofSize: 14)
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    private var isTitleView = false
    private var viewController: UIViewController?
    private var createContentVC: CreateContentVC?
    private var changeTitleVC: ChangeTitleVC?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(root viewController: ChangeTitleVC) {
        super.init(frame: .zero)
        self.changeTitleVC = viewController
        setupConfigure()
        isTitleView = true
    }
    
    init(root viewController: UIViewController, embed createContentVC: CreateContentVC) {
        super.init(frame: .zero)
        self.viewController = viewController
        self.createContentVC = createContentVC
        setupConfigure()
    }
    
    override func layoutSubviews() {
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalToSuperview().inset(18)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalToSuperview().inset(18)
        }
        
        titleButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.size.width - 100)
        }
    }
    
    private func setupConfigure() {
        titleButton.isHidden = true
        
        addSubviews()
        setupButtonAction()
    }
    
    private func addSubviews() {
        addSubview(cancelButton)
        addSubview(titleButton)
        addSubview(saveButton)
    }
    
    private func setupButtonAction() {
        let cancelAction = UIAction { _ in
            if self.isTitleView {
                self.changeTitleVC?.dismiss(animated: true, completion: nil)
            } else {
                self.createContentVC?.didClickCancel()
            }
        }
        cancelButton.addAction(cancelAction, for: .touchUpInside)
        
        let saveAction = UIAction { _ in
            if self.isTitleView {
                self.changeTitleVC?.saveTitle()
            } else {
                self.createContentVC?.saveEditContent()
                self.viewController?.dismiss(animated: true, completion: nil)
            }
        }
        saveButton.addAction(saveAction, for: .touchUpInside)
        
        let titleAction = UIAction { _ in
            self.createContentVC?.backToOriginalPosition()
        }
        titleButton.addAction(titleAction, for: .touchUpInside)
    }
}
