//
//  ShopInfoBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 20/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class ShopInfoBO: NSObject {
    public var _id : String?
    public var address : String?
    public var city : String?
    public var created_date : String?
    public var latLong = [Double]()
    public var name : String?
    public var state : String?
    public var user_id : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let shop_id_list = Shop_id.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Shop_id Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ShopInfoBO]
    {
        var models:[ShopInfoBO] = []
        for item in array
        {
            models.append(ShopInfoBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let shop_id = Shop_id(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Shop_id Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        address = dictionary["address"] as? String
        city = dictionary["city"] as? String
        created_date = dictionary["created_date"] as? String
        if (dictionary["latLong"] != nil) { latLong = (dictionary["latLong"] as! NSArray) as! [Double] }
        name = dictionary["name"] as? String
        state = dictionary["state"] as? String
        user_id = dictionary["user_id"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.city, forKey: "city")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.state, forKey: "state")
        dictionary.setValue(self.user_id, forKey: "user_id")
        
        return dictionary
    }
    
}
