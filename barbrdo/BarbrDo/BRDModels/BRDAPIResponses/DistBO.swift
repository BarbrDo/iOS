//
//  DistBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 31/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class DistBO: NSObject {
    public var calculated : Int?
    public var location : Array<Double>?
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [DistBO]
    {
        var models:[DistBO] = []
        for item in array
        {
            models.append(DistBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    
    required public init?(dictionary: NSDictionary) {
        
        calculated = dictionary["calculated"] as? Int
        //if (dictionary["location"] != nil) { location = Location.modelsFromDictionaryArray(dictionary["location"] as! NSArray) }
    }
    
   
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.calculated, forKey: "calculated")
        
        return dictionary
    }
    
}
