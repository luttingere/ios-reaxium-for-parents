//
//  MenuTableViewCell.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 31/5/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var optionTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        self.selectedBackgroundView = selectedBackgroundView
        
        if selected{
            iconImage.tintColor = UIColor(red: 221.0/255.0, green: 191.0/255.0, blue: 139.0/255.0, alpha: 1.0)
        }else{
            iconImage.tintColor = UIColor.lightGray
        }
    }
    
    func setMenuCellContentWithData(_ menuData: Dictionary<String, String>){
        iconImage.image = UIImage(named: menuData["image"]!)
        iconImage.image? = (iconImage.image?.withRenderingMode(.alwaysTemplate))!
        optionTitle.text = menuData["option"]
    }

}
