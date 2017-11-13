//
//  GooglePlacesBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 01/09/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class GooglePlacesBO: NSObject {
   
    public var placeName : String?
    public var placeID : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [GooglePlacesBO]
    {
        var models:[GooglePlacesBO] = []
        for item in array
        {
            models.append(GooglePlacesBO(dictionary: item as! NSDictionary)!)
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
        
        
        placeName = dictionary["description"] as? String
        placeID = dictionary["placeId"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.placeName, forKey: "description")
        dictionary.setValue(self.placeID, forKey: "id")
        
        return dictionary
    }
    
}
