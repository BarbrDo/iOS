//
//  BRDTimeSlot.swift
//  BarbrDo
//
//  Created by Vishwajeet Kumar on 5/11/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRDTimeSlot {
    public var mornings: [MorningBO]?
    public var afternoons: [AfternoonBO]?
    public var evenings: [EveningBO]?
    
//    required public init?(_ dictionary: [String: Any]) {
//        if let morningArray = dictionary["morning"] as? [String] {
//            self.mornings = morningArray
//        }
//        if let afternoonArray = dictionary["afternoon"] as? [String] {
//            self.afternoons = afternoonArray
//        }
//        if let eveningArray = dictionary["evening"] as? [String] {
//            self.evenings = eveningArray
//        }
//    }
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [BRDTimeSlot]
    {
        var models:[BRDTimeSlot] = []
        for item in array
        {
            models.append(BRDTimeSlot(dictionary: item as! NSDictionary)!)
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
        
        if (dictionary["morning"] != nil) { mornings = MorningBO.modelsFromDictionaryArray(array: dictionary["morning"] as! NSArray)
        }
        if (dictionary["afternoon"] != nil) { afternoons = AfternoonBO.modelsFromDictionaryArray(array: dictionary["afternoon"] as! NSArray)
        }
        if (dictionary["evening"] != nil) { evenings = EveningBO.modelsFromDictionaryArray(array: dictionary["evening"] as! NSArray)
        }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        
        return dictionary
    }

}

