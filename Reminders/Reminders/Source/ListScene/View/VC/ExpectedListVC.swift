//
//  ExpectedListVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/05/07.
//

import UIKit

class ExpectedListVC: UIViewController {
    @IBOutlet weak var listTableView: UITableView!
    
    var topTitle: String?
    var topColor: UIColor?
    var cells: [String] = ["1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

extension ExpectedListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TotalListTVC.identifier) as? TotalListTVC else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.listTableView = listTableView
        cell.indexPath = indexPath
        cell.expectedListVC = self
        cell.isExpected = true
        cell.infoButton.tintColor = .red
        return cell
    }
}

extension ExpectedListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = .white
                
        let label = UILabel()
        label.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "오늘"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentCell = tableView.cellForRow(at: indexPath) as? TotalListTVC else {
            return
        }
        currentCell.reminderTextField.becomeFirstResponder()
        currentCell.infoButton.isHidden = false
        
        createCell(currentCell: currentCell ,indexPath: indexPath)
//        navigationItem.rightBarButtonItem = saveButton
    }
    
    func createCell(currentCell: TotalListTVC, indexPath: IndexPath) {
        if currentCell.getText && currentCell.count == 0 {
            if let text = currentCell.reminderTextField.text {
                print(text)
                cells.append(text)
                
                currentCell.isChecked.toggle()
                currentCell.checkToggle()
                currentCell.underLabel.text = "나의 목록"
                
                listTableView.beginUpdates()
                listTableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: 0)], with: .automatic)
                listTableView.endUpdates()
            }
            
            currentCell.count += 1
        }
    }
}

// MARK: - UI
extension ExpectedListVC {
    private func setUI() {
        setNavigation()
        setMenu()
        setTableView()
        setTableViewNib()
//        setGesture()
    }
    
    private func setNavigation() {
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
        listTableView.contentInsetAdjustmentBehavior = .never
        listTableView.separatorInset = UIEdgeInsets(top: 0, left: 58, bottom: 0, right: 0)
        listTableView.removeExtraCellLines()
        listTableView.tableHeaderView = nil
    }
    
    private func setTableViewNib() {
        let nib = UINib(nibName: "TotalListTVC", bundle: nil)
        listTableView.register(nib, forCellReuseIdentifier: TotalListTVC.identifier)
    }
    
//    private func setGesture() {
//        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        view.addGestureRecognizer(dismissTap)
//    }
}

// MARK: - Cell
extension ExpectedListVC {
//    private func registerTextField() {
//        var indexPath = IndexPath(row: cells.count, section: 0)
//        print("task.count: \(cells.count)")
//
//        guard let currentCell = listTableView.cellForRow(at: indexPath) as? TotalListTVC else {
//            return
//        }
//
//        if currentCell.reminderTextField.text?.count == 0 {
//            currentCell.reminderTextField.becomeFirstResponder()
//            currentCell.infoButton.isHidden = false
//        } else {
//            createCell(currentCell: currentCell, indexPath: indexPath)
//        }
//    }
}


// MARK: - Action
extension ExpectedListVC {
//    @objc
//    func handleTap() {
//        print("touchesBegan")
//        registerTextField()
//    }
}
