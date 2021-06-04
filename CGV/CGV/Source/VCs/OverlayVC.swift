//
//  OverlayVC.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/16.
//

import UIKit

class OverlayVC: UIViewController {
    @IBOutlet weak var swipeButton: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bookingTableView: UITableView!
    @IBOutlet weak var xmarkButton: UIButton!
    
    private var isClicked = false
    private var positionCount = 0
    private var viewTranslation = CGPoint(x: 0, y: 0)
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45, execute: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigure()
        setupNotification()
    }
    
    // MARK: - Setting Functions
    private func setupConfigure() {
        backView.layer.cornerRadius = 20
        swipeButton.layer.cornerRadius = 3
        
        tableViewSetting()
        setupTouchGesture()
        setupActions()
    }
    
    private func tableViewSetting() {
        bookingTableView.delegate = self
        bookingTableView.dataSource = self
        
        let selectNib = UINib(nibName: "SelectTheaterTVC", bundle: nil)
        let dateNib = UINib(nibName: "DateTheaterTVC", bundle: nil)
        bookingTableView.register(selectNib, forCellReuseIdentifier: SelectTheaterTVC.identifier)
        bookingTableView.register(dateNib, forCellReuseIdentifier: DateTheaterTVC.identifier)
    }
    
    
    private func setupTouchGesture() {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    private func setupActions() {
        let xmarkAction = UIAction { _ in
            print("dismiss")
            
            self.view.backgroundColor = UIColor.clear
            self.dismiss(animated: true, completion: nil)
        }
        xmarkButton.addAction(xmarkAction, for: .touchUpInside)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(cellIncrease), name: NSNotification.Name("increaseCell"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cellDecrease), name: NSNotification.Name("decreaseCell"), object: nil)
    }
    
    // MARK: - @Objc Functions
    @objc
    func cellIncrease(_ notification: Notification) {
        print("increase")
        isClicked = true
        positionCount = notification.object as! Int
        bookingTableView.beginUpdates()
        bookingTableView.endUpdates()
    }
    
    @objc
    func cellDecrease() {
        print("decrease")
        isClicked = false
        bookingTableView.beginUpdates()
        bookingTableView.endUpdates()
    }
    
    @objc
    func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                if self.viewTranslation.y >= 0 {
                    var colorAlpha = 0.3 - (self.viewTranslation.y / 1000)
                    
                    if colorAlpha < 0.1 {
                        colorAlpha = 0.1
                    }
                    self.view.backgroundColor = UIColor.black.withAlphaComponent(colorAlpha
                    )
                    
                    self.swipeButton.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                    self.backView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                }
            })
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                    self.swipeButton.transform = .identity
                    self.backView.transform = .identity
                })
            } else {
                self.view.backgroundColor = UIColor.clear
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
}

extension OverlayVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectTheaterTVC.identifier) as? SelectTheaterTVC else {
                return UITableViewCell()
            }
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTheaterTVC.identifier) as? DateTheaterTVC else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

extension OverlayVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return SelectTheaterHeaderView()
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 45
        }
        return .leastNormalMagnitude
    }
    
    // MARK: - TODO: 더 나은 알고리즘으로 만들고 싶다
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && isClicked {
            let count = positionCount / 3
            
            if positionCount == 20 {
                return 483
            }
            
            if count == 1 {
                return 133
            } else if count == 3 {
                return 233
            } else if count == 4 {
                return 300
            }
            
            return CGFloat(133 + 50 * count)
        } else if indexPath.section == 0 && !isClicked {
            return 133
        }
        return 280
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

extension OverlayVC: showupAlertDelegate {
    func showupAlertToLookup(title: String?, content: String) {
        if let title = title {
            makeAlert(title: title, message: content)
        }
    }
}
