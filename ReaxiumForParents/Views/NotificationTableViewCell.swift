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
    @IBOutlet weak var incomingMessageLabel: UILabel!
    @IBOutlet weak var outcomingMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showMessageViewForNotification(type: Int) -> Void {
        if (type % 2 == 0) {
            incomingMessageView.hidden = false
            outcomingMessageView.hidden = true
        }else{
            outcomingMessageView.hidden = false
            incomingMessageView.hidden = true
        }
    }

}
