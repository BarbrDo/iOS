//
//  BRDUtility.swift
//  BarbrDo
//
//  Created by Vishwajeet Kumar on 5/11/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRDUtility: NSObject {
    public class func validate(_ string: Any?) -> String {
        if let stringValue = string as? String {
            return stringValue
        }
        if let doubleValue = string as? Double {
            return "\(doubleValue)"
        }
        if let floatValue = string as? Float {
            return "\(floatValue)"
        }
        if let intValue = string as? Int {
            return "\(intValue)"
        }
        if let boolValue = string as? Bool {
            return "\(boolValue)"
        }
        return ""
    }

   public class func indexPath(_ tableView: UITableView, _ button: UIButton) -> IndexPath {
        let buttonFrame: CGRect = button.convert(button.bounds, to: tableView)
        return tableView.indexPathForRow(at: buttonFrame.origin)! as IndexPath
    }
    
    
}

extension String {
    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
    
    public func getMobileNumber(_ mobileNumber: String) -> String {
        var mobileNumber = mobileNumber.replacingOccurrences(of: "(", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "+", with: "")
        return mobileNumber
    }
}

extension UIColor {
    public class func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat? = 1.0) -> UIColor {
        return UIColor(red:red / 255.0, green:green / 255.0, blue:blue / 255.0, alpha:CGFloat(alpha!))
    }
}
