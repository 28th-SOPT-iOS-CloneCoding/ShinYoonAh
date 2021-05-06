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
    
    var delegate: PresentViewDelegate?
    
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
        cell.setLists(title: lists[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension ReminderMainBottomTVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "",
            handler: { _,_,_ in
                self.lists.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
        })
        delete.image = UIImage(systemName: "trash.fill")
        
        let info = UIContextualAction(style: .normal, title: "",
            handler: { _,_,_ in
                
        })
        info.image = UIImage(systemName: "info.circle.fill")
        info.backgroundColor = .lightGray
        
        let configuration = UISwipeActionsConfiguration(actions: [delete, info])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell Tapped")
        guard let dvc = UIStoryboard(name: "List", bundle: nil).instantiateViewController(identifier: "TodayListVC") as? TodayListVC else {
            return
        }
        dvc.topTitle = lists[indexPath.row]
        dvc.topColor = .systemBlue
        dvc.underText = lists[indexPath.row]
        delegate?.dvcPresentFromSecondView(dvc: dvc)
    }
}

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
        listTableView.separatorInset = .init(top: 0, left: 60, bottom: 0, right: 0)
        
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
        print(lists)
        self.lists = lists
        listTableView.reloadData()
    }
}
