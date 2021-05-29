//
//  MovieChartMenuBar.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/29.
//

import UIKit

class MovieChartMenuBar: UIView {
    var chartMenuButton: UIButton = {
        let button = UIButton()
        button.setTitle("무비차트", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.isSelected = true
        return button
    }()
    
    var arthouseMenuButton: UIButton = {
        let button = UIButton()
        button.setTitle("아트하우스", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }()
    
    var comeoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("개봉예정", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }()
    
    private let menuStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        menuStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    private func setupConfigure() {
        menuStackView.axis = .horizontal
        menuStackView.distribution = .fillEqually
        menuStackView.alignment = .center
        
        addSubviews()
        setupButtonAction()
    }
    
    private func addSubviews() {
        addSubview(menuStackView)
        menuStackView.addArrangedSubview(chartMenuButton)
        menuStackView.addArrangedSubview(arthouseMenuButton)
        menuStackView.addArrangedSubview(comeoutButton)
    }
    
    // MARK: - MovieData 관련 ViewModel 생성
    private func setupButtonAction() {
        let chartAction = UIAction { _ in
            print("pressed Movie Chart ")
            self.changeButtonState(selectedButton: self.chartMenuButton,
                                   unselectedButton1: self.arthouseMenuButton,
                                   unselectedButton2: self.comeoutButton)
//            page = 1
//            movieData.removeAll()
//            fetchPopularMovie(page: page)
//            movieTableView.reloadData()
        }
        chartMenuButton.addAction(chartAction, for: .touchUpInside)
        
        let arthouseAction = UIAction { _ in
            print("pressed Art house ")
            self.changeButtonState(selectedButton: self.arthouseMenuButton,
                                   unselectedButton1: self.chartMenuButton,
                                   unselectedButton2: self.comeoutButton)
//            page = 1
//            movieData.removeAll()
//            fetchTopRated(page: page)
//            movieTableView.reloadData()
        }
        arthouseMenuButton.addAction(arthouseAction, for: .touchUpInside)
        
        let comeoutAction = UIAction { _ in
            print("pressed Come out ")
            self.changeButtonState(selectedButton: self.comeoutButton,
                                   unselectedButton1: self.chartMenuButton,
                                   unselectedButton2: self.arthouseMenuButton)
//            page = 1
//            movieData.removeAll()
//            releaseDate.removeAll()
//            fetchUpComing(page: page)
//            movieTableView.reloadData()
        }
        comeoutButton.addAction(comeoutAction, for: .touchUpInside)
    }
}
