//
//  BRD_GalleyBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 13/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_GalleyBO: NSObject, NSCoding {
    public var creationDate : String?
    public var _id : String?
    public var name : String?
    public var created_date : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let gallery_list = Gallery.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Gallery Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BRD_GalleyBO]
    {
        var models:[BRD_GalleyBO] = []
        for item in array
        {
            models.append(BRD_GalleyBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let gallery = Gallery(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Gallery Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        creationDate = dictionary["creationDate"] as? String
        _id = dictionary["_id"] as? String
        name = dictionary["name"] as? String
        created_date = dictionary["created_date"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.creationDate, forKey: "creationDate")
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.created_date, forKey: "created_date")
        
        return dictionary
    }
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        self.creationDate = aDecoder.decodeObject(forKey: "creationDate") as? String ?? ""
        self._id = aDecoder.decodeObject(forKey: "_id") as? String ?? ""
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.created_date = aDecoder.decodeObject(forKey: "created_date") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.creationDate, forKey: "creationDate")
        aCoder.encode(self._id, forKey: "_id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.created_date, forKey: "created_date")
    }
}
