//
//  ServerPlans.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 11/09/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class ServerPlans: NSObject {
    public var __v : Int?
    public var _id : String?
    public var apple_id : String?
    public var created_date : String?
    public var duration : Int?
    public var google_id : String?
    public var is_active : Bool?
    public var is_deleted : Bool?
    public var name : String?
    public var price : Double?
    public var short_description : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ServerPlans]
    {
        var models:[ServerPlans] = []
        for item in array
        {
            models.append(ServerPlans(dictionary: item as! NSDictionary)!)
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
        apple_id = dictionary["apple_id"] as? String
        created_date = dictionary["created_date"] as? String
        duration = dictionary["duration"] as? Int
        google_id = dictionary["google_id"] as? String
        is_active = dictionary["is_active"] as? Bool
        is_deleted = dictionary["is_deleted"] as? Bool
        name = dictionary["name"] as? String
        price = dictionary["price"] as? Double
        short_description = dictionary["short_description"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.apple_id, forKey: "apple_id")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.duration, forKey: "duration")
        dictionary.setValue(self.google_id, forKey: "google_id")
        dictionary.setValue(self.is_active, forKey: "is_active")
        dictionary.setValue(self.is_deleted, forKey: "is_deleted")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.price, forKey: "price")
        dictionary.setValue(self.short_description, forKey: "short_description")
        
        return dictionary
    }
    
}
