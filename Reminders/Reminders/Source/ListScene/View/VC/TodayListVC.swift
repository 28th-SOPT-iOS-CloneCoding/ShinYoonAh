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
    
    let infoLabel = UILabel()
    let bottomView = UIView()
    let toolBarSeparator = UIView()
    
    @IBOutlet weak var listTableView: UITableView!
    
    var topTitle: String?
    var topColor: UIColor?
    var underText: String = "나의 목록"
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TotalListTVC.identifier) as? TotalListTVC else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.underLabel.text = underText
        cell.isChecked = true
        cell.getText = true
        cell.checkToggle()
        cell.pushCheck = {
            // 문제 있음
            self.tasks.remove(at: indexPath.row)
            self.listTableView.deleteRows(at: [indexPath], with: .fade)
        }
        return cell
    }
}

extension TodayListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
}

// MARK: - UI
extension TodayListVC {
    private func setUI() {
        setNavigation()
        setTableView()
        setTableViewNib()
        setToolbarItem()
        setView()
        setButton()
        setLabel()
        setGesture()
        
        if topTitle != "오늘" {
            setMenu()
        }
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
        listTableView.removeExtraCellLines()
        listTableView.tableHeaderView = nil
    }
    
    private func setTableViewNib() {
        let nib = UINib(nibName: "TotalListTVC", bundle: nil)
        listTableView.register(nib, forCellReuseIdentifier: TotalListTVC.identifier)
    }
    
    private func setToolbarItem() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let leftButton = UIBarButtonItem(customView: newAlertButton)
        
        toolBar.setItems([leftButton, flexibleSpace], animated: true)
    }
    
    private func setView() {
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        bottomView.backgroundColor = UIColor.white
        
        view.addSubview(toolBarSeparator)
        toolBarSeparator.translatesAutoresizingMaskIntoConstraints = false
        toolBarSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolBarSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolBarSeparator.bottomAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        toolBarSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        toolBarSeparator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        if listTableView.rowHeight >= (UIScreen.main.bounds.size.height - 200) {
            print("작음")
            toolBar.backgroundColor = UIColor.reminderGray.withAlphaComponent(0.95)
            toolBarSeparator.isHidden = false
        } else {
            print("큼")
            toolBar.backgroundColor = .clear
            toolBarSeparator.isHidden = true
        }
    }
    
    private func setButton() {
        newAlertButton.addTarget(self, action: #selector(touchUpAddNewAlert(_:)), for: .touchUpInside)
    }
    
    private func setLabel() {
        view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        infoLabel.text = "미리 알림 없음"
        infoLabel.textColor = .lightGray
        hideLabel()
    }
    
    private func hideLabel() {
        if tasks.isEmpty {
            infoLabel.isHidden = false
        } else {
            infoLabel.isHidden = true
        }
    }
    
    private func setGesture() {
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(dismissTap)
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
}

// MARK: - Cell
extension TodayListVC {
    private func createNewCell() {
        print("NewAlert!!")
        
        let indexPath = IndexPath(row: tasks.count, section: 0)
        
        tasks.append("1")
        hideLabel()
        
        listTableView.insertRows(at: [indexPath], with: .automatic)
        
        guard let currentCell = listTableView.cellForRow(at: indexPath) as? TotalListTVC else {
            return
        }
        currentCell.infoButton.isHidden = false
        currentCell.reminderTextField.becomeFirstResponder()
        
        currentCell.isCreated = true
    }
    
    private func cellMaker() {
        var indexPath = IndexPath()
        print("task.count: \(tasks.count)")
        
        // 처음 생성할 때
        if tasks.count == 0 {
            createNewCell()
        } else { // 그 다음부터
            indexPath = IndexPath(row: tasks.count-1, section: 0)
            guard let currentCell = listTableView.cellForRow(at: indexPath) as? TotalListTVC else {
                return
            }
            
            print(currentCell.isCreated)
            
            // 전에 셀 안에 Text가 채워져있으면
            if !(currentCell.isCreated) {
                createNewCell()
            } else {
                if currentCell.reminderTextField.text?.count == 0 {
                    tasks.removeLast()
                    currentCell.isCreated = false
                    
                    indexPath = IndexPath(row: tasks.count, section: 0)
                    
                    listTableView.deleteRows(at: [indexPath], with: .fade)
                    
                    hideLabel()
                } else {
                    createNewCell()
                }
            }
        }
    }
}

// MARK: - Action
extension TodayListVC {
    @objc
    private func touchUpAddNewAlert(_ sender: Any) {
        cellMaker()
    }
    
    @objc
    func handleTap() {
        print("touchesBegan")
        cellMaker()
    }
}
