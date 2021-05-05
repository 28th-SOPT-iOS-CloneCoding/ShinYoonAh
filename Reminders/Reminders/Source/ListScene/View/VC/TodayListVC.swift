//
//  TodayListVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/05/06.
//

import UIKit

class TodayListVC: UIViewController {
    private var newAlertButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.setTitle(" 새로운 미리 알림", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.sizeToFit()
        return button
    }()
    
    @IBOutlet weak var listTableView: UITableView!
    
    var topTitle: String?
    var topColor: UIColor?
    var tasks: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

extension TodayListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension TodayListVC: UITableViewDelegate {
    
}

// MARK: - UI
extension TodayListVC {
    private func setUI() {
        setNavigation()
        setTableView()
        setTableViewNib()
    }
    
    private func setNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = topTitle
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : topColor ?? .black]
        self.navigationController?.navigationBar.sizeToFit()
    }
    
    private func setTableView() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.contentInsetAdjustmentBehavior = .never
        listTableView.separatorInset = UIEdgeInsets(top: 0, left: 58, bottom: 0, right: 0)
    }
    
    private func setTableViewNib() {
        let nib = UINib(nibName: "TotalListTVC", bundle: nil)
        listTableView.register(nib, forCellReuseIdentifier: TotalListTVC.identifier)
    }
}
