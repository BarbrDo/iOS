//
//  StatesBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 19/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class StatesBO: NSObject {
    public var _id : String?
    public var  abbreviation : String?
    public var is_active : Int?
    public var is_deleted : Int?
    public var name : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [StatesBO]
    {
        var models:[StatesBO] = []
        for item in array
        {
            models.append(StatesBO(dictionary: item as! NSDictionary)!)
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
        abbreviation = dictionary["abbreviation"] as? String
        is_active = dictionary["is_active"] as? Int
        is_deleted = dictionary["is_deleted"] as? Int
        name = dictionary["name"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.abbreviation, forKey: "abbreviation")
        dictionary.setValue(self.is_active, forKey: "is_active")
        dictionary.setValue(self.is_deleted, forKey: "is_deleted")
        dictionary.setValue(self.name, forKey: "name")
        
        return dictionary
    }
    
}
