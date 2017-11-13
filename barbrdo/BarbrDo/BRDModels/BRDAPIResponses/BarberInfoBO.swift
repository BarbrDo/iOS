//
//  BarberInfoBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 20/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BarberInfoBO: NSObject {
    public var _id : String?
    public var created_date : String?
    public var first_name : String?
    public var last_name : String?
    public var picture : String?
    public var ratings = [BRD_RatingsBO]()
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let barber_id_list = Barber_id.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Barber_id Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BarberInfoBO]
    {
        var models:[BarberInfoBO] = []
        for item in array
        {
            models.append(BarberInfoBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let barber_id = Barber_id(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Barber_id Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        created_date = dictionary["created_date"] as? String
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        picture = dictionary["picture"] as? String
        if (dictionary["ratings"] != nil) { ratings = BRD_RatingsBO.modelsFromDictionaryArray(array: dictionary["ratings"] as! NSArray) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.first_name, forKey: "first_name")
        dictionary.setValue(self.last_name, forKey: "last_name")
        dictionary.setValue(self.picture, forKey: "picture")
        
        return dictionary
    }
    
}
