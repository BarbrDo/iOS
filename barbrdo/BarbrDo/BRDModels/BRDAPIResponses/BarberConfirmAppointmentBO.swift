//
//  BarberConfirmAppointmentBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 16/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BarberConfirmAppointmentBO: NSObject {
    public var barberInfo : BarberInfo?
    public var appointmentInfo : AppointmentInfoBO?
    public var shop_lat_long : [Double]?
    public var customer_lat_long : [Double]?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BarberConfirmAppointmentBO]
    {
        var models:[BarberConfirmAppointmentBO] = []
        for item in array
        {
            models.append(BarberConfirmAppointmentBO(dictionary: item as! NSDictionary)!)
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
    
    override init() {
        
        self.barberInfo = BarberInfo()
        self.appointmentInfo = AppointmentInfoBO()
        self.shop_lat_long = []
        self.customer_lat_long = []
    }
    
    required public init?(dictionary: NSDictionary) {
        print(dictionary)
        
        if (dictionary["barberInfo"] != nil) { barberInfo = BarberInfo(dictionary: dictionary["barberInfo"] as! NSDictionary) }
        if (dictionary["appointmentInfo"] != nil) { appointmentInfo = AppointmentInfoBO(dictionary: dictionary["appointmentInfo"] as! NSDictionary) }
        if (dictionary["shop_lat_long"] != nil) { shop_lat_long = dictionary["shop_lat_long"] as? [Double] }
        if (dictionary["customer_lat_long"] != nil) { customer_lat_long = dictionary["customer_lat_long"] as? [Double] }
    }
    
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.barberInfo?.dictionaryRepresentation(), forKey: "barberInfo")
        dictionary.setValue(self.appointmentInfo?.dictionaryRepresentation(), forKey: "appointmentInfo")
        
        return dictionary
    }
    
}
