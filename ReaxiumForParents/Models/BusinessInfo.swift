//
//  BusinessInfo.swift
//  ReaxiumForParents
//
//  Created by Freddy Miguel Vega Zárate on 10-05-17.
//  Copyright © 2017 Jorge Rodriguez. All rights reserved.
//

import Foundation
import ObjectMapper

/* 
 "business_id": 31,
 "business_name": "Unidad Educativa los Castores",
 "business_id_number": "536444",
 "address_id": 53,
 "phone_number_id": 589,
 "status_id": 1,
 "business_type_id": 1,
 "business_master_id": 1,
 "business_logo": "http://54.202.10.0/reaxium_user_images/profile-default.png",
 "business_type": {
    "business_type_id": 1,
    "business_type_name": "Worker"
 }*/
class BusinessInformation: NSObject, NSCoding, Mappable {
    
    var ID: NSNumber!
    var name: String!
    var businessIdNumber: String!
    var addressId: NSNumber!
    var phoneNumberId: NSNumber!
    var statusId: NSNumber!
    var businessTypeId: NSNumber!
    var businessMasterId: NSNumber!
    var businessLogo: UIImage?
    var businessLogoUrl: String!
    var businessType: BusinessType!
    
    override init() {}
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        ID = aDecoder.decodeObject(forKey: "ID") as! NSNumber
        name = aDecoder.decodeObject(forKey: "name") as! String
        businessIdNumber = aDecoder.decodeObject(forKey: "businessIdNumber") as! String
        addressId = aDecoder.decodeObject(forKey: "addressId") as! NSNumber
        phoneNumberId = aDecoder.decodeObject(forKey: "phoneNumberId") as! NSNumber
        statusId = aDecoder.decodeObject(forKey: "statusId") as! NSNumber
        businessTypeId = aDecoder.decodeObject(forKey: "businessTypeId") as! NSNumber
        businessMasterId = aDecoder.decodeObject(forKey: "businessMasterId") as! NSNumber
        businessLogo = aDecoder.decodeObject(forKey: "businessLogo") as? UIImage
        businessLogoUrl = aDecoder.decodeObject(forKey: "businessLogoUrl") as! String
        businessType = aDecoder.decodeObject(forKey: "businessType") as! BusinessType
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(ID, forKey: "ID")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(businessIdNumber, forKey: "businessIdNumber")
        aCoder.encode(addressId, forKey: "addressId")
        aCoder.encode(phoneNumberId, forKey: "phoneNumberId")
        aCoder.encode(statusId, forKey: "statusId")
        aCoder.encode(businessTypeId, forKey: "businessTypeId")
        aCoder.encode(businessMasterId, forKey: "businessMasterId")
        aCoder.encode(businessLogo, forKey: "businessLogo")
        aCoder.encode(businessLogoUrl, forKey: "businessLogoUrl")
        aCoder.encode(businessType, forKey: "businessType")
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        ID <- map["business_id"]
        name <- map["business_name"]
        businessIdNumber <- map["business_id_number"]
        addressId <- map["address_id"]
        phoneNumberId <- map["phone_number_id"]
        statusId <- map["status_id"]
        businessTypeId <- map["business_type_id"]
        businessMasterId <- map["business_master_id"]
        businessLogoUrl <- map["business_logo"]
        businessType <- map["business_type"]
        
        if let path = businessLogoUrl{
            if !path.isEmpty{
                let url = URL(string: path)
                if let dataPicture = try? Data(contentsOf: url!){
                    if let picture = UIImage(data: dataPicture){
                        businessLogo = picture
                    }
                }
            }
        }
    }
}

class BusinessType: NSObject, NSCoding, Mappable {
    
    var ID: NSNumber!
    var name: String!
    
    override init() {}
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        ID = aDecoder.decodeObject(forKey: "ID") as! NSNumber
        name = aDecoder.decodeObject(forKey: "name") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(ID, forKey: "ID")
        aCoder.encode(name, forKey: "name")
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        ID <- map["business_type_id"]
        name <- map["business_type_name"]
    }
}
