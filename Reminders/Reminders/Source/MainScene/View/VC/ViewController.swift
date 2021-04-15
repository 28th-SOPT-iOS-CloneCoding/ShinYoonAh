//
//  ViewController.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/11.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainTableView: UITableView!
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "편집",
            style: .plain,
            target: self,
            action: #selector(touchUpEdit(_:)))
        return button
    }()
    lazy var newAlertButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.setTitle(" 새로운 미리 알림", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.sizeToFit()
        return button
    }()
    lazy var addListButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "목록 추가",
            style: .plain,
            target: self,
            action: #selector(touchUpAddList(_:)))
        return button
    }()
    lazy var toolBar: UIToolbar = {
        let toolbar = UIToolbar()
        view.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 0).isActive = true
        toolbar.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 0).isActive = true
        toolbar.trailingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.trailingAnchor, multiplier: 0).isActive = true
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.isTranslucent = true
        toolbar.backgroundColor = .clear
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        return toolbar
    }()
    
    var items: [UIBarButtonItem] = []
    var lists: [String] = ["나의 목록", "너의 목록", "클론코딩"]
    var menus: [String] = ["전체", "오늘", "예정"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderMainTopTVC.identifier) as? ReminderMainTopTVC else {
                return UITableViewCell()
            }
            cell.setLists(lists: menus)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderMainBottomTVC.identifier) as? ReminderMainBottomTVC else {
            return UITableViewCell()
        }
        cell.setLists(lists: lists)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch menus.count {
            case 3: return 194
            case 2, 1: return 90
            default: return 0
            }
        }
        
        let defaultHeight = 49
        return CGFloat(defaultHeight + (61 * lists.count))
    }
}

// MARK: - UI
extension ViewController {
    private func setUI() {
        setNavigationBar()
        setToolbarItem()
        setTableView()
        setTableViewNib()
        setView()
        setButton()
    }
    
    private func setNavigationBar() {
        self.navigationItem.rightBarButtonItem = self.editButton
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchBar.placeholder = "검색"
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func setToolbarItem() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let leftButton = UIBarButtonItem(customView: newAlertButton)
        
        items.append(leftButton)
        items.append(flexibleSpace)
        items.append(addListButton)
        
        toolBar.setItems(items, animated: true)
    }
    
    private func setTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
        mainTableView.separatorColor = .clear
        mainTableView.backgroundColor = .reminderGray
    }
    
    private func setTableViewNib() {
        let topNib = UINib(nibName: "ReminderMainTopTVC", bundle: nil)
        mainTableView.register(topNib, forCellReuseIdentifier: ReminderMainTopTVC.identifier)
        
        let bottomNib = UINib(nibName: "ReminderMainBottomTVC", bundle: nil)
        mainTableView.register(bottomNib, forCellReuseIdentifier: ReminderMainBottomTVC.identifier)
    }
    
    private func setView() {
        view.backgroundColor = .reminderGray
    }
    
    private func setButton() {
        newAlertButton.addTarget(self, action: #selector(touchUpAddNewAlert(_:)), for: .touchUpInside)
    }
}

// MARK: - Action
extension ViewController {
    @objc
    private func touchUpEdit(_ sender: Any) {
  
    }
    
    @objc
    private func touchUpAddNewAlert(_ sender: Any) {
        guard let dvc = storyboard?.instantiateViewController(identifier: "NewAlertVC") as? NewAlertVC else { return }
        present(dvc, animated: true, completion: nil)
    }
    
    @objc
    private func touchUpAddList(_ sender: Any) {
        guard let dvc = storyboard?.instantiateViewController(identifier: "NewListVC") as? NewListVC else { return }
        present(dvc, animated: true, completion: nil)
    }
}
