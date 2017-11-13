//
//  BRD_FacebookDetailsBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 13/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_FacebookDetailsBO: NSObject {
    
    var id: String?
    var name: String?
    var fname: String?
    var lname: String?
    var email: String?
    var mobileNumber: String?
    
    
    func initWithDictionary(dictionary: [String: Any]) {
        
        self.id =  dictionary["id"] as! String? ?? ""
        self.name = dictionary["name"] as! String? ?? ""
        self.fname = dictionary["first_name"] as! String? ?? ""
        self.lname = dictionary["last_name"] as! String? ?? ""
        self.email = dictionary["email"] as! String? ?? ""
        self.mobileNumber = ""
    }
    
}


