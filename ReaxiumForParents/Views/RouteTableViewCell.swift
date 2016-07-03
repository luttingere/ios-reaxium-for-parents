//
//  RouteTableViewCell.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 7/3/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    @IBOutlet weak var routeNameLabel: UILabel!
    @IBOutlet weak var routeTypeLabel: UILabel!
    @IBOutlet weak var stopNumberLabel: UILabel!
    @IBOutlet weak var sheduleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadCellWithRouteInformation(route: Routes!) -> Void {
        routeNameLabel.text = route.routeNumber
        stopNumberLabel.text = route.stopNumber
        sheduleLabel.text = route.scheduleTime
        
        switch route.routeType! {
        case .PickUp:
            routeTypeLabel.text = "Pick Up"
        case .DropOff:
            routeTypeLabel.text = "Drop Off"
        }
    }

}
