//
//  EventsAppointmentBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 07/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class EventsAppointmentBO: NSObject {
    public var appointments : [BarberAppointmentBO]?
    public var events : [EventsBO]?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     - returns: Array of Json4Swift_Base Instances.
     */
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [EventsAppointmentBO]{
        
        var models:[EventsAppointmentBO] = []
        for item in array
        {
            models.append(EventsAppointmentBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
 
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["appointments"] != nil) { appointments = BarberAppointmentBO.modelsFromDictionaryArray(array: dictionary["appointments"] as! NSArray) }
        if (dictionary["events"] != nil) { events = EventsBO.modelsFromDictionaryArray(array: dictionary["events"] as! NSArray) }
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
