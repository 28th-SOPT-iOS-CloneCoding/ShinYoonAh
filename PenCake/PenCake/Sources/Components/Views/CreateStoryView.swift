//
//  CreateStoryView.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/31.
//

import UIKit
import SnapKit
import Then

class CreateStoryView: UIView {
    private var plusButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.setPreferredSymbolConfiguration(.init(pointSize: 70,
                                                     weight: .ultraLight,
                                                     scale: .large),
                                                forImageIn: .normal)
        $0.tintColor = .systemGray2
    }
    
    private var startLabel = UILabel().then {
        $0.text = "+를 눌러서 새 이야기를 시작하세요"
        $0.font = .myRegularSystemFont(ofSize: 15)
        $0.textColor = .systemGray2
    }
    
    private var viewController: UIViewController?
    private var storypage: StoryPageVC?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(root viewController: UIViewController, page pageController: StoryPageVC) {
        super.init(frame: .zero)
        self.viewController = viewController
        self.storypage = pageController
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
            vc.storyPageVC = self.storypage
            self.viewController?.present(vc, animated: true, completion: nil)
        }
        plusButton.addAction(plusAction, for: .touchUpInside)
    }
}
