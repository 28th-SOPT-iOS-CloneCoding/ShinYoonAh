//
//  showupAlertDeleagate.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/18.
//

import Foundation

protocol showupAlertDeleagate: AnyObject {
    func showupAlertToLookup(title: String?, content: String)
}
