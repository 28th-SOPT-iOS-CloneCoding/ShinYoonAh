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
    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    
    private var formatter = DateFormatter()
    
    private var dates: [String] = []
    private var days: [String] = []
    private var realDate: [Date] = []
    private var time: [String] = ["전체", "오전", "오후", "18시이후", "심야"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDate()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension DateTheaterTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dateCollectionView {
            return dates.count
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dateCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCVC.identifier, for: indexPath) as? DateCVC else {
                return UICollectionViewCell()
            }
            if indexPath.item == 0 {
                cell.isSelected = true
            } else {
                cell.isSelected = false
            }
            cell.labelConfigure(date: dates[indexPath.row], day: days[indexPath.row])
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TheaterDetailCVC.identifier, for: indexPath) as? TheaterDetailCVC else {
            return UICollectionViewCell()
        }
        if indexPath.item == 0 {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        cell.labelConfigure(position: time[indexPath.item])
        return cell
    }
}

extension DateTheaterTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        let label = UILabel()
        if collectionView == dateCollectionView {
            width = 40
            height = 70
        } else if collectionView == timeCollectionView {
            label.text = time[indexPath.row]
            label.sizeToFit()
            
            width = label.frame.width + 30
            height = 40
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == dateCollectionView {
            return 15
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == dateCollectionView {
            return UIEdgeInsets(top: 20, left: 15, bottom: 0, right: 15)
        }
        return UIEdgeInsets(top: 5, left: 20, bottom: 20, right: 20)
    }
}

extension DateTheaterTVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dateCollectionView {
            dateCollectionView.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            
            dateLabel.text = formatter.string(from: realDate[indexPath.item])
            
            if indexPath.item == 0 {
                todayLabel.text = "오늘"
            } else if indexPath.item == 1 {
                todayLabel.text = "내일"
            } else {
                todayLabel.text = ""
            }
        }
    }
}


// MARK: - UI
extension DateTheaterTVC {
    private func setUI() {
        setCollectionView()
        setFormatter()
        setLabel()
    }
    
    private func setCollectionView() {
        let dateNib = UINib(nibName: DateCVC.identifier, bundle: nil)
        let timeNib = UINib(nibName: TheaterDetailCVC.identifier, bundle: nil)
        
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        dateCollectionView.register(dateNib, forCellWithReuseIdentifier: DateCVC.identifier)
        
        timeCollectionView.delegate = self
        timeCollectionView.dataSource = self
        timeCollectionView.register(timeNib, forCellWithReuseIdentifier: TheaterDetailCVC.identifier)
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

// MARK: - Data
extension DateTheaterTVC {
    private func setDate() {
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
