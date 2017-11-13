//
//  ShopsEventBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 10/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class ShopsEventBO: NSObject {
    public var _id : String?
    public var barber_id : String?
    public var shop_id : String?
    public var payment_method : String?
    public var appointment_date : String?
    public var customer_name : String?
    public var shop_name : String?
    public var barber_name : String?
    public var customer_id : String?
    public var modified_date : String?
    public var created_date : String?
    public var payment_status : String?
    public var appointment_status : String?
    public var services : [BRD_ServicesBO]?
    public var is_rating_given : String?
    public var __v : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ShopsEventBO]
    {
        var models:[ShopsEventBO] = []
        for item in array
        {
            models.append(ShopsEventBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Json4Swift_Base Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        barber_id = dictionary["barber_id"] as? String
        shop_id = dictionary["shop_id"] as? String
        payment_method = dictionary["payment_method"] as? String
        appointment_date = dictionary["appointment_date"] as? String
        customer_name = dictionary["customer_name"] as? String
        shop_name = dictionary["shop_name"] as? String
        barber_name = dictionary["barber_name"] as? String
        customer_id = dictionary["customer_id"] as? String
        modified_date = dictionary["modified_date"] as? String
        created_date = dictionary["created_date"] as? String
        payment_status = dictionary["payment_status"] as? String
        appointment_status = dictionary["appointment_status"] as? String
        if (dictionary["services"] != nil) { services = BRD_ServicesBO.modelsFromDictionaryArray(array: dictionary["services"] as! NSArray) }
        is_rating_given = dictionary["is_rating_given"] as? String
        __v = dictionary["__v"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.barber_id, forKey: "barber_id")
        dictionary.setValue(self.shop_id, forKey: "shop_id")
        dictionary.setValue(self.payment_method, forKey: "payment_method")
        dictionary.setValue(self.appointment_date, forKey: "appointment_date")
        dictionary.setValue(self.customer_name, forKey: "customer_name")
        dictionary.setValue(self.shop_name, forKey: "shop_name")
        dictionary.setValue(self.barber_name, forKey: "barber_name")
        dictionary.setValue(self.customer_id, forKey: "customer_id")
        dictionary.setValue(self.modified_date, forKey: "modified_date")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.payment_status, forKey: "payment_status")
        dictionary.setValue(self.appointment_status, forKey: "appointment_status")
        dictionary.setValue(self.is_rating_given, forKey: "is_rating_given")
        dictionary.setValue(self.__v, forKey: "__v")
        
        return dictionary
    }
    
}
