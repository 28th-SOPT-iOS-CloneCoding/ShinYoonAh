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
    
    private let menuStackView = UIStackView()
    private let movieTableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    private let loadingIndicator = UIActivityIndicatorView()
    private let myRefreshControl = UIRefreshControl()
    
    lazy private var customNavigationBar = MovieChartCustomNavigationBar(navigationController: navigationController!)
    private let movieTableMainHeader = MovieTableMainHeader()
    private let movieTableSubHeader = MovieTableSubHeader()
    private let movieTableDateHeader = MovieTableDateHeader()
    
    private var chartMenuButton: UIButton = {
        let button = UIButton()
        button.setTitle("무비차트", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self,
                         action: #selector(touchUpChartButton),
                         for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    private var arthouseMenuButton: UIButton = {
        let button = UIButton()
        button.setTitle("아트하우스", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self,
                         action: #selector(touchUpArthouseButton),
                         for: .touchUpInside)
        return button
    }()
    private var comeoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("개봉예정", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self,
                         action: #selector(touchUpComeoutButton),
                         for: .touchUpInside)
        return button
    }()
    private var bookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(touchUpBooking), for: .touchUpInside)
        return button
    }()
    private lazy var topButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white.withAlphaComponent(0.8)
        button.layer.cornerRadius = 27
        button.layer.shadowColor  = UIColor.gray.cgColor
        button.layer.shadowOpacity = 1.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 3
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 20,
                                                      weight: .light,
                                                      scale: .large),
                                                 forImageIn: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(touchUpTop), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieData.removeAll()
        fetchPopularMovie(page: page)
        setupConfigure()
    }
}

extension MovieChartVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if comeoutButton.isSelected {
            return releaseDate.count + 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comeoutButton.isSelected {
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
        
        if comeoutButton.isSelected {
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
        
        if arthouseMenuButton.isSelected {
            cell.setFormat(isArthouse: true)
        } else {
            cell.setFormat(isArthouse: false)
        }
        
        return cell
    }
}

extension MovieChartVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if comeoutButton.isSelected && section == 0 {
            return MovieTableSubHeader()
        } else if comeoutButton.isSelected && section != 0 {
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
            
            if self.chartMenuButton.isSelected {
                self.fetchPopularMovie(page: self.page)
            } else if self.arthouseMenuButton.isSelected {
                self.fetchTopRated(page: self.page)
            } else if self.comeoutButton.isSelected {
                self.fetchUpComing(page: self.page)
            }
            
            self.fetchingMore = false
            self.movieTableView.reloadData()
        })
    }
}

// MARK: - UI
extension MovieChartVC {
    private func setupConfigure() {
        view.addSubview(customNavigationBar)
        
        customNavigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        setMenuBarLayout()
        setTableView()
        setTableViewNib()
        setRefreshControl()
        setScrollButtons()
    }
    
    // MARK: - MenuBar UIView custom
    private func setMenuBarLayout() {
        view.addSubview(menuStackView)
        menuStackView.addArrangedSubview(chartMenuButton)
        menuStackView.addArrangedSubview(arthouseMenuButton)
        menuStackView.addArrangedSubview(comeoutButton)
        
        menuStackView.axis = .horizontal
        menuStackView.distribution = .fillEqually
        menuStackView.alignment = .center
        menuStackView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
    }
    
    private func setTableView() {
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        movieTableView.backgroundColor = .systemGray6
        
        view.addSubview(movieTableView)
        movieTableView.snp.makeConstraints { make in
            make.top.equalTo(menuStackView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setTableViewNib() {
        let nib = UINib(nibName: "MovieTVC", bundle: nil)
        movieTableView.register(nib, forCellReuseIdentifier: MovieTVC.identifier)
    }
    
    private func setRefreshControl() {
        myRefreshControl.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            movieTableView.refreshControl = myRefreshControl
        } else {
            movieTableView.addSubview(myRefreshControl)
        }
    }
    
    // MARK: - UIButton custom
    private func setScrollButtons() {
        let smallTitleLabel = UILabel()
        let largeTitleLabel = UILabel()
        let imageView = UIImageView()
        
        view.addSubview(bookingButton)
        view.addSubview(topButton)
        bookingButton.addSubview(smallTitleLabel)
        bookingButton.addSubview(largeTitleLabel)
        bookingButton.addSubview(imageView)
        
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
        smallTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bookingButton.snp.top).offset(13)
            make.leading.equalTo(bookingButton.snp.leading).offset(25)
        }
        largeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(smallTitleLabel.snp.bottom).offset(1)
            make.leading.equalTo(smallTitleLabel.snp.leading)
        }
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(bookingButton.snp.centerY)
            make.leading.equalTo(largeTitleLabel.snp.trailing).offset(5)
            make.height.equalTo(24)
            make.width.equalTo(35)
        }
        
        bookingButton.backgroundColor = UIColor.systemPink.withAlphaComponent(0.7)
        bookingButton.layer.cornerRadius = 30
        
        smallTitleLabel.text = "빠르고 쉽게"
        smallTitleLabel.font = .boldSystemFont(ofSize: 10)
        smallTitleLabel.textColor = .white
        
        largeTitleLabel.text = "지금예매"
        largeTitleLabel.font = .boldSystemFont(ofSize: 16)
        largeTitleLabel.textColor = .white
        
        imageView.image = UIImage(systemName: "ticket")
        imageView.tintColor = .white
    }
}

// MARK: - Action
extension MovieChartVC {
    @objc
    func touchUpBooking() {
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: "OverlayVC") as? OverlayVC else { return }
        dvc.modalPresentationStyle = .overFullScreen
        present(dvc, animated: true, completion: nil)
    }
    
    @objc
    func touchUpTop() {
        movieTableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        self.isScrolled = false
    }
    
    @objc
    func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        
        page = 0
        movieData.removeAll()
        releaseDate.removeAll()
        
        movieTableView.reloadData()
    }
    
    // MARK: - objc가 UIView로 들어갈 수 있나? -> ViewModel같은걸 써서 제대로 관리해야할 듯
    // MARK: - GET Popular
    @objc
    func touchUpChartButton() {
        print("pressed Movie Chart ")
        changeButtonState(selectedButton: chartMenuButton,
                          unselectedButton1: arthouseMenuButton,
                          unselectedButton2: comeoutButton)
        page = 1
        movieData.removeAll()
        fetchPopularMovie(page: page)
        movieTableView.reloadData()
    }
    
    // MARK: - GET Top Rated
    @objc
    func touchUpArthouseButton() {
        print("pressed Art house ")
        changeButtonState(selectedButton: arthouseMenuButton,
                          unselectedButton1: chartMenuButton,
                          unselectedButton2: comeoutButton)
        page = 1
        movieData.removeAll()
        fetchTopRated(page: page)
        movieTableView.reloadData()
    }
    
    // MARK: - GET Upcoming
    @objc
    func touchUpComeoutButton() {
        print("pressed Come out ")
        changeButtonState(selectedButton: comeoutButton,
                          unselectedButton1: chartMenuButton,
                          unselectedButton2: arthouseMenuButton)
        page = 1
        movieData.removeAll()
        releaseDate.removeAll()
        fetchUpComing(page: page)
        movieTableView.reloadData()
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
