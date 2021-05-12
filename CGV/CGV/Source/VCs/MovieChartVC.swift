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
    private let menuStackView = UIStackView()
    
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
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    private var chartMenuButton: UIButton = {
        let button = UIButton()
        button.setTitle("무비차트", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(touchUpChartButton), for: .touchUpInside)
        return button
    }()
    private var arthouseMenuButton: UIButton = {
        let button = UIButton()
        button.setTitle("아트하우스", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(touchUpArthouseButton), for: .touchUpInside)
        return button
    }()
    private var comeoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("개봉예정", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(touchUpComeoutButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
    }
}

// MARK: - UI
extension MovieChartVC {
    private func setConfigure() {
        setNavigationBarLayout()
        setMenuBarLayout()
    }
    
    private func setNavigationBarLayout() {
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
            make.top.equalTo(8)
        }
    }
    
    private func setMenuBarLayout() {
        view.addSubview(menuStackView)
        menuStackView.addArrangedSubview(chartMenuButton)
        menuStackView.addArrangedSubview(arthouseMenuButton)
        menuStackView.addArrangedSubview(comeoutButton)
        
        menuStackView.axis = .horizontal
        menuStackView.distribution = .fillEqually
        menuStackView.alignment = .center
        menuStackView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
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
    
    @objc
    func touchUpChartButton() {
        print("pressed Movie Chart ")
        changeButtonTextColor(selectedButton: chartMenuButton,
                              unselectedButton1: arthouseMenuButton,
                              unselectedButton2: comeoutButton)
    }
    
    @objc
    func touchUpArthouseButton() {
        print("pressed Art house ")
        changeButtonTextColor(selectedButton: arthouseMenuButton,
                              unselectedButton1: chartMenuButton,
                              unselectedButton2: comeoutButton)
    }
    
    @objc
    func touchUpComeoutButton() {
        print("pressed Come out ")
        changeButtonTextColor(selectedButton: comeoutButton,
                              unselectedButton1: chartMenuButton,
                              unselectedButton2: arthouseMenuButton)
    }
}
