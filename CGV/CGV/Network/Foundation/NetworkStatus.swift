//
//  NetworkStatus.swift
//  CGV
//
//  Created by SHIN YOON AH on 2022/05/12.
//

import Foundation

enum NetworkStatus: Int {
    case okay = 200
    case badRequest = 400
    case unAuthorized = 401
    case notFound = 404
    case internalServerError = 500
    case unknown = 0
}
