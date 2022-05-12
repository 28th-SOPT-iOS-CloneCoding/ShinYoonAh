//
//  APIEnvironment.swift
//  CGV
//
//  Created by SHIN YOON AH on 2022/05/12.
//

import Foundation

enum APIEnvironment: String, CaseIterable {
    case development
    case production
}

extension APIEnvironment {
    var baseUrl: String {
        switch self {
        case .development:
            return "https://api.themoviedb.org/3"
        case .production:
            return ""
        }
    }
    
    var apiKey: String {
        return "b2289ad94f1bf785bc9d2e08e468e7ef"
    }
}
