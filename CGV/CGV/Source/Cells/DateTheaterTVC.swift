//
//  DateTheaterTVC.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/18.
//

import UIKit

class DateTheaterTVC: UITableViewCell {
    static let identifier = "DateTheaterTVC"

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    
    private var formatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
// MARK: - UI
extension DateTheaterTVC {
    private func setUI() {
        setFormatter()
        setLabel()
    }
    
    private func setFormatter() {
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyy.M.dd (EEEEE)"
    }
    
    private func setLabel() {
        headerLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        headerLabel.text = "날짜/시간"
        
        dateLabel.font = .systemFont(ofSize: 15)
        dateLabel.text = formatter.string(from: Date())
        
        todayLabel.font = .systemFont(ofSize: 15)
        todayLabel.text = "오늘"
        todayLabel.textColor = .systemBlue
    }
}
