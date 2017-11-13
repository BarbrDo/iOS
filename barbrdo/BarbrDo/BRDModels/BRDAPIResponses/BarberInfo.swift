//
//  BarberInfo.swift
//  BarbrDo
//
//  Created by Shami Kumar on 20/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BarberInfo: NSObject {
    
    public var password : String?
    public var randomString : String?
    public var stripe_customer : String?
    public var subscription : String?
    
    
    public var _id : String?
    public var first_name : String?
    public var last_name : String?
    public var email : String?
    public var mobile_number : Int?
    public var user_type : String?
    public var license_number : String?
    public var random_string : String?
    public var __v : Int?
    public var barber_shop_id : String?
    public var is_available : String?
    public var is_online : String?
    public var device_type : String?
    public var device_id : String?
    public var picture : String?
    public var barber_shops_latLong : [Double]?
    public var bio : String?
    public var remark : String?
    public var is_active : String?
    public var is_verified : String?
    public var is_deleted : String?
    public var modified_date : String?
    public var created_date : String?
    public var licensed_since : String?
    public var gallery : [BRD_GalleyBO]?
    public var ratings : [BRD_RatingsBO]?
    public var barber_services : [BRD_ServicesBO]?
    //public var favourite_barber : Array<String>?
    public var latLong : [Double]?
    
    public var rating_score: Double?
    
    
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [BarberInfo]
    {
        var models:[BarberInfo] = []
        for item in array
        {
            models.append(BarberInfo(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    override init() {
        
        self._id = ""
        self.first_name = ""
        self.last_name = ""
        self.picture = ""
        self.rating_score = 0
        
    }
    
       required public init?(dictionary: NSDictionary) {

        password = dictionary["password"] as? String
        randomString = dictionary["randomString"] as? String
        stripe_customer = dictionary["stripe_customer"] as? String
        __v = dictionary["__v"] as? Int
        subscription = dictionary["subscription"] as? String
        
        _id = dictionary["_id"] as? String
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        email = dictionary["email"] as? String
        mobile_number = dictionary["mobile_number"] as? Int
        user_type = dictionary["user_type"] as? String
        license_number = dictionary["license_number"] as? String
        random_string = dictionary["random_string"] as? String
        __v = dictionary["__v"] as? Int
        barber_shop_id = dictionary["barber_shop_id"] as? String
        is_available = dictionary["is_available"] as? String
        is_online = dictionary["is_online"] as? String
        device_type = dictionary["device_type"] as? String
        device_id = dictionary["device_id"] as? String
        picture = dictionary["picture"] as? String
        if (dictionary["barber_shops_latLong"] != nil) { barber_shops_latLong = dictionary["barber_shops_latLong"] as! [Double]}
        bio = dictionary["bio"] as? String
        remark = dictionary["remark"] as? String
        is_active = dictionary["is_active"] as? String
        is_verified = dictionary["is_verified"] as? String
        is_deleted = dictionary["is_deleted"] as? String
        modified_date = dictionary["modified_date"] as? String
        created_date = dictionary["created_date"] as? String
        licensed_since = dictionary["licensed_since"] as? String
        if (dictionary["gallery"] != nil) { gallery = BRD_GalleyBO.modelsFromDictionaryArray(array: dictionary["gallery"] as! NSArray) }
        if (dictionary["ratings"] != nil) { ratings = BRD_RatingsBO.modelsFromDictionaryArray(array: dictionary["ratings"] as! NSArray) }

        if (dictionary["barber_services"] != nil) { barber_services = BRD_ServicesBO.modelsFromDictionaryArray(array: dictionary["barber_services"] as! NSArray) }
//        if (dictionary["favourite_barber"] != nil) { favourite_barber = Favourite_barber.modelsFromDictionaryArray(dictionary["favourite_barber"] as! NSArray) }
        if (dictionary["latLong"] != nil) {
            latLong = dictionary["latLong"] as! [Double]
        }
        
        print(dictionary["rating_score"] as? String)
        rating_score = dictionary["rating_score"] as? Double ?? 0
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.first_name, forKey: "first_name")
        dictionary.setValue(self.last_name, forKey: "last_name")
        dictionary.setValue(self.picture, forKey: "picture")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.mobile_number, forKey: "mobile_number")
        dictionary.setValue(self.gallery, forKey: "gallery")
        dictionary.setValue(self.ratings, forKey: "ratings")
        //dictionary.setValue(self.barber_services, forKey: "barber_services")
        dictionary.setValue(self.is_available, forKey: "is_available")
        //dictionary.setValue(self.is_, forKey: <#T##String#>)
        //public var is_favourite: Bool?
        
        dictionary.setValue(self.is_online, forKey: "is_online")
        dictionary.setValue(self.picture, forKey: "picture")
//        dictionary.setValue(self.dist, forKey: <#T##String#>)
//        public var distance : Double?
        
//        dictionary.setValue(self.u, forKey: <#T##String#>)
//        public var units : String?
        
//        dictionary.setValue(self.bar, forKey: <#T##String#>)
//        public var barber_shops : BRD_BarberShopsBO?
        
        return dictionary
    }


}
