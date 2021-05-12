//
//  MovieRequest.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/12.
//

import Foundation

struct MovieRequest: Codable {
    var apiKey: String
    var language: String
    var page: Int
    
    init(_ apiKey: String,_ language: String, _ page: Int) {
        self.apiKey = apiKey
        self.language = language
        self.page = page
    }
}
