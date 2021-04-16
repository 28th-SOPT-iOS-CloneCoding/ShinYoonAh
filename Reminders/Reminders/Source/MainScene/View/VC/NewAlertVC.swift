//
//  NewAlertVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/16.
//

import UIKit

class NewAlertVC: UIViewController {
    @IBOutlet weak var newAlertTableView: UITableView!
    
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(touchUpCancel))
        return button
    }()
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "추가",
            style: .plain,
            target: self,
            action: #selector(touchUpAdd))
        button.isEnabled = false
        return button
    }()
    
    var canSaved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNotification()
    }
}

extension NewAlertVC: UITableViewDataSource {
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

extension NewAlertVC: UITableViewDelegate { }

// MARK: - UI
extension NewAlertVC {
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
        navigationItem.title = "새로운 미리 알림"
        navigationController?.navigationBar.backgroundColor = .reminderGray
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.presentationController?.delegate = self
        isModalInPresentation = true
    
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        newAlertTableView.tableHeaderView = UIView(frame: frame)
    }
    
    private func setTableView() {
        newAlertTableView.dataSource =  self
        newAlertTableView.delegate = self
        newAlertTableView.backgroundColor = .reminderGray
    }
    
    private func setTableViewNib() {
        let titleNib = UINib(nibName: "NewAlertTVC", bundle: nil)
        newAlertTableView.register(titleNib, forCellReuseIdentifier: NewAlertTVC.identifier)
        
        let detailNib = UINib(nibName: "DetailTVC", bundle: nil)
        newAlertTableView.register(detailNib, forCellReuseIdentifier: DetailTVC.identifier)
    }
}

extension NewAlertVC: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
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
}

// MARK: - Action
extension NewAlertVC {
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
    
    @objc
    func saveAction() {
        if canSaved {
            canSaved = false
            addButton.isEnabled = false
        } else {
            canSaved = true
            addButton.isEnabled = true
        }
    }
}

// MARK: - Notification
extension NewAlertVC {
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveAction), name: NSNotification.Name("Save"), object: nil)
    }
}
