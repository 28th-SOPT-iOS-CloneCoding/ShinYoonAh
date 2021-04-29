//
//  TotalListVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/23.
//

import UIKit

class TotalListVC: UIViewController {
    @IBOutlet weak var listTableView: UITableView!
    
    var topTitle: String?
    var topColor: UIColor?
    var sections: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.topItem?.title = ""
    }
}

extension TotalListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TotalListTVC.identifier) as? TotalListTVC else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension TotalListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
                
        let label = UILabel()
        label.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = sections[section]
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .systemBlue
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 1))
        headerView.backgroundColor = .systemGray4
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentCell = tableView.cellForRow(at: indexPath) as? TotalListTVC else {
            return
        }
        currentCell.reminderTextField.becomeFirstResponder()
        currentCell.infoButton.isHidden = false
    }
}

// MARK: - UI
extension TotalListVC {
    private func setUI() {
        setNavigation()
        setMenu()
        setTableView()
        setTableViewNib()
    }
    
    private func setNavigation() {
        self.navigationController?.navigationBar.topItem?.title = "목록"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = topTitle
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : topColor ?? .black]
        self.navigationController?.navigationBar.sizeToFit()
    }
    
    private func setMenu() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "미리 알림 선택...", image: UIImage(systemName: "checkmark.circle"), handler: { (_) in
                }),
                UIAction(title: "완료된 항목 가리기", image: UIImage(systemName: "eye.slash"), handler: { (_) in
                })
            ]
        }

        var demoMenu: UIMenu {
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: demoMenu)
    }
    
    private func setTableView() {
        listTableView.delegate = self
        listTableView.dataSource = self
    }
    
    private func setTableViewNib() {
        let nib = UINib(nibName: "TotalListTVC", bundle: nil)
        listTableView.register(nib, forCellReuseIdentifier: TotalListTVC.identifier)
    }
}
