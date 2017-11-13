//
//  BRD_RatingsBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 13/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_RatingsBO: NSObject, NSCoding {
    
    
    public var _id : String?
    public var appointment_date: String?
    public var rated_by_name: String?
    
    public var comments : String?
    public var score : Float?
    public var rated_by : String?
    
    public var picture : String?
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let ratings_list = Ratings.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Ratings Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BRD_RatingsBO]
    {
        var models:[BRD_RatingsBO] = []
        for item in array
        {
            models.append(BRD_RatingsBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let ratings = Ratings(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Ratings Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        comments = dictionary["comments"] as? String
        score = dictionary["score"] as? Float
        rated_by = dictionary["rated_by"] as? String
        
        _id = dictionary["_id"] as? String
        appointment_date = dictionary["appointment_date"] as? String
        rated_by_name = dictionary["rated_by_name"] as? String
        
        picture = dictionary["picture"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.comments, forKey: "comments")
        dictionary.setValue(self.score, forKey: "score")
        dictionary.setValue(self.rated_by, forKey: "rated_by")
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.appointment_date, forKey: "appointment_date")
        dictionary.setValue(self.rated_by_name, forKey: "rated_by_name")
        
        return dictionary
    }
    
    required init(coder aDecoder: NSCoder) {
        self.comments = aDecoder.decodeObject(forKey: "comments") as? String ?? ""
        self.score = aDecoder.decodeObject(forKey: "score") as? Float ?? 0.0
        self.rated_by = aDecoder.decodeObject(forKey: "rated_by") as? String ?? ""
        
        self._id = aDecoder.decodeObject(forKey: "_id") as? String ?? ""
        self.appointment_date = aDecoder.decodeObject(forKey: "appointment_date") as? String ?? ""
        self.rated_by_name = aDecoder.decodeObject(forKey: "rated_by_name") as? String ?? ""
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.comments, forKey: "comments")
        aCoder.encode(self.score, forKey: "score")
        aCoder.encode(self.rated_by, forKey: "rated_by")
        
        aCoder.encode(self.comments, forKey: "_id")
        aCoder.encode(self.comments, forKey: "appointment_date")
        aCoder.encode(self.comments, forKey: "rated_by_name")
    }
    
}
