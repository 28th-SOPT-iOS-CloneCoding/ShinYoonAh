//
//  MovieChartViewModel.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/29.
//

import UIKit
import Moya

class MovieChartViewModel {
    private let authProvider = MoyaProvider<MovieServices>(plugins: [NetworkLoggerPlugin(verbose: true)])
    private var movieModel: MovieModel?

    private let loadingIndicator = UIActivityIndicatorView()
    private var movieTableView = UITableView()
    
    var movieData: [MovieResponse] = []
    var releaseDate: [String] = []
    var page = 1
    var fetchingMore = false
    
    init(tableView: UITableView) {
        movieTableView = tableView
        movieData.removeAll()
        fetchPopularMovie(page: page)
    }
    
    // MARK: - GET Popular
    func fetchPopularMovie(page: Int) {
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
    func fetchNowPlaying(page: Int) {
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
    func fetchTopRated(page: Int) {
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
    func fetchUpComing(page: Int) {
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
