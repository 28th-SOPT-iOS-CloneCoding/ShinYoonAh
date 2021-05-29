//
//  showupAlertDeleagate.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/18.
//

import Foundation

protocol showupAlertDelegate: AnyObject {
    func showupAlertToLookup(title: String?, content: String)
}
