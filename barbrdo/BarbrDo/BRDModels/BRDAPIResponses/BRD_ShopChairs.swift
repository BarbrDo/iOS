//
//  BRD_ShopChairs.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 31/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_ShopChairs: NSObject {
    public var isActive : Bool?
    public var created_date : String?
    public var modified_date : String?
    public var _id : String?
    public var availability : String?
    public var name : String?
    public var booking_start : String?
    public var type : String?
    public var booking_end : String?
    public var amount : Double?
    public var barber_id : String?
    public var barber_name : String?
    public var shop_percentage : Int?
    public var barber_percentage : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let chairs_list = Chairs.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Chairs Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BRD_ShopChairs]
    {
        var models:[BRD_ShopChairs] = []
        for item in array
        {
            models.append(BRD_ShopChairs(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let chairs = Chairs(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Chairs Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        isActive = dictionary["isActive"] as? Bool
        created_date = dictionary["created_date"] as? String
        modified_date = dictionary["modified_date"] as? String
        _id = dictionary["_id"] as? String
        availability = dictionary["availability"] as? String
        name = dictionary["name"] as? String
        booking_start = dictionary["booking_start"] as? String
        type = dictionary["type"] as? String
        booking_end = dictionary["booking_end"] as? String
        amount = dictionary["amount"] as? Double
        barber_id = dictionary["barber_id"] as? String
        barber_name = dictionary["barber_name"] as? String
        shop_percentage = dictionary["shop_percentage"] as? Int
        barber_percentage = dictionary["barber_percentage"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.isActive, forKey: "isActive")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.modified_date, forKey: "modified_date")
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.availability, forKey: "availability")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.booking_start, forKey: "booking_start")
        dictionary.setValue(self.type, forKey: "type")
        dictionary.setValue(self.booking_end, forKey: "booking_end")
        dictionary.setValue(self.amount, forKey: "amount")
        dictionary.setValue(self.barber_id, forKey: "barber_id")
        dictionary.setValue(self.barber_name, forKey: "barber_name")
        dictionary.setValue(self.shop_percentage, forKey: "shop_percentage")
        dictionary.setValue(self.barber_percentage, forKey: "barber_percentage")
        
        return dictionary
    }
    
}
