//
//  ChairRequestInfo.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 14/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class ChairRequestInfo: NSObject {
    public var __v : Int?
    public var updatedAt : String?
    public var createdAt : String?
    public var shop_id : String?
    public var chair_id : String?
    public var barber_id : String?
    public var booking_date : String?
    public var requested_by : String?
    public var status : String?
    public var _id : String?
    public var created_date : String?
    public var id : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ChairRequestInfo]
    {
        var models:[ChairRequestInfo] = []
        for item in array
        {
            models.append(ChairRequestInfo(dictionary: item as! NSDictionary)!)
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
        updatedAt = dictionary["updatedAt"] as? String
        createdAt = dictionary["createdAt"] as? String
        shop_id = dictionary["shop_id"] as? String
        chair_id = dictionary["chair_id"] as? String
        barber_id = dictionary["barber_id"] as? String
        booking_date = dictionary["booking_date"] as? String
        requested_by = dictionary["requested_by"] as? String
        status = dictionary["status"] as? String
        _id = dictionary["_id"] as? String
        created_date = dictionary["created_date"] as? String
        id = dictionary["id"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self.updatedAt, forKey: "updatedAt")
        dictionary.setValue(self.createdAt, forKey: "createdAt")
        dictionary.setValue(self.shop_id, forKey: "shop_id")
        dictionary.setValue(self.chair_id, forKey: "chair_id")
        dictionary.setValue(self.barber_id, forKey: "barber_id")
        dictionary.setValue(self.booking_date, forKey: "booking_date")
        dictionary.setValue(self.requested_by, forKey: "requested_by")
        dictionary.setValue(self.status, forKey: "status")
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.id, forKey: "id")
        
        return dictionary
    }
    
}
