//
//  MorningBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 22/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class MorningBO: NSObject {
    public var time : String?
    public var isAvailable : Bool?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let morning_list = Morning.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Morning Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [MorningBO]
    {
        var models:[MorningBO] = []
        for item in array
        {
            models.append(MorningBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let morning = Morning(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Morning Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        time = dictionary["time"] as? String
        isAvailable = dictionary["isAvailable"] as? Bool
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.time, forKey: "time")
        dictionary.setValue(self.isAvailable, forKey: "isAvailable")
        
        return dictionary
    }
    
}
