//
//  MovieChartVC.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/11.
//

import UIKit
import SnapKit

class MovieChartVC: UIViewController {
    private let navigationView = UIView()
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.setPreferredSymbolConfiguration(.init(pointSize: 20, weight: .regular, scale: .large), forImageIn: .normal)
        button.addTarget(self, action: #selector(touchUpBack), for: .touchUpInside)
        return button
    }()
    private var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        button.tintColor = .black
        button.setPreferredSymbolConfiguration(.init(pointSize: 20, weight: .regular, scale: .large), forImageIn: .normal)
        button.addTarget(self, action: #selector(touchUpMenu), for: .touchUpInside)
        return button
    }()
    private var backLabel: UILabel = {
        let label = UILabel()
        label.text = "영화"
        label.textColor = .black
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
    }
}

// MARK: - UI
extension MovieChartVC {
    private func setConfigure() {
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        view.addSubview(navigationView)
        navigationView.addSubview(backButton)
        navigationView.addSubview(backLabel)
        navigationView.addSubview(menuButton)
        
        navigationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.centerY.equalTo(navigationView.snp.centerY)
            make.width.height.equalTo(30)
        }
        
        backLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(10)
            make.centerY.equalTo(backButton)
        }
        
        menuButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.centerY.equalTo(backButton)
        }
    }
}

// MARK: - Action
extension MovieChartVC {
    @objc
    func touchUpBack(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func touchUpMenu(){
        print("menu open")
    }
}
