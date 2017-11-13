//
//  BarberSearch.swift
//  BarbrDo
//
//  Created by Shami Kumar on 14/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BarberSearch: NSObject {
    public var _id : String?
    public var first_name : String?
    public var last_name : String?
    public var distance : Float?
    public var units : String?
    public var created_date : String?
    public var location : String?
    public var shop_id : String?
    public var ratings = [BarberRating]()
public var shopArray = [BRD_ShopDataBO]()
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BarberSearch]
{
    var models:[BarberSearch] = []
    for item in array
    {
    models.append(BarberSearch(dictionary: item as! NSDictionary)!)
    }
    return models
    }
    override init() {
        self._id = ""
        self.first_name = ""
        self.last_name = ""
        self.distance = nil
        self.shop_id = ""
        self.created_date = ""
        self.location = ""
        self.units = ""
        
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
    distance = dictionary["distance"] as? Float
    units = dictionary["units"] as? String
    created_date = dictionary["created_date"] as? String
    location = dictionary["location"] as? String
    shop_id = dictionary["shop_id"] as? String
        
        
         if(dictionary["ratings"] != nil)
         {
       ratings = dictionary["ratings"] as! [BarberRating]
        }
        if(dictionary["shop"] != nil)
        {

        shopArray = dictionary["shop"] as! [BRD_ShopDataBO]

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
    dictionary.setValue(self.distance, forKey: "distance")
    dictionary.setValue(self.units, forKey: "units")
    dictionary.setValue(self.created_date, forKey: "created_date")
    dictionary.setValue(self.location, forKey: "location")
    dictionary.setValue(self.shop_id, forKey: "shop_id")
        if(dictionary["ratings"] != nil)
        {
            ratings = BarberRating.modelsFromDictionaryArray(array: dictionary["ratings"] as! NSArray)
            
        }
        if(dictionary["shop"] != nil)
        {
            shopArray = BRD_ShopDataBO.modelsFromDictionaryArray(array: dictionary["shop"] as! NSArray)
            
        }

    
    return dictionary
    }
    
}
