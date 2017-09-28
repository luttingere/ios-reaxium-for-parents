//
//  AccessInformationViewController.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 2/6/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit
import MMDrawerController

class AccessInformationViewController: UIViewController {

    @IBOutlet weak var notificationsTableView: UITableView!
    var deleteButton: UIBarButtonItem!
    
    var sectionInfoArray = Array<Dictionary<String, Int32>>()
    var notificationsArray = [NotificationEntity]()
    var targetStudentID = ""
    var showBackButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(AccessInformationViewController.newNotificationReceived), name: NSNotification.Name(rawValue: GlobalConstants.accessNotificationKey), object: nil)
        personalizeNavigationBar("ACCESS INFORMATION")
        
        if !showBackButton {
            self.navigationItem.leftBarButtonItem = nil;
        }
        
        CoreDataManager.shared.markAsReaded(targetStudentID)
        sectionInfoArray = CoreDataManager.shared.groupByDayMonthYear(targetStudentID)!
        notificationsArray = CoreDataManager.shared.load(targetStudentID)!
        
        if notificationsArray.count > 0 {
            refreshTable(true)
            updateTableContentInset()
            scrollToFirstNotification(false)
        }
        enableDeleteButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newNotificationReceived() {
        refreshTable(true)
        updateTableContentInset()
        scrollToFirstNotification(true)
        CoreDataManager.shared.markAsReaded(targetStudentID)
        enableDeleteButton()
    }
    
    // Fill the cells starting from the bottom
    func updateTableContentInset() -> Void {
        let numSections = numberOfSections(in: notificationsTableView)
        var numRows: Int = 0
        var contentInsetTop = view.bounds.size.height - 64
        
        for (index) in 0 ..< numSections {
            contentInsetTop -= notificationsTableView.sectionHeaderHeight
            numRows = tableView(notificationsTableView, numberOfRowsInSection: index)
            
            for _ in 0 ..< numRows {
                contentInsetTop -= notificationsTableView.rowHeight
                if (contentInsetTop <= 0) {
                    contentInsetTop = 0
                    break
                }
            }
        }
        
        notificationsTableView.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0);
    }
    
    func refreshTable(_ loadEntities: Bool){
        if loadEntities {
            sectionInfoArray = CoreDataManager.shared.groupByDayMonthYear(targetStudentID)!
            notificationsArray = CoreDataManager.shared.load(targetStudentID)!
        }
        notificationsTableView.reloadData()
        notificationsTableView.layoutSubviews()
    }
    
    func scrollToFirstNotification(_ newArrival: Bool) {
        if newArrival {
            let lastSection = notificationsTableView.numberOfSections-1
            if lastSection >= 0 {
                let lastRow = notificationsTableView.numberOfRows(inSection: lastSection)-1
                notificationsTableView.scrollToRow(at: IndexPath(row: lastRow, section: lastSection), at: .bottom, animated: true)
            }
        }
        else {
            let scrollPoint = CGPoint(x: 0, y: notificationsTableView.contentSize.height - notificationsTableView.rowHeight)
            notificationsTableView.setContentOffset(scrollPoint, animated: true)
        }
    }

    @IBAction func showMenuAction(_ sender: AnyObject) {
        self.mm_drawerController.toggle(MMDrawerSide.right, animated: true, completion: nil)
    }

    @IBAction func deleteButtonAction(_ sender: Any) {
        CoreDataManager.shared.delete(targetStudentID)
        sectionInfoArray.removeAll()
        notificationsArray.removeAll()
        refreshTable(false)
        enableDeleteButton()
    }
    
    func enableDeleteButton() {
        if notificationsArray.count > 0 {
            deleteButton.isEnabled = true
        }
        else {
            deleteButton.isEnabled = false
        }
    }
    
    func getSectionArray(_ section: Int) -> [NotificationEntity] {
        let sectionInfo = sectionInfoArray[section]
        
        let array = notificationsArray.filter { (notification: NotificationEntity) -> Bool in
            return notification.day == sectionInfo["day"] && notification.month == sectionInfo["month"] && notification.year == sectionInfo["year"]
        }
        
        return array
    }
}

extension AccessInformationViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(sectionInfoArray[section]["count"]!)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sectionInfoArray[section]
        
        let label = UILabel(frame: CGRect(x: 8, y: 0, width: self.view.bounds.width-16, height: tableView.sectionHeaderHeight))
        label.text = String(describing: section["year"]!) + "-" + String(format: "%02d", section["month"]!) + "-" + String(format: "%02d", section["day"]!)
        label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightMedium)
        label.textColor = .black
        label.backgroundColor = .white
        label.layer.cornerRadius = 5.0
        label.clipsToBounds = true
        label.textAlignment = .center
        
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationTableViewCell
        cell.showMessageViewForNotification(getSectionArray(indexPath.section)[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionInfoArray.count
    }
    
    @IBAction func back(_ sender: AnyObject) {
        if let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController"){
            let centerNav = UINavigationController(rootViewController: centerViewController)
            self.mm_drawerController.setCenterView(centerNav, withCloseAnimation: true, completion: nil)
        }
    }
}

