//
//  StudentTableViewCell.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 24/5/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit

protocol StudentTableViewCellDelegate{
    
    func accessInfoPressed() -> Void
    func trackStudentPressed() -> Void
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setStudentDataFromDictionary(studentData: Dictionary<String, String>){
        
    }

    @IBAction func accessInfoAction(sender: AnyObject) {
        delegate?.accessInfoPressed()
    }
    
    @IBAction func trackStudentAction(sender: AnyObject) {
        delegate?.trackStudentPressed()
    }
}
