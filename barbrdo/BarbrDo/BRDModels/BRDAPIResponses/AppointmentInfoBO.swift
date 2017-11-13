
//
//  AppointmentInfoBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 16/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class AppointmentInfoBO: NSObject {
    public var _id : String?
    public var barber_id : String?
    public var totalPrice : Int?
    public var shop_id : BRD_ShopDataBO?
    public var appointment_date : String?
    public var customer_id : String?
    public var __v : Int?
    public var created_date : String?
    public var services : [BRD_ServicesBO]?
    public var appointment_status : String?
    public var is_rating_given : Bool?
    public var rating_score : Int?
    public var customerInfo = [CustomerInfo]()
    public var barberInfo: BarberInfo?

    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let appointmentInfo_list = AppointmentInfo.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of AppointmentInfo Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [AppointmentInfoBO]
    {
        var models:[AppointmentInfoBO] = []
        for item in array
        {
            models.append(AppointmentInfoBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let appointmentInfo = AppointmentInfo(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: AppointmentInfo Instance.
    
     */
    
    
    override init() {
        self._id = ""
        self.barber_id = ""
        self.totalPrice = 0
        self.shop_id = BRD_ShopDataBO.init()
        self.appointment_date = ""
        self.customer_id = ""
        self.__v = 0
        self.created_date = ""
        self.services = []
        self.appointment_status = ""
        self.is_rating_given = false
        self.rating_score = 0
        self.customerInfo = []
        self.barberInfo = BarberInfo.init()

    }
    
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        barber_id = dictionary["barber_id"] as? String
        totalPrice = dictionary["totalPrice"] as? Int
//         if (dictionary["shop_id"] != nil) {
//            
//            shop_id =
//            BRD_ShopDataBO.init(dictionary: dictionary["shop_id"] as! NSDictionary)
//        
//        }
        
        
        appointment_date = dictionary["appointment_date"] as? String
        customer_id = dictionary["customer_id"] as? String
        __v = dictionary["__v"] as? Int
        created_date = dictionary["created_date"] as? String
        if (dictionary["services"] != nil) { services = BRD_ServicesBO.modelsFromDictionaryArray(array: dictionary["services"] as! NSArray) }
        appointment_status = dictionary["appointment_status"] as? String
        is_rating_given = dictionary["is_rating_given"] as? Bool
        
        rating_score = dictionary["rating_score"] as? Int
        if (dictionary["customerInfo"] != nil) { customerInfo = CustomerInfo.modelsFromDictionaryArray(array: dictionary["customerInfo"] as! NSArray) }
        
        barber_id = dictionary["barber_id"] as? String
        
//        if (dictionary["barber_id"] != nil) {
//            
//          barberInfo = BarberInfo.init(dictionary: dictionary["barber_id"] as! NSDictionary)
//        }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.barber_id, forKey: "barber_id")
        dictionary.setValue(self.totalPrice, forKey: "totalPrice")
        dictionary.setValue(self.shop_id, forKey: "shop_id")
        dictionary.setValue(self.appointment_date, forKey: "appointment_date")
        dictionary.setValue(self.customer_id, forKey: "customer_id")
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.appointment_status, forKey: "appointment_status")
        dictionary.setValue(self.is_rating_given, forKey: "is_rating_given")
        
        return dictionary
    }
    
}
