//
//  BarberAppointmentBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 18/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BarberAppointmentBO: NSObject {
    public var _id : String?
    public var chair_shop_percentage : String?
    public var totalPrice : Int?
    public var chair_name : String?
    public var chair_id : String?
    public var appointment_date : String?
    public var barber_id : BRD_BarberInfoBO?
    public var amount : Int?
    public var shop_id : BRD_ShopDataBO?
    public var chair_barber_percentage : String?
    public var payment_method : String?
    public var chair_type : String?
    public var chair_amount : Int?
    public var customer_name : String?
    public var shop_name : String?
    public var barber_name : String?
    public var customer_id : Customer_id?
    public var __v : Int?
    public var modified_date : String?
    public var created_date : String?
    public var payment_status : String?
//    public var payment_detail : Array<String>?
    public var appointment_status : String?
    public var services : [BRD_ServicesBO]?
    public var is_rating_given : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BarberAppointmentBO]
    {
        var models:[BarberAppointmentBO] = []
        for item in array
        {
            models.append(BarberAppointmentBO(dictionary: item as! NSDictionary)!)
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
        chair_shop_percentage = dictionary["chair_shop_percentage"] as? String
        totalPrice = dictionary["totalPrice"] as? Int
        chair_name = dictionary["chair_name"] as? String
        chair_id = dictionary["chair_id"] as? String
        appointment_date = dictionary["appointment_date"] as? String
        if (dictionary["barber_id"] != nil) { barber_id = BRD_BarberInfoBO(dictionary: dictionary["barber_id"] as! NSDictionary) }
        amount = dictionary["amount"] as? Int
        if (dictionary["shop_id"] != nil) { shop_id = BRD_ShopDataBO(dictionary: dictionary["shop_id"] as! NSDictionary) }
        chair_barber_percentage = dictionary["chair_barber_percentage"] as? String
        payment_method = dictionary["payment_method"] as? String
        chair_type = dictionary["chair_type"] as? String
        chair_amount = dictionary["chair_amount"] as? Int
        customer_name = dictionary["customer_name"] as? String
        shop_name = dictionary["shop_name"] as? String
        barber_name = dictionary["barber_name"] as? String
        if (dictionary["customer_id"] != nil) { customer_id = Customer_id(dictionary: dictionary["customer_id"] as! NSDictionary) }
        __v = dictionary["__v"] as? Int
        modified_date = dictionary["modified_date"] as? String
        created_date = dictionary["created_date"] as? String
        payment_status = dictionary["payment_status"] as? String
//        if (dictionary["payment_detail"] != nil) { payment_detail = Payment_detail.modelsFromDictionaryArray(dictionary["payment_detail"] as! NSArray) }
        appointment_status = dictionary["appointment_status"] as? String
        if (dictionary["services"] != nil) { services = BRD_ServicesBO.modelsFromDictionaryArray(array: dictionary["services"] as! NSArray) }
        is_rating_given = dictionary["is_rating_given"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.chair_shop_percentage, forKey: "chair_shop_percentage")
        dictionary.setValue(self.totalPrice, forKey: "totalPrice")
        dictionary.setValue(self.chair_name, forKey: "chair_name")
        dictionary.setValue(self.chair_id, forKey: "chair_id")
        dictionary.setValue(self.appointment_date, forKey: "appointment_date")
        dictionary.setValue(self.barber_id?.dictionaryRepresentation(), forKey: "barber_id")
        dictionary.setValue(self.amount, forKey: "amount")
        dictionary.setValue(self.shop_id?.dictionaryRepresentation(), forKey: "shop_id")
        dictionary.setValue(self.chair_barber_percentage, forKey: "chair_barber_percentage")
        dictionary.setValue(self.payment_method, forKey: "payment_method")
        dictionary.setValue(self.chair_type, forKey: "chair_type")
        dictionary.setValue(self.chair_amount, forKey: "chair_amount")
        dictionary.setValue(self.customer_name, forKey: "customer_name")
        dictionary.setValue(self.shop_name, forKey: "shop_name")
        dictionary.setValue(self.barber_name, forKey: "barber_name")
        dictionary.setValue(self.customer_id?.dictionaryRepresentation(), forKey: "customer_id")
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self.modified_date, forKey: "modified_date")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.payment_status, forKey: "payment_status")
        dictionary.setValue(self.appointment_status, forKey: "appointment_status")
        dictionary.setValue(self.is_rating_given, forKey: "is_rating_given")
        
        return dictionary
    }
    
}
