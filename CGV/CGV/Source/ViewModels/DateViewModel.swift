//
//  DateViewModel.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/06/05.
//

import Foundation

class DateViewModel {
    var dates: [String] = []
    var days: [String] = []
    var realDate: [Date] = []
    var time: [String] = ["전체", "오전", "오후", "18시이후", "심야"]
    
    init() {
        setupDateArray()
    }
    
    private func setupDateArray() {
        let todayDate = Date()
        let calendar = Calendar.current
        let format = DateFormatter()
        let dayFormat = DateFormatter()
        
        dayFormat.locale = Locale(identifier: "ko_KR")
        format.dateFormat = "d"
        dayFormat.dateFormat = "EEEEE"
        
        for i in 0..<14 {
            let day = calendar.date(byAdding: .day, value: i, to: todayDate)!
            if i == 0 {
                days.append("오늘")
            } else if i == 1 {
                days.append("내일")
            } else {
                days.append(dayFormat.string(from: day))
            }
            dates.append(format.string(from: day))
            realDate.append(day)
        }
    }
}
