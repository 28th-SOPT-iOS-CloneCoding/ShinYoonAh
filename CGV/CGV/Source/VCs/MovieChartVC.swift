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
    var movieModel: MovieModel?
    var param: MovieRequest = MovieRequest.init(GeneralAPI.apiKey, "ko", 1)
    
    private var movieData: [MovieResponse] = []
    
    private let navigationView = UIView()
    private let menuStackView = UIStackView()
    private let movieTableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView()
    
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
        getPopularMovie()
        setConfigure()
    }
}

extension MovieChartVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTVC.identifier) as? MovieTVC else {
            return UITableViewCell()
        }
        let data = movieData[indexPath.row]
        cell.setData(posterImage: data.posterPath,
                     title: data.originalTitle,
                     eggRate: data.popularity,
                     bookingRate: data.voteAverage,
                     releaseData: data.releaseDate,
                     isAdult: data.adult)
        cell.selectionStyle = .gray
        return cell
    }
}

extension MovieChartVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if comeoutButton.isSelected {
            return comeoutHeader()
        }
        return nowPlayingHeader()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
}

// MARK: - UI
extension MovieChartVC {
    private func setConfigure() {
        setNavigationBarLayout()
        setMenuBarLayout()
        setTableView()
        setTableViewNib()
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
    
    // MARK: - Header Setting
    private func nowPlayingHeader() -> UIView {
        let headerView = UIView()
        let bookingRateButton = UIButton()
        let eggRateButton = UIButton()
        let nowPlayingButton = UIButton()
        
        let bookingRateAction = UIAction { _ in
            self.changeHeaderButtonColor(selectedButton: bookingRateButton,
                                    unselectedButton1: eggRateButton,
                                    unselectedButton2: nowPlayingButton)
        }
        let eggRateAction = UIAction { _ in
            self.changeHeaderButtonColor(selectedButton: eggRateButton,
                                    unselectedButton1: bookingRateButton,
                                    unselectedButton2: nowPlayingButton)
        }
        let nowPlayingAction = UIAction { _ in
            self.changeHeaderButtonColor(selectedButton: nowPlayingButton,
                                    unselectedButton1: bookingRateButton,
                                    unselectedButton2: eggRateButton)
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
        }
        let bookingRateAction = UIAction { _ in
            self.changeHeaderButtonColor(selectedButton: bookingRateButton,
                                    unselectedButton1: comeoutButton,
                                    unselectedButton2: UIButton())
        }
        
        view.addSubview(headerView)
        headerView.addSubview(comeoutButton)
        headerView.addSubview(bookingRateButton)
        
        headerView.backgroundColor = .systemGray6

        comeoutButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerView.snp.centerY)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        comeoutButton.setHeaderButton(title: "개봉일순")
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
    
    // MARK: - GET Popular
    @objc
    func touchUpChartButton() {
        print("pressed Movie Chart ")
        changeButtonState(selectedButton: chartMenuButton,
                          unselectedButton1: arthouseMenuButton,
                          unselectedButton2: comeoutButton)
        // MARK: - TODO: TableView reload
        getPopularMovie()
        movieTableView.reloadData()
    }
    
    // MARK: - GET Top Rated
    @objc
    func touchUpArthouseButton() {
        print("pressed Art house ")
        changeButtonState(selectedButton: arthouseMenuButton,
                          unselectedButton1: chartMenuButton,
                          unselectedButton2: comeoutButton)
        // MARK: - TODO: TableView reload
        movieTableView.reloadData()
    }
    
    // MARK: - GET Upcoming
    @objc
    func touchUpComeoutButton() {
        print("pressed Come out ")
        changeButtonState(selectedButton: comeoutButton,
                          unselectedButton1: chartMenuButton,
                          unselectedButton2: arthouseMenuButton)
        // MARK: - TODO: TableView reload
        movieTableView.reloadData()
    }
}

// MARK: - Networking
extension MovieChartVC {
    func getPopularMovie() {
        loadingIndicator.startAnimating()
        print(param)
        authProvider.request(.popular(param: param)) { response in
            self.loadingIndicator.stopAnimating()
            switch response {
                case .success(let result):
                    do {
                        self.movieModel = try result.map(MovieModel.self)
                        self.movieData.removeAll()
                        self.movieData.append(contentsOf: self.movieModel?.results ?? [])
                        print("movieData 받아옴")
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
