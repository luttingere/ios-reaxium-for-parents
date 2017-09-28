//
//  Children.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/4/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import Foundation
import ObjectMapper

class Children: NSObject, NSCoding, Mappable{
    
    var ID: NSNumber!
    var name: String!
    var lastname: String!
    var imageUrl: String!
    var documentID: String!
    var schoolName: String!
    var image: UIImage?
    
    override init() {}
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        ID = aDecoder.decodeObject(forKey: "ID") as! NSNumber
        name = aDecoder.decodeObject(forKey: "name") as! String
        lastname = aDecoder.decodeObject(forKey: "lastname") as! String
        imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as! String
        documentID = aDecoder.decodeObject(forKey: "documentID") as! String
        schoolName = aDecoder.decodeObject(forKey: "schoolName") as! String
        image = aDecoder.decodeObject(forKey: "image") as? UIImage
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(ID, forKey: "ID")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(lastname, forKey: "lastname")
        aCoder.encode(imageUrl, forKey: "imageUrl")
        aCoder.encode(documentID, forKey: "documentID")
        aCoder.encode(schoolName, forKey: "schoolName")
        aCoder.encode(image, forKey: "image")
    }
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        ID <- map["user_id"]
        name <- map["first_name"]
        lastname <- map["first_last_name"]
        imageUrl <- map["user_photo"]
        documentID <- map["document_id"]
        schoolName <- map["busines.business_name"]
        
        if let path = imageUrl{
            if !path.isEmpty{
                let url = URL(string: path)
                if let dataPicture = try? Data(contentsOf: url!){
                    if let picture = UIImage(data: dataPicture){
                        image = picture
                    }
                }
            }
        }else{
            image = UIImage(named: "male_user_icon")
        }
    }
}
