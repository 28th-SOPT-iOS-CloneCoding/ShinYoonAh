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
    
    private let navigationView = UIView()
    private let menuStackView = UIStackView()
    private let movieTableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    private let loadingIndicator = UIActivityIndicatorView()
    private let myRefreshControl = UIRefreshControl()
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.setPreferredSymbolConfiguration(.init(pointSize: 20,
                                                     weight: .light,
                                                     scale: .large),
                                                forImageIn: .normal)
        button.addTarget(self,
                         action: #selector(touchUpBack),
                         for: .touchUpInside)
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
        button.addTarget(self,
                         action: #selector(touchUpMenu),
                         for: .touchUpInside)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieData.removeAll()
        getPopularMovie(page: page)
        setConfigure()
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
            return comeoutHeader()
        } else if comeoutButton.isSelected && section != 0 {
            let headerView = UIView()
            let headerLabel = UILabel()
            
            headerView.backgroundColor = .white
            headerLabel.font = .systemFont(ofSize: 15)
            headerLabel.text = releaseDate[section - 1].replacingOccurrences(of: "-", with: ".")
            
            headerView.addSubview(headerLabel)
            headerLabel.snp.makeConstraints { make in
                make.bottom.equalTo(headerView.snp.bottom).inset(5)
                make.leading.equalTo(headerView.snp.leading).inset(10)
            }
            return headerView
        }
        return nowPlayingHeader()
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
    }
    
    private func beginBatchFetch() {
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            self.page += 1
            
            if self.chartMenuButton.isSelected {
                self.getPopularMovie(page: self.page)
            } else if self.arthouseMenuButton.isSelected {
                self.getTopRated(page: self.page)
            } else if self.comeoutButton.isSelected {
                self.getUpComing(page: self.page)
            }
            
            self.fetchingMore = false
            self.movieTableView.reloadData()
        })
    }
}

// MARK: - UI
extension MovieChartVC {
    private func setConfigure() {
        setNavigationBarLayout()
        setMenuBarLayout()
        setTableView()
        setTableViewNib()
        setRefreshControl()
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
}

// MARK: - Header Setting
extension MovieChartVC {
    private func nowPlayingHeader() -> UIView {
        let headerView = UIView()
        let bookingRateButton = UIButton()
        let eggRateButton = UIButton()
        let nowPlayingButton = UIButton()
        
        let bookingRateAction = UIAction { _ in
            self.changeHeaderButtonColor(selectedButton: bookingRateButton,
                                    unselectedButton1: eggRateButton,
                                    unselectedButton2: nowPlayingButton)
            self.movieData = self.movieData.sorted(by: {$0.voteAverage > $1.voteAverage})
            self.movieTableView.reloadData()
        }
        let eggRateAction = UIAction { _ in
            self.changeHeaderButtonColor(selectedButton: eggRateButton,
                                    unselectedButton1: bookingRateButton,
                                    unselectedButton2: nowPlayingButton)
            
            self.movieData = self.movieData.sorted(by: {$0.popularity > $1.popularity})
            self.movieTableView.reloadRows(
                at: self.movieTableView.indexPathsForVisibleRows ?? [],
                with: .none)
        }
        let nowPlayingAction = UIAction { _ in
            self.changeHeaderButtonColor(selectedButton: nowPlayingButton,
                                    unselectedButton1: bookingRateButton,
                                    unselectedButton2: eggRateButton)
            self.page = 1
            self.movieData.removeAll()
            self.getNowPlaying(page: self.page)
        }
        
        view.addSubview(headerView)
        headerView.addSubview(bookingRateButton)
        headerView.addSubview(eggRateButton)
        headerView.addSubview(nowPlayingButton)
        
        headerView.backgroundColor = .systemGray6
        
        bookingRateButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerView.snp.centerY)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        bookingRateButton.setHeaderButton(title: "예매율순")
        bookingRateButton.addAction(bookingRateAction, for: .touchUpInside)
        
        eggRateButton.snp.makeConstraints { make in
            make.centerY.equalTo(bookingRateButton)
            make.leading.equalTo(bookingRateButton.snp.trailing).offset(10)
        }
        eggRateButton.setHeaderButton(title: "Egg지수순")
        eggRateButton.addAction(eggRateAction, for: .touchUpInside)
        
        nowPlayingButton.snp.makeConstraints { make in
            make.centerY.equalTo(bookingRateButton.snp.centerY)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        nowPlayingButton.setHeaderButton(title: "현재상영작보기")
        nowPlayingButton.addAction(nowPlayingAction, for: .touchUpInside)
        
        changeHeaderButtonColor(selectedButton: bookingRateButton,
                                unselectedButton1: eggRateButton,
                                unselectedButton2: nowPlayingButton)
        return headerView
    }
    
    private func comeoutHeader() -> UIView {
        let headerView = UIView()
        let comeoutButton = UIButton()
        let bookingRateButton = UIButton()
        
        let comeoutAction = UIAction { _ in
            self.changeHeaderButtonColor(selectedButton: comeoutButton,
                                    unselectedButton1: bookingRateButton,
                                    unselectedButton2: UIButton())
            self.movieData = self.movieData.sorted(by: {$0.releaseDate > $1.releaseDate})
            self.movieTableView.reloadData()
        }
        let bookingRateAction = UIAction { _ in
            self.changeHeaderButtonColor(selectedButton: bookingRateButton,
                                    unselectedButton1: comeoutButton,
                                    unselectedButton2: UIButton())
            print("도대체 이걸 어찌 구현..")
        }
        
        view.addSubview(headerView)
        headerView.addSubview(comeoutButton)
        headerView.addSubview(bookingRateButton)
        
        headerView.backgroundColor = .systemGray6

        comeoutButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerView.snp.centerY)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        comeoutButton.setHeaderButton(title: "개봉순")
        comeoutButton.addAction(comeoutAction, for: .touchUpInside)
        
        bookingRateButton.snp.makeConstraints { make in
            make.centerY.equalTo(comeoutButton)
            make.leading.equalTo(comeoutButton.snp.trailing).offset(10)
        }
        bookingRateButton.setHeaderButton(title: "예매율순")
        bookingRateButton.addAction(bookingRateAction, for: .touchUpInside)
        
        changeHeaderButtonColor(selectedButton: comeoutButton,
                                unselectedButton1: bookingRateButton,
                                unselectedButton2: UIButton())
        return headerView
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
    func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        
        page = 0
        movieData.removeAll()
        releaseDate.removeAll()
        
        movieTableView.reloadData()
    }
    
    // MARK: - GET Popular
    @objc
    func touchUpChartButton() {
        print("pressed Movie Chart ")
        changeButtonState(selectedButton: chartMenuButton,
                          unselectedButton1: arthouseMenuButton,
                          unselectedButton2: comeoutButton)
        page = 1
        movieData.removeAll()
        getPopularMovie(page: page)
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
        getTopRated(page: page)
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
        getUpComing(page: page)
        movieTableView.reloadData()
    }
}

// MARK: - Networking
extension MovieChartVC {
    private func getPopularMovie(page: Int) {
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
    
    private func getNowPlaying(page: Int) {
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
    
    private func getTopRated(page: Int) {
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
    
    private func getUpComing(page: Int) {
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
