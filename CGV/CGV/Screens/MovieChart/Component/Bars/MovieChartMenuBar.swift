//
//  MovieChartMenuBar.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/29.
//

import UIKit
import SnapKit
import Then

class MovieChartMenuBar: UIView {
    var chartMenuButton = UIButton().then {
        $0.setTitle("무비차트", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.isSelected = true
    }
    
    var arthouseMenuButton = UIButton().then {
        $0.setTitle("아트하우스", for: .normal)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
    }
    
    var comeoutButton = UIButton().then {
        $0.setTitle("개봉예정", for: .normal)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
    }
    
    private let menuStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .center
    }
    
    var movieViewModel: MovieChartService?
    var tableView: UITableView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupButtonAction()
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
    
    init(tableView: UITableView, model: MovieChartService) {
        super.init(frame: .zero)
        self.tableView = tableView
        self.movieViewModel = model
        addSubviews()
        setupButtonAction()
    }
    
    private func addSubviews() {
        addSubview(menuStackView)
        menuStackView.addArrangedSubview(chartMenuButton)
        menuStackView.addArrangedSubview(arthouseMenuButton)
        menuStackView.addArrangedSubview(comeoutButton)
    }
    
    private func setupButtonAction() {
        let chartAction = UIAction { _ in
            print("pressed Movie Chart ")
            self.changeButtonState(selectedButton: self.chartMenuButton,
                                   unselectedButton1: self.arthouseMenuButton,
                                   unselectedButton2: self.comeoutButton)
            self.movieViewModel?.page = 1
            self.movieViewModel?.movieData.removeAll()
            self.movieViewModel?.fetchPopularMovie(page: self.movieViewModel!.page)
            self.tableView?.reloadData()
        }
        chartMenuButton.addAction(chartAction, for: .touchUpInside)
        
        let arthouseAction = UIAction { _ in
            print("pressed Art house ")
            self.changeButtonState(selectedButton: self.arthouseMenuButton,
                                   unselectedButton1: self.chartMenuButton,
                                   unselectedButton2: self.comeoutButton)
            self.movieViewModel?.page = 1
            self.movieViewModel?.movieData.removeAll()
            self.movieViewModel?.fetchTopRated(page: self.movieViewModel!.page)
            self.tableView?.reloadData()
        }
        arthouseMenuButton.addAction(arthouseAction, for: .touchUpInside)
        
        let comeoutAction = UIAction { _ in
            print("pressed Come out ")
            self.changeButtonState(selectedButton: self.comeoutButton,
                                   unselectedButton1: self.chartMenuButton,
                                   unselectedButton2: self.arthouseMenuButton)
            self.movieViewModel?.page = 1
            self.movieViewModel?.movieData.removeAll()
            self.movieViewModel?.releaseDate.removeAll()
            self.movieViewModel?.fetchUpComing(page: self.movieViewModel!.page)
            self.tableView?.reloadData()
        }
        comeoutButton.addAction(comeoutAction, for: .touchUpInside)
    }
}
