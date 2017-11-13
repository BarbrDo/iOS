//
//  BarberListBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 03/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BarberListBO: NSObject {
    public var _id : String?
    public var first_name : String?
    public var last_name : String?
    public var email : String?
    public var mobile_number : Int?
    public var gallery : [BRD_GalleyBO]?
    public var ratings : [BRD_RatingsBO]?
    public var barber_services = [BRD_ServicesBO]()
    public var is_available : Bool?
    public var is_favourite: Bool?
    public var is_online : Bool?
    public var picture : String?
    public var distance : Double?
    public var units : String?
    public var barber_shops : BRD_BarberShopsBO?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BarberListBO]
    {
        var models:[BarberListBO] = []
        for item in array
        {
            models.append(BarberListBO(dictionary: item as! NSDictionary)!)
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
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        email = dictionary["email"] as? String
        mobile_number = dictionary["mobile_number"] as? Int
        if (dictionary["gallery"] != nil) { gallery = BRD_GalleyBO.modelsFromDictionaryArray(array: dictionary["gallery"] as! NSArray) }
        if (dictionary["ratings"] != nil) { ratings = BRD_RatingsBO.modelsFromDictionaryArray(array: dictionary["ratings"] as! NSArray)
        

            
        }
        if (dictionary["barber_services"] != nil) { barber_services = BRD_ServicesBO.modelsFromDictionaryArray(array: dictionary["barber_services"] as! NSArray) }
        is_available = dictionary["is_available"] as? Bool
        is_online = dictionary["is_online"] as? Bool
        picture = dictionary["picture"] as? String
        distance = dictionary["distance"] as? Double
        units = dictionary["units"] as? String
        is_favourite = dictionary["is_favourite"] as? Bool
        if (dictionary["barber_shops"] != nil) {
            //barber_shops = BRD_BarberShopsBO(dictionary: dictionary["barber_shops"] as! NSDictionary)
        
       barber_shops = BRD_BarberShopsBO.init(dictionary: dictionary["barber_shops"] as! NSDictionary)
        }
        
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.first_name, forKey: "first_name")
        dictionary.setValue(self.last_name, forKey: "last_name")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.mobile_number, forKey: "mobile_number")
        dictionary.setValue(self.is_available, forKey: "is_available")
        dictionary.setValue(self.is_online, forKey: "is_online")
        dictionary.setValue(self.picture, forKey: "picture")
        dictionary.setValue(self.distance, forKey: "distance")
        dictionary.setValue(self.units, forKey: "units")
        dictionary.setValue(self.is_favourite, forKey: "is_favourite")
        //dictionary.setValue(self.barber_shops?.dictionaryRepresentation(), forKey: "barber_shops")
        
        return dictionary
    }
    
}
