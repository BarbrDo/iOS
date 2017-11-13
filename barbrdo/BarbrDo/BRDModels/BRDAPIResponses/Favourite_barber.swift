//
//  Favourite_barber.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 17/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class Favourite_barber: NSObject {
    public var created_date : String?
    public var _id : String?
    public var barber_id : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let favourite_barber_list = Favourite_barber.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Favourite_barber Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Favourite_barber]
    {
        var models:[Favourite_barber] = []
        for item in array
        {
            models.append(Favourite_barber(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let favourite_barber = Favourite_barber(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Favourite_barber Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        created_date = dictionary["created_date"] as? String
        _id = dictionary["_id"] as? String
        barber_id = dictionary["barber_id"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.barber_id, forKey: "barber_id")
        
        return dictionary
    }
    
}
