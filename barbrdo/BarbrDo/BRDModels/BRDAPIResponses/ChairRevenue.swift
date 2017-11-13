//
//  ChairRevenue.swift
//  BarbrDo
//
//  Created by Shami Kumar on 20/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class ChairRevenue: NSObject {
    var chair_revenue : Float? = 0.0
     var _id : String? = ""
    public class func modelsFromDictionaryArray(array:NSArray) -> [ChairRevenue]
    {
        var models:[ChairRevenue] = []
        for item in array
        {
            models.append(ChairRevenue(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    override init() {
        
        //        self._id = nil
        self.chair_revenue = 0.0
        self._id = ""
        
    }
    
    required public init?(dictionary: NSDictionary) {
        
        
               _id = dictionary["_id"] as? String
        chair_revenue = dictionary["chair_revenue"] as? Float
        
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
             dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.chair_revenue, forKey: "chair_revenue")
        
        
        
        
        return dictionary
    }
}
