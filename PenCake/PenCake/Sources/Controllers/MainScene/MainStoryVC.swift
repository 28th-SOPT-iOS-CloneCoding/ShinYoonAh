//
//  MainStoryVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/30.
//

import UIKit
import CoreData

class MainStoryVC: UIViewController {
    private var storyTableView = UITableView()
    lazy var titleHeader = StoryTitleHeader(title: "이야기1", subTitle: "부제목", root: self)
    
    private var originalTableViewHeight: CGFloat = 0.0
    var pageVC: StoryPageVC?
    
    lazy var list: [NSManagedObject] = {
        return self.fetch()
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        pageVC?.plusButton.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupConfigure()
    }
    
    override func viewWillLayoutSubviews() {
        titleHeader.snp.makeConstraints { make in
            if UIDevice.current.hasNotch {
                make.top.equalToSuperview().inset(44)
            } else {
                make.top.equalToSuperview()
            }
            make.leading.trailing.equalToSuperview()
        }
        
        storyTableView.snp.makeConstraints { make in
            make.top.equalTo(titleHeader.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        storyTableView.dataSource = self
        storyTableView.delegate = self
        
        storyTableView.backgroundColor = .secondarySystemBackground
        storyTableView.separatorStyle = .none
        
        let nib = UINib(nibName: StoryListTVC.identifier, bundle: nil)
        storyTableView.register(nib, forCellReuseIdentifier: StoryListTVC.identifier)
    }
    
    private func setupConfigure() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        view.addSubview(titleHeader)
        view.addSubview(storyTableView)
        
        originalTableViewHeight = storyTableView.frame.size.height
    }
    
    // read the data
    func fetch() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contents")
        
        // sort
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let result = try! context.fetch(fetchRequest)
        return result
    }
}

extension MainStoryVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension MainStoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryListTVC.identifier) as? StoryListTVC else {
            return UITableViewCell()
        }
        let record = self.list[indexPath.row]
        let title = record.value(forKey: "title") as? String
        let date = record.value(forKey: "date") as? Date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd"
        let dateString = dateFormatter.string(from: date ?? Date())
        
        cell.titleLabel?.text = title
        cell.dateLabel?.text = "\(String(describing: dateString))"
        cell.selectionStyle = .none
        return cell
    }
}

extension MainStoryVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = storyTableView.contentOffset.y
        
        if offset > 0 {
            titleHeader.updateHeaderLayout(offset: offset)
            
            if offset > 46 {
                storyTableView.transform = CGAffineTransform(translationX: 0, y: -110)
            } else {
                storyTableView.transform = CGAffineTransform(translationX: 0, y: -offset*2.5)
            }
        } else if offset == 0 {
            titleHeader.backToOriginalHeaderLayout()
            storyTableView.transform = .identity
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = storyTableView.contentOffset.y
        
        if offset < -100 {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "CreateContentVC") as? CreateContentVC else { return }
            vc.modalPresentationStyle = .fullScreen
            vc.saveContent = { title, content in
                print(self.list)
                self.storyTableView.reloadData()
                self.pageVC?.reloadInputViews()
            }
            present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pvc = storyboard?.instantiateViewController(withIdentifier: "DetailStoryVC") as? DetailStoryVC else { return }
        pageVC?.plusButton.isHidden = true
        navigationController?.pushViewController(pvc, animated: true)
    }
}
