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
    
    let manager = StoryManager.shared
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
        setupLongPressGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        list = fetch()
        storyTableView.reloadData()
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
    
    
    // 게시글이나 공지같은거 작성할때 서버 시간과 현재 시간을 비교해서
    // 10분전 , 1시간전 등 작성된 시간을 계산해주는 함수
    public func slicingDate(date : Date) -> String {
        var message : String = "" // 최종 결과값 담기위한 변수

        let UTCDate = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 32400)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let defaultTimeZoneStr = formatter.string(from: UTCDate)

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.locale = Locale(identifier: "ko_KR")
         // 한국 시각기준으로 측정합니다.
        
        let krTime = format.date(from: defaultTimeZoneStr)
        let articleDate = format.string(from: date)
        let useTime = Int(krTime!.timeIntervalSince(date))
        
        if useTime < 60 {
            message = "방금 전"
        } else if useTime < 3600 {
            message = String(useTime/60) + "분 전"
        } else if useTime < 86400 {
            message = String(useTime/3600) + "시간 전"
        } else {
            let timeArray = articleDate.components(separatedBy: " ")
            let dateArray = timeArray[0].components(separatedBy: "-")
            
            message = dateArray[1] + "." + dateArray[2]
        }
        
        return message
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
        let date = record.value(forKey: "date") as? Date ?? Date()
        let dateString = slicingDate(date: date)
        
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
                let request: NSFetchRequest<Contents> = Contents.fetchRequest()
                let fetchResult = StoryManager.shared.fetch(request: request)
                
                self.list = fetchResult.reversed()
                self.storyTableView.reloadData()
            }
            present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pvc = storyboard?.instantiateViewController(withIdentifier: "DetailStoryVC") as? DetailStoryVC else { return }
        pageVC?.plusButton.isHidden = true
        pvc.textCount = list.count
        pvc.currentIndex = CGFloat(indexPath.row)
        navigationController?.pushViewController(pvc, animated: true)
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.storyTableView.addGestureRecognizer(longPressGesture)
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.storyTableView)
            if let indexPath = storyTableView.indexPathForRow(at: touchPoint) {
                let record = self.list[indexPath.row]
                guard let title = record.value(forKey: "title") as? String else { return }
                
                makeTableActionSheet(title: nil, message: title, okAction: { _ in
                    print(record)
                    self.makeRemoveAlert(title: nil, message: "정말 삭제하시겠습니까?", okAction: { _ in
                        self.deleteData(title: title)
                        
                        let request: NSFetchRequest<Contents> = Contents.fetchRequest()
                        let fetchResult = StoryManager.shared.fetch(request: request)
                        print(fetchResult)
                        self.list = fetchResult.reversed()
                        self.storyTableView.reloadData()
                    })
                }, completion: nil)
            }
        }
    }
    
    func deleteData(title: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Contents")
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}
