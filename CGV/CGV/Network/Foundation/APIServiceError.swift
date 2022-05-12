//
//  APIServiceError.swift
//  CGV
//
//  Created by SHIN YOON AH on 2022/05/12.
//

import Foundation

enum APIServiceError: Error {
    case urlEncodingError
    case clientError(message: String?)
    case serverError
}
