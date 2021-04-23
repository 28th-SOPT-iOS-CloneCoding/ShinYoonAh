//
//  EditVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/16.
//

import UIKit

class EditVC: UIViewController {
    @IBOutlet weak var mainTableView: UITableView!
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "완료",
            style: .plain,
            target: self,
            action: #selector(touchUpSave(_:)))
        return button
    }()
    lazy var addGroupButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "그룹 추가",
            style: .plain,
            target: self,
            action: #selector(touchUpAddGroup(_:)))
        button.isEnabled = false
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
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        return toolbar
    }()
    
    let bottomView = UIView()
    let toolBarSeparator = UIView()
    
    var items: [UIBarButtonItem] = []
    var lists: [String] = ["나의 목록", "너의 목록", "클론코딩", "우와재밌다", "우와", "한다"]
    var menus: [String] = ["오늘", "예정", "전체"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension EditVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditTopTVC.identifier) as? EditTopTVC else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.setConfigure(title: menus[indexPath.row])
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditBottomTVC.identifier) as? EditBottomTVC else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setLists(title: lists[indexPath.row])
        return cell
    }
}

extension EditVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "나의 목록"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 8, y: 0, width: 250, height: 22)
        myLabel.font = UIFont.boldSystemFont(ofSize: 24)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

        let headerView = UIView()
        headerView.addSubview(myLabel)

        return headerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = mainTableView.contentOffset.y
        if offset < -50 {
            print("닿음")
            toolBar.backgroundColor = UIColor.reminderGray.withAlphaComponent(0.95)
            toolBar.setShadowImage(UIImage(ciImage: CIImage(color: CIColor.init(red: 0, green: 0, blue: 0))), forToolbarPosition: .any)
            toolBarSeparator.isHidden = false
        } else {
            toolBar.backgroundColor = UIColor.clear
            toolBarSeparator.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let sectionTo = sourceIndexPath.section
        let sectionFrom = destinationIndexPath.section
        
        if sectionTo == 0  {
            if sectionTo == sectionFrom {
                menus.swapAt(sourceIndexPath.row, destinationIndexPath.row)
                print(menus)
            }
        } else {
            if sectionTo == sectionFrom {
                lists.swapAt(sourceIndexPath.row, destinationIndexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            return .none
        } else {
            return .delete
        }
    }
}

// MARK: - UI
extension EditVC {
    private func setUI() {
        setNavigationBar()
        setToolbarItem()
        setTableView()
        setTableViewNib()
        setView()
    }
    
    private func setNavigationBar() {
        self.navigationItem.rightBarButtonItem = self.editButton
        
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchBar.placeholder = "검색"
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController?.searchBar.isUserInteractionEnabled = false
    }
    
    private func setToolbarItem() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        items.append(addGroupButton)
        items.append(flexibleSpace)
        items.append(addListButton)
        
        toolBar.setItems(items, animated: true)
    }
    
    private func setTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.backgroundColor = .reminderGray
        mainTableView.isEditing = true
        mainTableView.separatorInset = .init(top: 0, left: 90, bottom: 0, right: 0)
    }
    
    // 바꾸자
    private func setTableViewNib() {
        let topNib = UINib(nibName: "EditTopTVC", bundle: nil)
        mainTableView.register(topNib, forCellReuseIdentifier: EditTopTVC.identifier)
        
        let bottomNib = UINib(nibName: "EditBottomTVC", bundle: nil)
        mainTableView.register(bottomNib, forCellReuseIdentifier: EditBottomTVC.identifier)
    }
    
    private func setView() {
        view.backgroundColor = .reminderGray
        
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        bottomView.backgroundColor = UIColor.reminderGray.withAlphaComponent(0.95)
        
        view.addSubview(toolBarSeparator)
        toolBarSeparator.translatesAutoresizingMaskIntoConstraints = false
        toolBarSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolBarSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolBarSeparator.bottomAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        toolBarSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        toolBarSeparator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        if mainTableView.rowHeight >= (UIScreen.main.bounds.size.height - 200) {
            print("작음")
            toolBar.backgroundColor = UIColor.reminderGray.withAlphaComponent(0.95)
            toolBarSeparator.isHidden = false
        } else {
            print("큼")
            toolBar.backgroundColor = .clear
            toolBarSeparator.isHidden = true
        }
    }
}

// MARK: - Action
extension EditVC {
    @objc
    private func touchUpSave(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func touchUpAddGroup(_ sender: Any) {
  
    }

    @objc
    private func touchUpAddList(_ sender: Any) {
        guard let dvc = storyboard?.instantiateViewController(identifier: "NewListVC") as? NewListVC else { return }
        dvc.saveList = { title in
            self.lists.append(title)
            self.mainTableView.reloadData()
        }
        present(dvc, animated: true, completion: nil)
    }
}
