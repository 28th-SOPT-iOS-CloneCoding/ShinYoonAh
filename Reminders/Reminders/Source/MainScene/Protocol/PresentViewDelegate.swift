//
//  PresentViewDelegate.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/23.
//

import Foundation

protocol PresentViewDelegate: class {
    func dvcPresentFromFirstView(dvc: TotalListVC)
    func dvcPresentFromSecondView(dvc: TodayListVC)
}
