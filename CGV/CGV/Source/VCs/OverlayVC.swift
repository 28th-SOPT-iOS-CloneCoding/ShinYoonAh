//
//  OverlayVC.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/16.
//

import UIKit

class OverlayVC: UIViewController {
    @IBOutlet weak var swipeButton: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bookingTableView: UITableView!
    @IBOutlet weak var xmarkButton: UIButton!
    
    private var isClicked = false
    private var positionCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNotification()
    }
}

extension OverlayVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectTheaterTVC.identifier) as? SelectTheaterTVC else {
                return UITableViewCell()
            }
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTheaterTVC.identifier) as? DateTheaterTVC else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

extension OverlayVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return setSelectTheaterHeader()
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 45
        }
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && isClicked {
            let count = positionCount / 3
            
            if positionCount == 20 {
                return 483
            }
            
            if count == 1 {
                return 133
            } else if count == 3 {
                return 233
            } else if count == 4 {
                return 300
            }
            
            return CGFloat(133 + 50 * count)
        } else if indexPath.section == 0 && !isClicked {
            return 133
        }
        return 280
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

extension OverlayVC {
    private func setUI() {
        setTableView()
        setView()
        setButton()
    }
    
    private func setTableView() {
        bookingTableView.delegate = self
        bookingTableView.dataSource = self
        
        let selectNib = UINib(nibName: "SelectTheaterTVC", bundle: nil)
        let dateNib = UINib(nibName: "DateTheaterTVC", bundle: nil)
        bookingTableView.register(selectNib, forCellReuseIdentifier: SelectTheaterTVC.identifier)
        bookingTableView.register(dateNib, forCellReuseIdentifier: DateTheaterTVC.identifier)
    }
    
    private func setView() {
        backView.layer.cornerRadius = 20
        swipeButton.layer.cornerRadius = 3
    }
    
    private func setButton() {
        xmarkButton.addTarget(self, action: #selector(touchUpDismiss), for: .touchUpInside)
    }
    
    // MARK: - HeaderView Setting
    private func setSelectTheaterHeader() -> UIView {
        let headerView = UIView()
        let headerLabel = UILabel()
        
        headerView.backgroundColor = .white
        headerLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        headerLabel.text = "극장선택"
        
        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.bottom.equalTo(headerView.snp.bottom).inset(3)
            make.leading.equalTo(headerView.snp.leading).inset(15)
        }
        return headerView
    }
}

// MARK: - Action
extension OverlayVC {
    @objc
    func touchUpDismiss() {
        print("dismiss")
        
    }
}

extension OverlayVC: showupAlertDeleagate {
    func showupAlertToLookup(title: String?, content: String) {
        if let title = title {
            makeAlert(title: title, message: content)
        }
    }
}

// MARK: Notification
extension OverlayVC {
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(cellIncrease), name: NSNotification.Name("increaseCell"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cellDecrease), name: NSNotification.Name("decreaseCell"), object: nil)
    }
    
    @objc
    func cellIncrease(_ notification: Notification) {
        print("increase")
        isClicked = true
        positionCount = notification.object as! Int
        bookingTableView.beginUpdates()
        bookingTableView.endUpdates()
    }
    
    @objc
    func cellDecrease() {
        print("decrease")
        isClicked = false
        bookingTableView.beginUpdates()
        bookingTableView.endUpdates()
    }
}
