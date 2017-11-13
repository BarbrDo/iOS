//
//  CustomerRequestToBarberBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 11/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class CustomerRequestToBarberBO: NSObject {
    public var appointment_status : String?
    public var totalPrice : Int?
    public var is_rating_given : String?
    public var appointment_date : String?
    public var services : [BRD_ServicesBO]?
    public var customer_lat_long : [Double]?
    public var shop_id : String?
    public var barber_id : String?
    public var __v : Int?
    public var shop_lat_long : [Double]?
    public var _id : String?
    public var created_date : String?
    public var customer_id : String?
    public var reach_in : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [CustomerRequestToBarberBO]
    {
        var models:[CustomerRequestToBarberBO] = []
        for item in array
        {
            models.append(CustomerRequestToBarberBO(dictionary: item as! NSDictionary)!)
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
        
        appointment_status = dictionary["appointment_status"] as? String
        totalPrice = dictionary["totalPrice"] as? Int
        is_rating_given = dictionary["is_rating_given"] as? String
        appointment_date = dictionary["appointment_date"] as? String
        if (dictionary["services"] != nil) { services = BRD_ServicesBO.modelsFromDictionaryArray(array: dictionary["services"] as! NSArray) }
        if (dictionary["customer_lat_long"] != nil) {
            customer_lat_long = dictionary["customer_lat_long"] as! [Double]
        }
        shop_id = dictionary["shop_id"] as? String
        barber_id = dictionary["barber_id"] as? String
        __v = dictionary["__v"] as? Int
        if (dictionary["shop_lat_long"] != nil) {
            shop_lat_long = dictionary["shop_lat_long"] as! [Double]
        }
        _id = dictionary["_id"] as? String
        created_date = dictionary["created_date"] as? String
        customer_id = dictionary["customer_id"] as? String
        reach_in = dictionary["reach_in"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.appointment_status, forKey: "appointment_status")
        dictionary.setValue(self.totalPrice, forKey: "totalPrice")
        dictionary.setValue(self.is_rating_given, forKey: "is_rating_given")
        dictionary.setValue(self.appointment_date, forKey: "appointment_date")
        dictionary.setValue(self.shop_id, forKey: "shop_id")
        dictionary.setValue(self.barber_id, forKey: "barber_id")
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.customer_id, forKey: "customer_id")
        dictionary.setValue(self.reach_in, forKey: "reach_in")
        return dictionary
    }
    
}
