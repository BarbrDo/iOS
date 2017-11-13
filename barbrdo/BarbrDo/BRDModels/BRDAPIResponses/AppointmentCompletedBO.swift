//
//  AppointmentCompletedBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 20/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class AppointmentCompletedBO: NSObject {
    public var __v : Int?
    public var _id : String?
    public var appointment_date : String?
    public var appointment_status : String?
    public var barber_id : BarberInfoBO?
    public var created_date : String?
    public var customer_id : Customer_id?
    public var is_rating_given : Int?
    public var services = [BRD_ServicesBO]()
    public var shop_id : ShopInfoBO?
    public var totalPrice : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [AppointmentCompletedBO]
    {
        var models:[AppointmentCompletedBO] = []
        for item in array
        {
            models.append(AppointmentCompletedBO(dictionary: item as! NSDictionary)!)
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
        
        __v = dictionary["__v"] as? Int
        _id = dictionary["_id"] as? String
        appointment_date = dictionary["appointment_date"] as? String
        appointment_status = dictionary["appointment_status"] as? String
        if (dictionary["barber_id"] != nil) { barber_id = BarberInfoBO(dictionary: dictionary["barber_id"] as! NSDictionary) }
        created_date = dictionary["created_date"] as? String
        if (dictionary["customer_id"] != nil) { customer_id = Customer_id(dictionary: dictionary["customer_id"] as! NSDictionary) }
        is_rating_given = dictionary["is_rating_given"] as? Int
        if (dictionary["services"] != nil) { services = BRD_ServicesBO.modelsFromDictionaryArray(array: dictionary["services"] as! NSArray) }
        if (dictionary["shop_id"] != nil) { shop_id = ShopInfoBO(dictionary: dictionary["shop_id"] as! NSDictionary) }
        totalPrice = dictionary["totalPrice"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.appointment_date, forKey: "appointment_date")
        dictionary.setValue(self.appointment_status, forKey: "appointment_status")
        dictionary.setValue(self.barber_id?.dictionaryRepresentation(), forKey: "barber_id")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.customer_id?.dictionaryRepresentation(), forKey: "customer_id")
        dictionary.setValue(self.is_rating_given, forKey: "is_rating_given")
        dictionary.setValue(self.shop_id?.dictionaryRepresentation(), forKey: "shop_id")
        dictionary.setValue(self.totalPrice, forKey: "totalPrice")
        
        return dictionary
    }
    
}
