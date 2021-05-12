//
//  Extension+Encodable.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/12.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any] {
      let data = try JSONEncoder().encode(self)
      guard let dictionary = try JSONSerialization.jsonObject(with: data, options:  .allowFragments) as? [String: Any] else {
        throw NSError()
      }
      return dictionary
    }
}
