//
//  EarlyReservationButton.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/29.
//

import UIKit
import SnapKit
import Then

class EarlyReservationButton: UIButton {
    private let smallTitleLabel = UILabel().then {
        $0.text = "빠르고 쉽게"
        $0.font = .boldSystemFont(ofSize: 10)
        $0.textColor = .white
    }
    
    private let largeTitleLabel = UILabel().then {
        $0.text = "지금예매"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .white
    }
    
    private let buttonImageView = UIImageView().then {
        $0.image = UIImage(systemName: "ticket")
        $0.tintColor = .white
    }
    
    private var storyboard: UIStoryboard?
    private var rootController: UIViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(storyboard: UIStoryboard, rootController: UIViewController) {
        super.init(frame: .zero)
        self.storyboard = storyboard
        self.rootController = rootController
        setupConfigure()
    }
    
    override func layoutSubviews() {
        smallTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(13)
            make.leading.equalTo(self.snp.leading).offset(25)
        }
        
        largeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(smallTitleLabel.snp.bottom).offset(1)
            make.leading.equalTo(smallTitleLabel.snp.leading)
        }
        
        buttonImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(largeTitleLabel.snp.trailing).offset(5)
            make.height.equalTo(24)
            make.width.equalTo(35)
        }
    }
    
    private func setupConfigure() {
        backgroundColor = UIColor.systemPink.withAlphaComponent(0.7)
        layer.cornerRadius = 30
        
        setupButtonAction()
        addSubviews([smallTitleLabel,
                     largeTitleLabel,
                     buttonImageView])
    }
    
    private func setupButtonAction() {
        let bookingAction = UIAction { _ in
            guard let dvc = self.storyboard?.instantiateViewController(withIdentifier: "OverlayVC") as? OverlayVC else { return }
            dvc.modalPresentationStyle = .overFullScreen
            self.rootController?.present(dvc, animated: true, completion: nil)
        }
        self.addAction(bookingAction, for: .touchUpInside)
    }
}
