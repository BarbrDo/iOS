//
//  Notification.swift
//  BarbrDo
//
//  Created by Shami Kumar on 24/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class NotificationDisplay: NSObject {
    public var text : String?
    public var key : String?
    public var created_date : String?
    public var _id : String?
    public var triggered_by_name : String?
    public var triggered_by_user_id : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    override init() {
        self._id = ""
        self.created_date = ""
      self.text  = ""
    self.key = ""
self.triggered_by_name = ""
        self.triggered_by_user_id = ""
        
        
    }
    public class func modelsFromDictionaryArray(array:NSArray) -> [NotificationDisplay]
    {
        var models:[NotificationDisplay] = []
        for item in array
        {
            models.append(NotificationDisplay(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Json4Swift_Base Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        created_date = dictionary["created_date"] as? String
        key = dictionary["key"] as? String
        text = dictionary["text"] as? String
        triggered_by_user_id = dictionary["triggered_by_user_id"] as? String
        triggered_by_name = dictionary["triggered_by_name"] as? String

    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.created_date, forKey: "rated_by")
        dictionary.setValue(self.key, forKey: "key")
        dictionary.setValue(self.text, forKey: "text")
        
        dictionary.setValue(self.triggered_by_user_id, forKey: "triggered_by_user_id")
        dictionary.setValue(self.triggered_by_name, forKey: "triggered_by_name")

        
        return dictionary
    }

}
