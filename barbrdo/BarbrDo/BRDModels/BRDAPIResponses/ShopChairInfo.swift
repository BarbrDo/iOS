//
//  ShopChairInfo.swift
//  BarbrDo
//
//  Created by Shami Kumar on 24/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class ShopChairInfo: NSObject {

    var _id : String? = ""
    var name : String? = ""
    public class func modelsFromDictionaryArray(array:NSArray) -> [ShopChairInfo]
    {
        var models:[ShopChairInfo] = []
        for item in array
        {
            models.append(ShopChairInfo(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    override init() {
        
      
     
        
    }
    
  required public init?(dictionary: NSDictionary) {
        
        
        _id = dictionary["_id"] as? String
        name = dictionary["name"] as? String
        
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.name, forKey: "name")
       
        
        
        
        return dictionary
    }

}
