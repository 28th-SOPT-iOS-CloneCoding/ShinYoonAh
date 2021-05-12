//
//  MovieRequest.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/12.
//

import Foundation

struct MovieRequest: Codable {
    var api_key: String
    var language: String
    var page: Int
    
    init(_ api_key: String,_ language: String, _ page: Int = 1) {
        self.api_key = api_key
        self.language = language
        self.page = page
    }
}
