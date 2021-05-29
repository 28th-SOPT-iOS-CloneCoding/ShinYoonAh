//
//  MovieChartCustomNavigationBar.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/29.
//

import UIKit
import SnapKit

class MovieChartCustomNavigationBar: UIView {
    private var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.setPreferredSymbolConfiguration(.init(pointSize: 20,
                                                     weight: .light,
                                                     scale: .large),
                                                forImageIn: .normal)
        return button
    }()
    
    private var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        button.tintColor = .black
        button.setPreferredSymbolConfiguration(.init(pointSize: 20,
                                                     weight: .light,
                                                     scale: .large),
                                               forImageIn: .normal)
        return button
    }()
    
    private var backLabel: UILabel = {
        let label = UILabel()
        label.text = "영화"
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    private var navigationController: UINavigationController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(navigationController: UINavigationController) {
        super.init(frame: CGRect.zero)
        self.navigationController = navigationController
        setupConfigure()
    }
    
    override func layoutSubviews() {
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(15)
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.equalTo(30)
        }
        
        backLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(10)
            make.centerY.equalTo(backButton)
        }
        
        menuButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(8)
        }
    }
    
    private func setupConfigure() {
        addSubviews()
        setupButtonAction()
    }
    
    private func addSubviews() {
        addSubview(backButton)
        addSubview(backLabel)
        addSubview(menuButton)
    }
    
    private func setupButtonAction() {
        let backAction = UIAction { _ in
            self.navigationController?.popViewController(animated: true)
        }
        backButton.addAction(backAction, for: .touchUpInside)
        
        let menuAction = UIAction { _ in
            print("이걸 어찌 구현해..?")
        }
        menuButton.addAction(menuAction, for: .touchUpInside)
    }
}
