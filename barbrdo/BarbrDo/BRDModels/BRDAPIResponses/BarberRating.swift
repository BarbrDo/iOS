//
//  BarberRating.swift
//  BarbrDo
//
//  Created by Shami Kumar on 14/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//



import UIKit

class BarberRating: NSObject
{

public var rated_by : String?
public var rated_by_name : String?
public var score : Float?
public var appointment_date : String?
public var _id : String?


/**
 Returns an array of models based on given dictionary.
 
 Sample usage:
 let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
 
 - parameter array:  NSArray from JSON dictionary.
 
 - returns: Array of Json4Swift_Base Instances.
 */
override init() {
    self._id = ""
    self.rated_by = ""
    self.rated_by_name = ""
    self.score = nil
    self.appointment_date = ""
    
    
}
    public class func modelsFromDictionaryArray(array:NSArray) -> [BarberRating]
    {
        var models:[BarberRating] = []
        for item in array
        {
            models.append(BarberRating(dictionary: item as! NSDictionary)!)
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
    rated_by = dictionary["rated_by"] as? String
    rated_by_name = dictionary["rated_by_name"] as? String
    score = dictionary["score"] as? Float
    appointment_date = dictionary["appointment_date"] as? String
   
    
}

/**
 Returns the dictionary representation for the current instance.
 
 - returns: NSDictionary.
 */
public func dictionaryRepresentation() -> NSDictionary {
    
    let dictionary = NSMutableDictionary()
    
    dictionary.setValue(self._id, forKey: "_id")
    dictionary.setValue(self.rated_by, forKey: "rated_by")
    dictionary.setValue(self.rated_by_name, forKey: "rated_by_name")
    dictionary.setValue(self.score, forKey: "score")
    dictionary.setValue(self.appointment_date, forKey: "appointment_date")
    
    
    
    return dictionary
}
}
