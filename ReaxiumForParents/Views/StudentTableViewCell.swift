//
//  StudentTableViewCell.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 24/5/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit

protocol StudentTableViewCellDelegate{
    
    func accessInfoPressed(studentID: NSNumber) -> Void
    func trackStudentPressed(studentID: NSNumber) -> Void
    
}

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var studentImage: UIImageView!
    @IBOutlet weak var studentNameIcon: UIImageView!
    @IBOutlet weak var busNumberIcon: UIImageView!
    @IBOutlet weak var stopNumberIcon: UIImageView!
    @IBOutlet weak var schoolNameIcon: UIImageView!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var busNumberLabel: UILabel!
    @IBOutlet weak var stopNumberLabel: UILabel!
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var accessInfoButton: UIButton!
    @IBOutlet weak var trackButton: UIButton!
    var delegate: StudentTableViewCellDelegate?
    var student: Children!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setStudentDataFromObject(studentData: Children){
        student = studentData
        studentNameLabel.text = studentData.name
        studentIdLabel.text = String(studentData.documentID)
        schoolNameLabel.text = studentData.schoolName
        studentImage.getImageFromDirectory(studentData.imageUrl)
    }

    @IBAction func accessInfoAction(sender: AnyObject) {
        delegate?.accessInfoPressed(student.ID)
    }
    
    @IBAction func trackStudentAction(sender: AnyObject) {
        delegate?.trackStudentPressed(student.ID)
    }
}

extension UIImageView {
    
    func getImageFromDirectory(directory : String?) {
        
        self.image = UIImage(named: "male_user_icon")
        if let path = directory{
            if !path.isEmpty{
                let url = NSURL(string: path)
                
                if let dataPicture = NSData(contentsOfURL:url!){
                    if let picture = UIImage(data: dataPicture){
                        self.image = picture
                    }
                }
            }
        }
    }
}
