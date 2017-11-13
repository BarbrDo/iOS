//
//  RevenueBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 09/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class RevenueBO: NSObject {
    public var totalCuts : Int?
    public var revenue : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let revenue_list = Revenue.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Revenue Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [RevenueBO]
    {
        var models:[RevenueBO] = []
        for item in array
        {
            models.append(RevenueBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let revenue = Revenue(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Revenue Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        totalCuts = dictionary["totalCuts"] as? Int
        revenue = dictionary["revenue"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.totalCuts, forKey: "totalCuts")
        dictionary.setValue(self.revenue, forKey: "revenue")
        
        return dictionary
    }
    
}
