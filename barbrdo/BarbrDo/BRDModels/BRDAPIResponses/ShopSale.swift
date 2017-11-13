//
//  ShopSale.swift
//  BarbrDo
//
//  Created by Shami Kumar on 20/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class ShopSale: NSObject {
    public var shoptotalSale : [ShopTotalSale]?
    public var shopmonthSale : [ShopMonthSale]?
    public var shopweekSale : [ShopWeekSale]?
    public var shopcustom : [ShopFinanceSale]?
    public var chairRevenue : [ChairRevenue]?
    public class func modelsFromDictionaryArray(array:NSArray) -> [ShopSale]
    {
        var models:[ShopSale] = []
        for item in array
        {
            models.append(ShopSale(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        
        if (dictionary["totalSale"] != nil) { shoptotalSale = ShopTotalSale.modelsFromDictionaryArray(array: dictionary["totalSale"] as! NSArray) }
        if (dictionary["monthSale"] != nil) { shopmonthSale = ShopMonthSale.modelsFromDictionaryArray(array: dictionary["monthSale"] as! NSArray) }
        if (dictionary["weekSale"] != nil) { shopweekSale = ShopWeekSale.modelsFromDictionaryArray(array: dictionary["weekSale"] as! NSArray) }
        if (dictionary["custom"] != nil){shopcustom = ShopFinanceSale.modelsFromDictionaryArray(array: dictionary["custom"] as! NSArray) }

        if (dictionary["chairRevenue"] != nil){chairRevenue = ChairRevenue.modelsFromDictionaryArray(array: dictionary["chairRevenue"] as! NSArray) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        
        
        return dictionary
    }

}
