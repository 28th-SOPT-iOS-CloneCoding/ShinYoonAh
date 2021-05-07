//
//  InfomationVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/05/07.
//

import UIKit

class InfomationVC: UIViewController {
    @IBOutlet weak var infoTableView: UITableView!
    
    private var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(touchUpCancel))
        return button
    }()
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "완료",
            style: .plain,
            target: self,
            action: #selector(touchUpAdd))
        return button
    }()
    
    var planTitle: String?
    var canSaved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension InfomationVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewAlertTVC.identifier) as? NewAlertTVC else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTVC.identifier) as? DetailTVC else {
            return UITableViewCell()
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension InfomationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
}

extension InfomationVC: UIAdaptivePresentationControllerDelegate {
    private func setUI() {
        setView()
        setNavigation()
        setTableView()
        setTableViewNib()
    }
    
    private func setView() {
        view.backgroundColor = .reminderGray
    }
    
    private func setNavigation() {
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "세부사항"
        navigationController?.navigationBar.backgroundColor = .reminderGray
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.presentationController?.delegate = self
        isModalInPresentation = true
    }
    
    private func setTableView() {
        infoTableView.dataSource =  self
        infoTableView.delegate = self
        infoTableView.backgroundColor = .reminderGray
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        infoTableView.tableHeaderView = UIView(frame: frame)
    }
    
    private func setTableViewNib() {
        let titleNib = UINib(nibName: "NewAlertTVC", bundle: nil)
        infoTableView.register(titleNib, forCellReuseIdentifier: NewAlertTVC.identifier)
        
        let detailNib = UINib(nibName: "DetailTVC", bundle: nil)
        infoTableView.register(detailNib, forCellReuseIdentifier: DetailTVC.identifier)
    }
}

// MARK: - Action
extension InfomationVC {
    @objc
    private func touchUpCancel() {
        if canSaved {
            let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let dismiss = UIAlertAction(title: "변경 사항 폐기", style: .destructive) { (_) in
                self.resignFirstResponder()
                self.dismiss(animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(dismiss)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    private func touchUpAdd() {
        print("add")
    }
}
