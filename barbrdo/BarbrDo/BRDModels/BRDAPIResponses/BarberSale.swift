//
//  BarberSale.swift
//  BarbrDo
//
//  Created by Shami Kumar on 12/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BarberSale: NSObject {
    public var totalSale : [TotalSale]?
    public var monthSale : [MonthSale]?
    public var weekSale : [WeekSale]?
    public var custom : [FinanceSale]?
      public class func modelsFromDictionaryArray(array:NSArray) -> [BarberSale]
    {
        var models:[BarberSale] = []
        for item in array
        {
            models.append(BarberSale(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
     required public init?(dictionary: NSDictionary) {
        
       
        if (dictionary["totalSale"] != nil) { totalSale = TotalSale.modelsFromDictionaryArray(array: dictionary["totalSale"] as! NSArray) }
        if (dictionary["monthSale"] != nil) { monthSale = MonthSale.modelsFromDictionaryArray(array: dictionary["monthSale"] as! NSArray) }
        if (dictionary["weekSale"] != nil) { weekSale = WeekSale.modelsFromDictionaryArray(array: dictionary["weekSale"] as! NSArray) }
       
    if (dictionary["custom"] != nil)
    {
        custom = FinanceSale.modelsFromDictionaryArray(array: dictionary["custom"] as! NSArray) }
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
