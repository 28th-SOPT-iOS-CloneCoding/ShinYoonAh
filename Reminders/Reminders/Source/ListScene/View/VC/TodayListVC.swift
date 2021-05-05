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
        return cell
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
        setToolbarItem()
        setView()
        setButton()
        setLabel()
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
            infoLabel.isHidden = true
        } else {
            infoLabel.isHidden = false
        }
    }
}

// MARK: - Action
extension TodayListVC {
    @objc
    private func touchUpAddNewAlert(_ sender: Any) {
        print("NewAlert!!")
    }
}
