//
//  MovieAPI.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/12.
//

import Foundation
import Moya

enum MovieAPI {
    case popular(param: MovieRequest)
    case topRate(param: MovieRequest)
    case upcoming(param: MovieRequest)
    case nowPlaying(param: MovieRequest)
}

extension MovieAPI: TargetType {
    public var baseURL: URL {
        return URL(string: GeneralAPI.baseURL)!
    }
    
    var path: String {
        switch self {
        case .popular(_):
            return "/movie/popular"
        case .topRate(_):
            return "/movie/top_rated"
        case .upcoming(_):
            return "/movie/upcoming"
        case .nowPlaying(_):
            return "/movie/popular"
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .popular,
                .topRate,
                .upcoming,
                .nowPlaying:
            return URLEncoding.default
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .popular,
                .topRate,
                .upcoming,
                .nowPlaying:
            return .get
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .popular(let param):
            return .requestParameters(parameters: try! param.asDictionary(), encoding:  URLEncoding.default)
        case .topRate(let param):
            return .requestParameters(parameters: try! param.asDictionary(), encoding:  URLEncoding.default)
        case .upcoming(let param):
            return .requestParameters(parameters: try! param.asDictionary(), encoding:  URLEncoding.default)
        case .nowPlaying(let param):
            return .requestParameters(parameters: try! param.asDictionary(), encoding:  URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
