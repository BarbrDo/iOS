//
//  ShopChairsBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 20/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class ShopChairsBO: NSObject {
    public var shopDetail : BRD_ShopDataBO?
    public var chairbarber : [ChairBarberBO]?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ShopChairsBO]
    {
        var models:[ShopChairsBO] = []
        for item in array
        {
            models.append(ShopChairsBO(dictionary: item as! NSDictionary)!)
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
        
        if (dictionary["_id"] != nil) { shopDetail = BRD_ShopDataBO(dictionary: dictionary["_id"] as! NSDictionary) }
        if (dictionary["chair_barber"] != nil) { chairbarber = ChairBarberBO.modelsFromDictionaryArray(array: dictionary["chair_barber"] as! NSArray) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.shopDetail?.dictionaryRepresentation(), forKey: "_id")
        
        return dictionary
    }
    
}
