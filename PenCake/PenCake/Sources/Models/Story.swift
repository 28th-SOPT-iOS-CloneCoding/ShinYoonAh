//
//  Story.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/10.
//

import Foundation

struct Story {
    let id: UUID
    var title: String
    var subtitle: String
    var contents: [Content]
}

struct Content {
    var title: String
    var content: String?
    let date: Date
}
