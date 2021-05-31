//
//  CreateStoryView.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/31.
//

import UIKit
import SnapKit

class CreateStoryView: UIView {
    private var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 70,
                                                     weight: .ultraLight,
                                                     scale: .large),
                                                forImageIn: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    private var startLabel: UILabel = {
        let label = UILabel()
        label.text = "+를 눌러서 새 이야기를 시작하세요"
        label.font = .myRegularSystemFont(ofSize: 15)
        label.textColor = .systemGray2
        return label
    }()
    
    private var viewController: UIViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(root viewController: UIViewController) {
        super.init(frame: .zero)
        self.viewController = viewController
        addSubviews()
        setupButtonAction()
    }
    
    override func layoutSubviews() {
        plusButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(10)
            make.height.width.equalTo(80)
        }
        
        startLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(plusButton.snp.bottom).offset(50)
            make.bottom.equalToSuperview()
        }
    }
    
    private func addSubviews() {
        addSubview(plusButton)
        addSubview(startLabel)
    }
    
    private func setupButtonAction() {
        let plusAction = UIAction { _ in
            guard let vc = self.viewController?.storyboard?.instantiateViewController(withIdentifier: "NewStoryVC") as? NewStoryVC else { return }
            vc.modalPresentationStyle = .fullScreen
            self.viewController?.present(vc, animated: true, completion: nil)
        }
        plusButton.addAction(plusAction, for: .touchUpInside)
    }
}
