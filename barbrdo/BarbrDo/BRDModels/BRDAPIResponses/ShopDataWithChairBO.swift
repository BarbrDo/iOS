//
//  ShopDataWithChairBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 13/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class ShopDataWithChairBO: NSObject {
    public var _id : String?
    public var name : String?
    public var license_number : String?
    public var ratings : [BRD_RatingsBO]?
    public var latitude: Double?
    public var longitude: Double?
    public var state : String?
    public var city : String?
    public var zip : Int?
    public var address : String?
    public var chairs : [BRD_ChairInfo]?
    public var shop_user_id: String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ShopDataWithChairBO]
    {
        var models:[ShopDataWithChairBO] = []
        for item in array
        {
            models.append(ShopDataWithChairBO(dictionary: item as! NSDictionary)!)
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
        name = dictionary["name"] as? String
        license_number = dictionary["license_number"] as? String
        if (dictionary["ratings"] != nil) { ratings = BRD_RatingsBO.modelsFromDictionaryArray(array: dictionary["ratings"] as! NSArray) }
        
        if dictionary["latLong"] != nil{
            if let latLong = dictionary["latLong"] as? [Double]{
                latitude = latLong[1]
                longitude = latLong[0]
            }
        }
        state = dictionary["state"] as? String
        city = dictionary["city"] as? String
        zip = dictionary["zip"] as? Int
        address = dictionary["address"] as? String
        if (dictionary["chairs"] != nil) { chairs = BRD_ChairInfo.modelsFromDictionaryArray(array: dictionary["chairs"] as! NSArray) }
        shop_user_id = dictionary["shop_user_id"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.license_number, forKey: "license_number")
        dictionary.setValue(self.state, forKey: "state")
        dictionary.setValue(self.city, forKey: "city")
        dictionary.setValue(self.zip, forKey: "zip")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.shop_user_id, forKey: "shop_user_id")
        return dictionary
    }
    
}
