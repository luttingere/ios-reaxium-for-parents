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
    @IBOutlet weak var incomingMessageLabelTimeLabel: UILabel!
    @IBOutlet weak var outcomingMessageLabel: UILabel!
    @IBOutlet weak var outcomingMessageLabelTimeLabel: UILabel!
    @IBOutlet weak var alarmMessageLabel: UILabel!
    @IBOutlet weak var alarmMessageTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showMessageViewForNotification(_ notification: NotificationEntity) -> Void {
        switch notification.access_type {
        case AccessType.boarding:
            incomingMessageView.isHidden = false
            outcomingMessageView.isHidden = true
            alarmMessageView.isHidden = true
            incomingMessageLabel.text = notification.access_info!
            incomingMessageLabelTimeLabel.text = ReaxiumHelper.getTimeStringFromDate(date: notification.date!)
        case AccessType.arriving:
            outcomingMessageView.isHidden = false
            incomingMessageView.isHidden = true
            alarmMessageView.isHidden = true
            outcomingMessageLabel.text = notification.access_info!
            outcomingMessageLabelTimeLabel.text = ReaxiumHelper.getTimeStringFromDate(date: notification.date!)
        case AccessType.emergency:
            alarmMessageView.isHidden = false
            outcomingMessageView.isHidden = true
            incomingMessageView.isHidden = true
            alarmMessageLabel.text =  notification.access_info!
            alarmMessageTimeLabel.text = ReaxiumHelper.getTimeStringFromDate(date: notification.date!)
        default: break
        }
        
    }

}
