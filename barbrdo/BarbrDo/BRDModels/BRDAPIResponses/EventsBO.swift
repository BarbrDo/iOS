//
//  EventsBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 07/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class EventsBO: NSObject {
    public var dayoff : Bool?
    public var repeatEvent : [String]?
    public var _id : String?
    public var draggable : String?
    public var resizable : String?
    public var endsAt : String?
    public var startsAt : String?
    public var title : String?
    public var objShopEvents: ShopsEventBO? = nil
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let events_list = Events.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Events Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [EventsBO]
    {
        var models:[EventsBO] = []
        for item in array
        {
            models.append(EventsBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    
     override init() {
        
        dayoff = false
        //if (dictionary["repeat"] != nil) { repeat1 = Repeat.modelsFromDictionaryArray(dictionary["repeat"] as! NSArray) }
        repeatEvent = []
        _id = ""
        draggable = ""
        resizable = ""
        endsAt = ""
        startsAt = ""
        title = ""
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let events = Events(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Events Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        dayoff = dictionary["dayoff"] as? Bool
        if (dictionary["repeat"] != nil) {
            repeatEvent = dictionary["repeat"] as? [String]
        }
        _id = dictionary["_id"] as? String
        draggable = dictionary["draggable"] as? String
        resizable = dictionary["resizable"] as? String
        endsAt = dictionary["endsAt"] as? String
        startsAt = dictionary["startsAt"] as? String
        title = dictionary["title"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.dayoff, forKey: "dayoff")
        dictionary.setValue(self._id, forKey: "_id")
        
        dictionary.setValue(self.repeatEvent, forKey: "repeat")
        dictionary.setValue(self.draggable, forKey: "draggable")
        dictionary.setValue(self.resizable, forKey: "resizable")
        dictionary.setValue(self.endsAt, forKey: "endsAt")
        dictionary.setValue(self.startsAt, forKey: "startsAt")
        dictionary.setValue(self.title, forKey: "title")
        
        return dictionary
    }
    
}
