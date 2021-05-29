//
//  MovieChartVC.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/11.
//

import UIKit
import SnapKit
import Moya

class MovieChartVC: UIViewController {
    private let authProvider = MoyaProvider<MovieServices>(plugins: [NetworkLoggerPlugin(verbose: true)])
    private var movieModel: MovieModel?
    
    private var movieData: [MovieResponse] = []
    private var releaseDate: [String] = []
    private var page = 1
    private var fetchingMore = false
    private var isScrolled = false
    
    lazy private var customNavigationBar = MovieChartCustomNavigationBar(navigationController: navigationController!)
    lazy private var bookingButton = EarlyReservationButton(storyboard: storyboard!, rootController: self)
    lazy private var topButton = ScrollToTopButton(tableView: movieTableView)
    private let menuBar = MovieChartMenuBar()
    private let movieTableMainHeader = MovieTableMainHeader()
    private let movieTableSubHeader = MovieTableSubHeader()
    private let movieTableDateHeader = MovieTableDateHeader()
    private let movieTableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    private let loadingIndicator = UIActivityIndicatorView()
    private let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieData.removeAll()
        fetchPopularMovie(page: page)
        setupConfigure()
        tableViewSetting()
    }
    
    private func setupConfigure() {
        view.addSubview(customNavigationBar)
        view.addSubview(menuBar)
        view.addSubview(movieTableView)
        view.addSubview(bookingButton)
        view.addSubview(topButton)
        
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
            self.myRefreshControl.endRefreshing()
            self.page = 0
            self.movieData.removeAll()
            self.releaseDate.removeAll()
            self.movieTableView.reloadData()
        }
        myRefreshControl.addAction(refreshAction, for: .touchUpInside)
        
        if #available(iOS 10.0, *) {
            movieTableView.refreshControl = myRefreshControl
        } else {
            movieTableView.addSubview(myRefreshControl)
        }
    }
}

extension MovieChartVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if menuBar.comeoutButton.isSelected {
            return releaseDate.count + 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menuBar.comeoutButton.isSelected {
            if section == 0 {
                return 0
            }
            let date = releaseDate[section - 1]
            return self.movieData.filter{ $0.releaseDate == date }.count
        }
        return movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTVC.identifier) as? MovieTVC else {
            return UITableViewCell()
        }
        
        if menuBar.comeoutButton.isSelected {
            if indexPath.section != 0 {
                let data: MovieResponse = movieData.filter { $0.releaseDate == releaseDate[indexPath.section - 1] }[indexPath.row]
                cell.setData(posterImage: data.posterPath ?? "",
                             title: data.title,
                             eggRate: data.popularity,
                             bookingRate: data.voteAverage,
                             releaseData: data.releaseDate,
                             isAdult: data.adult)
            }
        } else {
            let data = movieData[indexPath.row]
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

extension MovieChartVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if menuBar.comeoutButton.isSelected && section == 0 {
            return MovieTableSubHeader()
        } else if menuBar.comeoutButton.isSelected && section != 0 {
            return MovieTableDateHeader()
        }
        return MovieTableMainHeader()
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
            if !fetchingMore {
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
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            self.page += 1
            
            if self.menuBar.chartMenuButton.isSelected {
                self.fetchPopularMovie(page: self.page)
            } else if self.menuBar.arthouseMenuButton.isSelected {
                self.fetchTopRated(page: self.page)
            } else if self.menuBar.comeoutButton.isSelected {
                self.fetchUpComing(page: self.page)
            }
            
            self.fetchingMore = false
            self.movieTableView.reloadData()
        })
    }
}

// MARK: - Networking
extension MovieChartVC {
    // MARK: - GET Popular
    private func fetchPopularMovie(page: Int) {
        loadingIndicator.startAnimating()
        
        let param: MovieRequest = MovieRequest.init(GeneralAPI.apiKey, "ko", page)
        print(param)
        
        authProvider.request(.popular(param: param)) { response in
            self.loadingIndicator.stopAnimating()
            switch response {
                case .success(let result):
                    do {
                        self.movieModel = try result.map(MovieModel.self)
                        self.movieData.append(contentsOf: self.movieModel?.results ?? [])
                        self.movieData = self.movieData.sorted(by: {$0.voteAverage > $1.voteAverage})
                        print("popular movieData 받아옴")
                        self.movieTableView.reloadData()
                    } catch(let err) {
                        print(err.localizedDescription)
                    }
                case .failure(let err):
                    print(err.localizedDescription)
            }
        }
    }
    // MARK: - GET NowPlaying
    private func fetchNowPlaying(page: Int) {
        loadingIndicator.startAnimating()
        
        let param: MovieRequest = MovieRequest.init(GeneralAPI.apiKey, "ko", page)
        print(param)
        
        authProvider.request(.nowPlaying(param: param)) { response in
            self.loadingIndicator.stopAnimating()
            switch response {
                case .success(let result):
                    do {
                        self.movieModel = try result.map(MovieModel.self)
                        self.movieData.append(contentsOf: self.movieModel?.results ?? [])
                        print("now playing movieData 받아옴")
                        self.movieTableView.reloadRows(
                            at: self.movieTableView.indexPathsForVisibleRows ?? [],
                            with: .none)
                    } catch(let err) {
                        print(err.localizedDescription)
                    }
                case .failure(let err):
                    print(err.localizedDescription)
            }
        }
    }
    
    // MARK: - GET TopRated
    private func fetchTopRated(page: Int) {
        loadingIndicator.startAnimating()
        
        let param: MovieRequest = MovieRequest.init(GeneralAPI.apiKey, "ko", page)
        print(param)
        
        authProvider.request(.topRate(param: param)) { response in
            self.loadingIndicator.stopAnimating()
            switch response {
                case .success(let result):
                    do {
                        self.movieModel = try result.map(MovieModel.self)
                        self.movieData.append(contentsOf: self.movieModel?.results ?? [])
                        print("Top rated movieData 받아옴")
                        self.movieTableView.reloadData()
                    } catch(let err) {
                        print(err.localizedDescription)
                    }
                case .failure(let err):
                    print(err.localizedDescription)
            }
        }
    }
    
    // MARK: - GET UpComing
    private func fetchUpComing(page: Int) {
        loadingIndicator.startAnimating()
        
        let param: MovieRequest = MovieRequest.init(GeneralAPI.apiKey, "ko", page)
        print(param)
        
        authProvider.request(.upcoming(param: param)) { response in
            self.loadingIndicator.stopAnimating()
            switch response {
                case .success(let result):
                    do {
                        self.movieModel = try result.map(MovieModel.self)
                        self.movieData.append(contentsOf: self.movieModel?.results ?? [])
                        self.movieData = self.movieData.sorted(by: {$0.releaseDate > $1.releaseDate})
                        
                        for i in self.movieData {
                            self.releaseDate += [i.releaseDate]
                        }
                        let removedDuplicate: Set = Set(self.releaseDate)
                        self.releaseDate = removedDuplicate.sorted().reversed()
                        print(self.releaseDate.count)
                        
                        print("upcoming movieData 받아옴")
                        self.movieTableView.reloadData()
                    } catch(let err) {
                        print(err.localizedDescription)
                    }
                case .failure(let err):
                    print(err.localizedDescription)
            }
        }
    }
}
