//
//  MovieChartVC.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/11.
//

import UIKit
import SnapKit

class MovieChartVC: UIViewController {
    lazy private var movieViewModel = MovieChartViewModel(tableView: movieTableView)
    lazy private var customNavigationBar = MovieChartCustomNavigationBar(navigationController: navigationController!)
    lazy private var bookingButton = EarlyReservationButton(storyboard: storyboard!, rootController: self)
    lazy private var topButton = ScrollToTopButton(tableView: movieTableView)
    lazy private var movieTableMainHeader = MovieTableMainHeader(with: movieTableView, model: movieViewModel)
    lazy private var menuBar = MovieChartMenuBar(tableView: movieTableView, model: movieViewModel)
    
    private let movieTableSubHeader = MovieTableSubHeader()
    private let movieTableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    private let myRefreshControl = UIRefreshControl()
    
    private var isScrolled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfigure()
        tableViewSetting()
    }
    
    override func viewWillLayoutSubviews() {
        customNavigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        menuBar.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        movieTableView.snp.makeConstraints { make in
            make.top.equalTo(menuBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        bookingButton.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(60)
            make.trailing.equalToSuperview().offset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        topButton.snp.makeConstraints { make in
            make.width.height.equalTo(55)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(55)
        }
    }
    
    private func setupConfigure() {
        view.addSubview(customNavigationBar)
        view.addSubview(menuBar)
        view.addSubview(movieTableView)
        view.addSubview(bookingButton)
        view.addSubview(topButton)
        
        setRefreshControl()
    }
    
    private func tableViewSetting() {
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        movieTableView.backgroundColor = .systemGray6

        let nib = UINib(nibName: "MovieTVC", bundle: nil)
        movieTableView.register(nib, forCellReuseIdentifier: MovieTVC.identifier)
    }
    
    private func setRefreshControl() {
        let refreshAction = UIAction { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.movieViewModel.page = 0
                self.movieViewModel.movieData.removeAll()
                self.movieViewModel.releaseDate.removeAll()
                self.movieTableView.reloadData()
                self.myRefreshControl.endRefreshing()
            }
        }
        myRefreshControl.addAction(refreshAction, for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            movieTableView.refreshControl = myRefreshControl
        } else {
            movieTableView.addSubview(myRefreshControl)
        }
    }
}

// MARK: - UITableViewDataSource
extension MovieChartVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if menuBar.comeoutButton.isSelected {
            return movieViewModel.releaseDate.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menuBar.comeoutButton.isSelected {
            if section == 0 {
                return 0
            }
            let date = movieViewModel.releaseDate[section - 1]
            return self.movieViewModel.movieData.filter{ $0.releaseDate == date }.count
        }
        return movieViewModel.movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTVC.identifier) as? MovieTVC else {
            return UITableViewCell()
        }
        
        if menuBar.comeoutButton.isSelected {
            if indexPath.section != 0 {
                let data: MovieResponse = movieViewModel.movieData.filter { $0.releaseDate == movieViewModel.releaseDate[indexPath.section - 1] }[indexPath.row]
                cell.setData(posterImage: data.posterPath ?? "",
                             title: data.title,
                             eggRate: data.popularity,
                             bookingRate: data.voteAverage,
                             releaseData: data.releaseDate,
                             isAdult: data.adult)
            }
        } else {
            let data = movieViewModel.movieData[indexPath.row]
            cell.setData(posterImage: data.posterPath ?? "",
                         title: data.title,
                         eggRate: data.popularity,
                         bookingRate: data.voteAverage,
                         releaseData: data.releaseDate,
                         isAdult: data.adult)
        }
        
        if menuBar.arthouseMenuButton.isSelected {
            cell.setFormat(isArthouse: true)
        } else {
            cell.setFormat(isArthouse: false)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MovieChartVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if menuBar.comeoutButton.isSelected && section == 0 {
            return movieTableSubHeader
        } else if menuBar.comeoutButton.isSelected && section != 0 {
            return MovieTableDateHeader(model: movieViewModel, section: section)
        }
        return movieTableMainHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 45
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if movieTableView.contentOffset.y > (movieTableView.contentSize.height - movieTableView.bounds.size.height) {
            print("끝에 도달")
            if !movieViewModel.fetchingMore {
                beginBatchFetch()
            }
        }
        
        if movieTableView.contentOffset.y > 150 {
            UIView.animate(withDuration: 0.3, animations: {
                self.bookingButton.transform = CGAffineTransform(translationX: 0, y: -100)
                self.topButton.transform = CGAffineTransform(translationX: 0, y: -120)
                self.isScrolled = true
            })
        }
        
        if movieTableView.contentOffset.y <= 0 && isScrolled {
            UIView.animate(withDuration: 0.3, animations: {
                self.bookingButton.transform = .identity
                self.topButton.transform = .identity
                self.isScrolled = false
            })
        }
    }
    
    private func beginBatchFetch() {
        movieViewModel.fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            self.movieViewModel.page += 1
            
            if self.menuBar.chartMenuButton.isSelected {
                self.movieViewModel.fetchPopularMovie(page: self.movieViewModel.page)
            } else if self.menuBar.arthouseMenuButton.isSelected {
                self.movieViewModel.fetchTopRated(page: self.movieViewModel.page)
            } else if self.menuBar.comeoutButton.isSelected {
                self.movieViewModel.fetchUpComing(page: self.movieViewModel.page)
            }
            
            self.movieViewModel.fetchingMore = false
            self.movieTableView.reloadData()
        })
    }
}
