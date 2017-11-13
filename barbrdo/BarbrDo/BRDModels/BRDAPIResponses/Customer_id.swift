/*
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Customer_id {
    public var _id : String?
    public var created_date : String?
    public var email : String?
    public var first_name : String?
    public var is_active : Int?
    public var is_deleted : Int?
    public var is_verified : Int?
    public var last_name : String?
    public var latLong : [Double]?
    public var mobile_number : Int?
    public var picture : String?
   // public var theRatings = [BRD_RatingsBO]()
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let customer_id_list = Customer_id.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Customer_id Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Customer_id]
    {
        var models:[Customer_id] = []
        for item in array
        {
            models.append(Customer_id(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let customer_id = Customer_id(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Customer_id Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        created_date = dictionary["created_date"] as? String
        email = dictionary["email"] as? String
        first_name = dictionary["first_name"] as? String
        is_active = dictionary["is_active"] as? Int
        is_deleted = dictionary["is_deleted"] as? Int
        is_verified = dictionary["is_verified"] as? Int
        last_name = dictionary["last_name"] as? String
        if (dictionary["latLong"] != nil) { latLong = dictionary["latLong"] as? [Double] }
        mobile_number = dictionary["mobile_number"] as? Int
        picture = dictionary["picture"] as? String
        //if (dictionary["ratings"] != nil) { theRatings = BRD_RatingsBO.modelsFromDictionaryArray(array: dictionary["ratings"] as! NSArray) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.first_name, forKey: "first_name")
        dictionary.setValue(self.is_active, forKey: "is_active")
        dictionary.setValue(self.is_deleted, forKey: "is_deleted")
        dictionary.setValue(self.is_verified, forKey: "is_verified")
        dictionary.setValue(self.last_name, forKey: "last_name")
        dictionary.setValue(self.mobile_number, forKey: "mobile_number")
        dictionary.setValue(self.picture, forKey: "picture")
        
        return dictionary
    }
    
}
