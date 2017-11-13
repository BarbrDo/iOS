//
//  ChairBarberBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 20/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class ChairBarberBO: NSObject {
    public var chair : BRD_ChairInfo?
    public var barber : [BRD_BarberInfoBO]?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let chair-barber_list = Chair-barber.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Chair-barber Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ChairBarberBO]
{
    var models:[ChairBarberBO] = []
    for item in array
    {
    models.append(ChairBarberBO(dictionary: item as! NSDictionary)!)
    }
    return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let chair-barber = Chair-barber(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Chair-barber Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["chair"] != nil) { chair = BRD_ChairInfo(dictionary: dictionary["chair"] as! NSDictionary) }
        if (dictionary["barber"] != nil) { barber = BRD_BarberInfoBO.modelsFromDictionaryArray(array: dictionary["barber"] as! NSArray) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.chair?.dictionaryRepresentation(), forKey: "chair")
        return dictionary
    }
    
}
