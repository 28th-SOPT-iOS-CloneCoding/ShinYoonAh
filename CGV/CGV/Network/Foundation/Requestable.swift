//
//  Requestable.swift
//  CGV
//
//  Created by SHIN YOON AH on 2022/05/12.
//

import Foundation

protocol Requestable {
    var requestTimeOut: Float { get }
    
    func request<T: Decodable>(_ request: NetworkRequest) async throws -> T?
}
