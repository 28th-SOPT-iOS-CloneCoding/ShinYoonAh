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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectTheaterTVC.identifier) as? SelectTheaterTVC else {
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    
}

extension OverlayVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return setSelectTheaterHeader()
        }
        return UIView.init(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 45
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        }
        return 200
    }
}

extension OverlayVC {
    private func setUI() {
        setTableView()
        setView()
    }
    
    private func setTableView() {
        bookingTableView.delegate = self
        bookingTableView.dataSource = self
        
        let nib = UINib(nibName: "SelectTheaterTVC", bundle: nil)
        bookingTableView.register(nib, forCellReuseIdentifier: SelectTheaterTVC.identifier)
    }
    
    private func setView() {
        backView.layer.cornerRadius = 20
        swipeButton.layer.cornerRadius = 3
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
