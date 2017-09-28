//
//  StudentTableViewCell.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 24/5/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit

protocol StudentTableViewCellDelegate{
    
    func accessInfoPressed(_ studentID: NSNumber) -> Void
    func trackStudentPressed(_ studentID: NSNumber) -> Void
    func routesInfoPressed(_ studentID: NSNumber) -> Void
    
}

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var studentImage: UIImageView!
    @IBOutlet weak var studentNameIcon: UIImageView!
//    @IBOutlet weak var busNumberIcon: UIImageView!
//    @IBOutlet weak var stopNumberIcon: UIImageView!
    @IBOutlet weak var schoolNameIcon: UIImageView!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentIdLabel: UILabel!
//    @IBOutlet weak var busNumberLabel: UILabel!
//    @IBOutlet weak var stopNumberLabel: UILabel!
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var accessInfoButton: UIButton!
    @IBOutlet var accessInfoBadgeLabel: UILabel!
    @IBOutlet weak var trackButton: UIButton!
    var delegate: StudentTableViewCellDelegate?
    var student: Children!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        studentImage.layer.borderColor = ApplicationColors.orange.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setStudentDataFromObject(_ studentData: Children){
        student = studentData
        studentNameLabel.text = "\(studentData.name!) \(studentData.lastname!)"//studentData.name
        studentIdLabel.text = String(studentData.documentID)
        schoolNameLabel.text = studentData.schoolName
        studentImage.image = studentData.image
        updateBadgeCounter(student.ID.stringValue)
    }
    
    func updateBadgeCounter(_ studentId: String) {
        let counter = CoreDataManager.shared.countUnreaded(studentId)
        
        if counter > 0 {
            if counter > 99 {
                accessInfoBadgeLabel.text = "99+"
            }
            else {
                accessInfoBadgeLabel.text = String(counter)
            }
            accessInfoBadgeLabel.isHidden = false
        }
        else {
            accessInfoBadgeLabel.isHidden = true
        }
    }

    @IBAction func accessInfoAction(_ sender: AnyObject) {
        delegate?.accessInfoPressed(student.ID)
    }
    
    @IBAction func trackStudentAction(_ sender: AnyObject) {
        delegate?.trackStudentPressed(student.ID)
    }

    @IBAction func routesInfoAction(_ sender: AnyObject) {
        delegate?.routesInfoPressed(student.ID)
    }
}
