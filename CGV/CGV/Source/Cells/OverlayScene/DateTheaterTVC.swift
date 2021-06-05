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
    @IBOutlet weak var lookUpButton: UIButton!
    
    private var formatter = DateFormatter()
    private var isButtonActive = true
    private var position = "강변"
    
    var viewModel = DateViewModel()
    var delegate: showupAlertDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewSetting()
        setupConfigure()
        setNotification()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func collectionViewSetting() {
        let dateNib = UINib(nibName: DateCVC.identifier, bundle: nil)
        let timeNib = UINib(nibName: TheaterDetailCVC.identifier, bundle: nil)
        
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        dateCollectionView.register(dateNib, forCellWithReuseIdentifier: DateCVC.identifier)
        
        timeCollectionView.delegate = self
        timeCollectionView.dataSource = self
        timeCollectionView.register(timeNib, forCellWithReuseIdentifier: TheaterDetailCVC.identifier)
    }
    
    private func setupConfigure() {
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyy.M.dd (EEEEE)"
        
        headerLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        headerLabel.text = "날짜/시간"
        
        dateLabel.font = .systemFont(ofSize: 15)
        dateLabel.text = formatter.string(from: Date())
        
        todayLabel.font = .systemFont(ofSize: 15)
        todayLabel.text = "오늘"
        todayLabel.textColor = .systemBlue
        
        lookUpButton.setTitle("조회하기", for: .normal)
        lookUpButton.setTitleColor(.white, for: .normal)
        lookUpButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        lookUpButton.layer.cornerRadius = 10
        lookUpButton.backgroundColor = .systemRed
        
        let lookupAction = UIAction { _ in
            if self.isButtonActive {
                print("complete")
                self.delegate?.showupAlertToLookup(title: "조회 완료", content: "CGV \(self.position) 점\n정보를 가져옵니다")
            } else {
                print("nope")
                self.delegate?.showupAlertToLookup(title: "경고", content: "극장을 선택해주세요.")
            }
        }
        lookUpButton.addAction(lookupAction, for: .touchUpInside)
    }
    
    func calculateCellSize(collectionView: UICollectionView, index: Int) -> CGSize {
        let label = UILabel()
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        switch collectionView {
        case dateCollectionView:
            width = 40
            height = 70
            return CGSize(width: width, height: height)
        case timeCollectionView:
            label.text = viewModel.time[index]
            label.sizeToFit()
            
            width = label.frame.width + 30
            height = 40
            return CGSize(width: width, height: height)
        default:
            return CGSize.zero
        }
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(buttonInActive), name: NSNotification.Name("buttonInActive"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(buttonActive), name: NSNotification.Name("buttonActive"), object: nil)
    }
    
    @objc
    func buttonInActive() {
        print("inactive")
        isButtonActive = false
        lookUpButton.backgroundColor = .darkGray
    }
    
    @objc
    func buttonActive(_ notification: Notification) {
        print("active")
        isButtonActive = true
        lookUpButton.backgroundColor = .systemRed
        position = notification.object as! String
    }
}

// MARK: - UICollectionViewDataSource
extension DateTheaterTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case dateCollectionView:
            return viewModel.dates.count
        case timeCollectionView:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case dateCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCVC.identifier, for: indexPath) as? DateCVC else {
                return UICollectionViewCell()
            }
            if indexPath.item == 0 {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            } else {
                cell.isSelected = false
            }
            cell.labelConfigure(date: viewModel.dates[indexPath.row], day: viewModel.days[indexPath.row])
            return cell
        case timeCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TheaterDetailCVC.identifier, for: indexPath) as? TheaterDetailCVC else {
                return UICollectionViewCell()
            }
            if indexPath.item == 0 {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            } else {
                cell.isSelected = false
            }
            cell.labelConfigure(position: viewModel.time[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DateTheaterTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateCellSize(collectionView: collectionView, index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case dateCollectionView:
            return 15
        case timeCollectionView:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case dateCollectionView:
            return UIEdgeInsets(top: 20, left: 15, bottom: 0, right: 15)
        case timeCollectionView:
            return UIEdgeInsets(top: 5, left: 20, bottom: 30, right: 20)
        default:
            return UIEdgeInsets.zero
        }
    }
}

// MARK: - UICollectionViewDelegate
extension DateTheaterTVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dateCollectionView {
            dateCollectionView.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            
            dateLabel.text = formatter.string(from: viewModel.realDate[indexPath.item])
            
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
