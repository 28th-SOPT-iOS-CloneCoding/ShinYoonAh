//
//  ReminderMainBottomTVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/15.
//

import UIKit

class ReminderMainBottomTVC: UITableViewCell {
    static let identifier = "ReminderMainBottomTVC"

    @IBOutlet weak var listTableView: UITableView!
    
    var lists: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ReminderMainBottomTVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTVC.identifier) as? ListTVC else {
            return UITableViewCell()
        }
        return cell
    }
}

extension ReminderMainBottomTVC: UITableViewDelegate { }

// MARK: - UI
extension ReminderMainBottomTVC {
    private func setUI() {
        setView()
        setTableView()
        setTableViewNib()
    }
    
    private func setView() {
        backgroundColor = .reminderGray
    }
    
    private func setTableView() {
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.backgroundColor = .reminderGray
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        listTableView.tableHeaderView = UIView(frame: frame)
    }
    
    private func setTableViewNib() {
        let nib = UINib(nibName: "ListTVC", bundle: nil)
        listTableView.register(nib, forCellReuseIdentifier: ListTVC.identifier)
    }
}

// MARK: - Data
extension ReminderMainBottomTVC {
    func setLists(lists: [String]) {
        self.lists = lists
    }
}
