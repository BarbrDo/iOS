//
//  BarberRequestBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 13/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BarberRequestBO: NSObject {
    public var _id : String?
    public var updatedAt : String?
    public var createdAt : String?
    public var shop_id : String?
    public var chair_id : String?
    public var chair_type : String?
    public var shop_percentage : Int?
    public var barber_percentage : Int?
    public var requested_by : String?
    public var barber_id : String?
    public var booking_date : String?
    public var status : String?
    public var created_date : String?
    public var __v : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let barberRequest_list = BarberRequest.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of BarberRequest Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BarberRequestBO]
    {
        var models:[BarberRequestBO] = []
        for item in array
        {
            models.append(BarberRequestBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let barberRequest = BarberRequest(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: BarberRequest Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        updatedAt = dictionary["updatedAt"] as? String
        createdAt = dictionary["createdAt"] as? String
        shop_id = dictionary["shop_id"] as? String
        chair_id = dictionary["chair_id"] as? String
        chair_type = dictionary["chair_type"] as? String
        shop_percentage = dictionary["shop_percentage"] as? Int
        barber_percentage = dictionary["barber_percentage"] as? Int
        requested_by = dictionary["requested_by"] as? String
        barber_id = dictionary["barber_id"] as? String
        booking_date = dictionary["booking_date"] as? String
        status = dictionary["status"] as? String
        created_date = dictionary["created_date"] as? String
        __v = dictionary["__v"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.updatedAt, forKey: "updatedAt")
        dictionary.setValue(self.createdAt, forKey: "createdAt")
        dictionary.setValue(self.shop_id, forKey: "shop_id")
        dictionary.setValue(self.chair_id, forKey: "chair_id")
        dictionary.setValue(self.chair_type, forKey: "chair_type")
        dictionary.setValue(self.shop_percentage, forKey: "shop_percentage")
        dictionary.setValue(self.barber_percentage, forKey: "barber_percentage")
        dictionary.setValue(self.requested_by, forKey: "requested_by")
        dictionary.setValue(self.barber_id, forKey: "barber_id")
        dictionary.setValue(self.booking_date, forKey: "booking_date")
        dictionary.setValue(self.status, forKey: "status")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.__v, forKey: "__v")
        
        return dictionary
    }
    
}
