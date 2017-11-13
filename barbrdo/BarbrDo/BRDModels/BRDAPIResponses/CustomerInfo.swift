//
//  CustomerInfo.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 17/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class CustomerInfo: NSObject {
    public var _id : String?
    public var email : String?
    public var first_name : String?
    public var last_name : String?
    public var mobile_number : Int?
    public var password : String?
    public var user_type : String?
    public var device_type : String?
    public var device_id : String?
    public var remark : String?
    public var is_active : String?
    public var is_verified : String?
    public var is_deleted : String?
    public var modified_date : String?
    public var created_date : String?
    public var licensed_since : String?
    public var gallery = [BRD_GalleyBO]()
    public var ratings = [BRD_RatingsBO]()
    public var barber_services = [BRD_ServicesBO]()
    public var favourite_barber = [Favourite_barber]()
    public var latLong = [Double]()
    public var __v : Int?
    public var is_online : String?
    public var is_available : String?
    public var radius_search : Int?
    public var text: String?
    
    public var picture: String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let customerInfo_list = CustomerInfo.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of CustomerInfo Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [CustomerInfo]
    {
        var models:[CustomerInfo] = []
        for item in array
        {
            models.append(CustomerInfo(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let customerInfo = CustomerInfo(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: CustomerInfo Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        email = dictionary["email"] as? String
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        mobile_number = dictionary["mobile_number"] as? Int
        password = dictionary["password"] as? String
        user_type = dictionary["user_type"] as? String
        device_type = dictionary["device_type"] as? String
        device_id = dictionary["device_id"] as? String
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
        if (dictionary["favourite_barber"] != nil) { favourite_barber = Favourite_barber.modelsFromDictionaryArray(array: dictionary["favourite_barber"] as! NSArray) }
        if (dictionary["latLong"] != nil) { latLong = dictionary["latLong"] as! [Double] }
        __v = dictionary["__v"] as? Int
        is_online = dictionary["is_online"] as? String
        is_available = dictionary["is_available"] as? String
        radius_search = dictionary["radius_search"] as? Int
        text = dictionary["text"] as? String
        picture = dictionary["picture"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.first_name, forKey: "first_name")
        dictionary.setValue(self.last_name, forKey: "last_name")
        dictionary.setValue(self.mobile_number, forKey: "mobile_number")
        dictionary.setValue(self.password, forKey: "password")
        dictionary.setValue(self.user_type, forKey: "user_type")
        dictionary.setValue(self.device_type, forKey: "device_type")
        dictionary.setValue(self.device_id, forKey: "device_id")
        dictionary.setValue(self.remark, forKey: "remark")
        dictionary.setValue(self.is_active, forKey: "is_active")
        dictionary.setValue(self.is_verified, forKey: "is_verified")
        dictionary.setValue(self.is_deleted, forKey: "is_deleted")
        dictionary.setValue(self.modified_date, forKey: "modified_date")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.licensed_since, forKey: "licensed_since")
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self.is_online, forKey: "is_online")
        dictionary.setValue(self.is_available, forKey: "is_available")
        dictionary.setValue(self.radius_search, forKey: "radius_search")
        dictionary.setValue(self.text, forKey: "text")
        return dictionary
    }
    
}
