//
//  TotalSale.swift
//  BarbrDo
//
//  Created by Shami Kumar on 11/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class TotalSale: NSObject {
//    var _id : String? = nil
    var total_sale : Float? = 0.0
    public class func modelsFromDictionaryArray(array:NSArray) -> [TotalSale]
    {
        var models:[TotalSale] = []
        for item in array
        {
            models.append(TotalSale(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    override init() {
        
//        self._id = nil
        self.total_sale = 0.0
        
        
    }
    
    required public init?(dictionary: NSDictionary) {
        
        
//        _id = dictionary["_id"] as? String
        total_sale = dictionary["total_sale"] as? Float
        
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
//        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.total_sale, forKey: "total_sale")
        
        
        
        
        return dictionary
    }
    
}
