//
//  NotificationTableViewCell.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/4/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var incomingMessageView: UIView!
    @IBOutlet weak var outcomingMessageView: UIView!
    @IBOutlet weak var alarmMessageView: UIView!
    @IBOutlet weak var incomingMessageLabel: UILabel!
    @IBOutlet weak var outcomingMessageLabel: UILabel!
    @IBOutlet weak var alarmMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showMessageViewForNotification(notification: AccessNotification!) -> Void {
        switch notification.type! {
        case .Boarding:
            incomingMessageView.hidden = false
            outcomingMessageView.hidden = true
            alarmMessageView.hidden = true
            incomingMessageLabel.text = "\(notification.message) \(notification.getTimeStringFromDate())"
        case .Arriving:
            outcomingMessageView.hidden = false
            incomingMessageView.hidden = true
            alarmMessageView.hidden = true
            outcomingMessageLabel.text = "\(notification.message) \(notification.getTimeStringFromDate())"
        case .Emergency:
            alarmMessageView.hidden = false
            outcomingMessageView.hidden = true
            incomingMessageView.hidden = true
            alarmMessageLabel.text = notification.message
        }
        
    }

}
