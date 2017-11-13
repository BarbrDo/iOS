//
//  AssociatedShopsBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 09/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class AssociatedShopsBO: NSObject {
    public var _id : String?
    public var shop_id : String?
    public var barber_id : String?
    public var __v : Int?
    public var is_default: Bool?
    public var shopInfo : [BRD_ShopDataBO]?
    
    
    override init() {
    
        self._id = ""
        self.shop_id = ""
        self.barber_id = ""
        self.__v = 0
        self.is_default = false
        //self.shopInfo = BRD_ShopDataBO(dictionary: <#NSDictionary#>)
    }
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [AssociatedShopsBO]
    {
        var models:[AssociatedShopsBO] = []
        for item in array
        {
            models.append(AssociatedShopsBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
   
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        shop_id = dictionary["shop_id"] as? String
        barber_id = dictionary["barber_id"] as? String
        __v = dictionary["__v"] as? Int
        is_default = dictionary["is_default"] as? Bool
        if (dictionary["shopInfo"] != nil) { shopInfo = BRD_ShopDataBO.modelsFromDictionaryArray(array: dictionary["shopInfo"] as! NSArray) }
    }
    
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.shop_id, forKey: "shop_id")
        dictionary.setValue(self.barber_id, forKey: "barber_id")
        dictionary.setValue(self.__v, forKey: "__v")
        
        return dictionary
    }
    
}
