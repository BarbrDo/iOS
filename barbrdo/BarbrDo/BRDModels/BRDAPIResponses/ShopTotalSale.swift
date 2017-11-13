//
//  ShopTotalSale.swift
//  BarbrDo
//
//  Created by Shami Kumar on 20/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class ShopTotalSale: NSObject {
    var price : Float? = 0.0
    public class func modelsFromDictionaryArray(array:NSArray) -> [ShopTotalSale]
    {
        var models:[ShopTotalSale] = []
        for item in array
        {
            models.append(ShopTotalSale(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    override init() {
        
        //        self._id = nil
        self.price = 0.0
        
        
    }
    
    required public init?(dictionary: NSDictionary) {
        
        
        //        _id = dictionary["_id"] as? String
        price = dictionary["price"] as? Float
        
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        //        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.price, forKey: "price")
        
        
        
        
        return dictionary
    }

}
