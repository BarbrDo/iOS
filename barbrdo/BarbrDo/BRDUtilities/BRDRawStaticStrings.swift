//
//  BRDRawStaticStrings.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 08/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRDRawStaticStrings: NSObject {
    
    static let KEmptyString     =       ""
    static let KNextLine        =       "\n"
    static let kUserData               =       "UserData"

    static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    static func checkPhoneNumber(inputString: String) -> Bool{
    
        let numberCharacters = CharacterSet.decimalDigits.inverted
        return !inputString.isEmpty && inputString.rangeOfCharacter(from:numberCharacters) == nil
    }

}
