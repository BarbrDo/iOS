//
//  ManageRequestInfo.swift
//  BarbrDo
//
//  Created by Shami Kumar on 19/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class ManageRequestInfo: NSObject {
    public var booking_date : String?
    public var status : String?
    public var _id : String?
    public var name : String?
    public var isChairMatching : Bool?
    public var barberInfo : [BarberInfo]?
    public var shopChairInfo : ShopChairInfo?
    public var barberRequest : [BarberRequestBO]?

    public var requested_by : String?
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Json4Swift_Base Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        
        booking_date = dictionary["booking_date"] as? String
        status = dictionary["status"] as? String
        
        _id = dictionary["_id"] as? String
        name = dictionary["name"] as? String
        isChairMatching = dictionary["isChairMatching"] as? Bool
        requested_by = dictionary["requested_by"] as? String
        
        if (dictionary["barberInfo"] != nil)
        {
            barberInfo = BarberInfo.modelsFromDictionaryArray(array: dictionary["barberInfo"] as! NSArray)
        }

        
        if(dictionary["shopChairInfo"] != nil)
        {
            shopChairInfo = dictionary["shopChairInfo"] as? ShopChairInfo
        }

       
        
        
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [ManageRequestInfo]
    {
        var models:[ManageRequestInfo] = []
        for item in array
        {
            models.append(ManageRequestInfo(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.booking_date, forKey: "booking_date")
        dictionary.setValue(self.status, forKey: "status")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.isChairMatching, forKey: "isChairMatching")
        dictionary.setValue(self.requested_by, forKey: "requested_by")

        return dictionary
    }
    
}
