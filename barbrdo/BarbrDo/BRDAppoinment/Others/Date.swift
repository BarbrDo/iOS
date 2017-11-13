//
//  SADate.swift
//  SquadApp
//
//  Created by Vishwajeet Kumar on 1/16/17.
//  Copyright © 2017 Vishwajeet Kumar. All rights reserved.
//

import UIKit

extension Date {
    
    // time format
    public struct TimeFormat {
        static let hh_mm                = "hh:mm"
        static let HH_mm                = "HH:mm"
        static let hh_mm_a              = "hh:mm a"
        static let HH_mm_ss             = "HH:mm:ss"
        static let HH_mm_ss_SSSZ   = "HH:mm:ss.SSSZ"
    }
    //yyyy-MM-dd
    // date format
    public struct DateFormat {
        static let DD_MM_YYYY   = "dd/MM/yyyy"
        static let MM_d_yyyy            = "MM/d/yyyy"
        static let MM_dd_yyYY           =   "MM/dd/yyyy"
        static let dd_MM_yyyy           = "dd-MM-yyyy"
        static let d_MM                 = "d-MMM"
        static let MMM_dd               = "MMM dd"
        static let MMM_dd_yyyy          = "MMM dd yyyy"
        static let EEEE_MMM_dd          = "EEEE, MMMM dd"
        static let MMM_YYYY             = "MMM yyyy"

        static let yyyy_MM_dd           = "yyyy-MM-dd"
        static let yyyy_MM_dd_HH_mm     = "yyyy-MM-dd HH:mm"
        static let yyyy_MM_dd_HH_mm_ss  = "yyyy-MM-dd HH:mm:ss"
        static let yyyy_MM_dd_hh_mm     = "yyyy-MM-dd hh:mm"
        static let yyyy_MM_dd_hh_mm_a   = "yyyy-MM-dd hh:mm a"
        static let yyyy_MM_dd_h_mm_a    = "yyyy-MM-dd h:mm a"
        static let h_a    = "hh a"
        
        static let dd_MM_yyyy_hh_mm_a   = "dd MM yyyy hh:mm a"


        static let yyyy_MM_dd_T_HH_mm_ss_ssz   = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let yyyy_MM_dd_HH_mm_ss_   = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let yyyy_MM_dd_T_HH_mm_ss_   = "yyyy-MM-ddTHH:mm:ss.SSSZ"
        
        

        static let dd_MMMM_yyyy         = "dd MMMM yyyy" // 25 JUNE 2016
        static let yyyy_MM_dd_HH_mm_ss_z = "yyyy-MM-dd HH:mm:ss +z"
        
        static let MMM_dd_yyyy_hh_mm    = "MMM dd, yyyy  hh:mm a " // Aug 31, 2015
        static let EEE_MMM_dd_yyyy      = "EEE, MMM dd, yyyy" // Mon, Aug 31, 2015
        static let EEEE_MMMM_dd_yyyy    = "EEEE, MMMM dd, yyyy" // Monday, August 31, 2015
        static let EEEE_MMMM_dd    = "EEEE, MMMM dd" // Monday, August 31

        static let MMMM_dd    = "MMMM dd" // August 31
        
        static let MMMM_YYYY = "MMMM YYYY" // JUNE 2017
        static let MM_YYYY = "MM YYYY"
        static let EEEE_dd_MMMM = "EEEE, dd MMMM"
        static let YYYY_MM_DD =  "yyyy-MM-dd'T'"
        static let MMM_dd_yyyy_1 = "MMM dd, YYYY"
        
        static let EEE_MM_dd          = "MMM dd , yyyy"

    }
    /**
     * method      : convertDateTimeFormat
     * description : convert date time format
     * param1      : dateString
     * param2      : fromFormat
     * param3      : toFormat
     * return      : NSString
     */
    public static func convert(_ dateString: String, _ fromFormat: String, _ toFormat: String) ->  String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let date = dateFormatter.date(from: dateString as String)
        
        dateFormatter.dateFormat = toFormat as String
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        var dateFormatted : String = String()
        if let date = date {
            dateFormatted = dateFormatter.string(from: date)
        }
        return dateFormatted
    }
    
    public static func convertWithSystemTimeZone(_ dateString: String, _ fromFormat: String, _ toFormat: String) ->  String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let date = dateFormatter.date(from: dateString as String)
        
        dateFormatter.dateFormat = toFormat as String
        dateFormatter.timeZone = NSTimeZone.local
        var dateFormatted : String = String()
        if let date = date {
            dateFormatted = dateFormatter.string(from: date)
        }
        return dateFormatted
    }
    
    /**
     * method      : dateFromString
     * description : get date from string
     * param1      : dateString
     * param2      : fromFormat
     * return      : NSDate
     */
    public static func dateFromString(_ dateString: String, _ fromFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let dateFormated = dateFormatter.date(from: dateString)
        return dateFormated as Date?
    }
    
   
    
    /**
     * method      : stringFromDate
     * description : get string from date
     * param1      : date
     * param2      : fromFormat
     * return      : NSString
     */
    public static func stringFromDate(_ date: Date, _ fromFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone.current
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    
    
    public static func getTimeFromDate(_ date: Date) -> String {
        let theDateString = String(describing: date)
        
        
        let arr = theDateString.components(separatedBy: " ")
        
        if arr.count > 1{
            let obj = arr[1]
            print(obj[obj.index(obj.startIndex, offsetBy: 5)])
            return String(describing:obj[obj.index(obj.startIndex, offsetBy: 5)])
        }
        return ""
    }
    
    /**
     * method      : device12HoursTimeFormat
     * description : Check device time format is 12 hours or 24 hours
     * return      : Bool
     */
    public static func isDevice12HoursTimeFormat() -> Bool {
        let locale = NSLocale.current
        let formatter : NSString = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)! as NSString
        if formatter.contains("a") {
            return true // //phone is set to 12 hours
        } else {
            return false //phone is set to 24 hours
        }
    }
    
    /**
     * method      : calculateAge
     * description : calculate age from DOB
     * return      : Int, Int, Int
     */
    public func calculateAge() -> (Int, Int, Int)? {
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        let now = calendar.startOfDay(for: NSDate() as Date)
        let birthdate = calendar.startOfDay(for: self as Date)
        let unitFlags: NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute]
        let ageComponents = calendar.components(unitFlags, from: birthdate, to: now, options: [])
        
        var days: Int = 0
        var months: Int = 0
        var years: Int = 0
        
        if let day = ageComponents.day {
            days = day
        }
        if let month = ageComponents.month {
            months = month
        }
        if let year = ageComponents.year {
            years = year
        }
        return (days, months, years)
    }
    
    /**
     * method      : getCurrencyFormat
     * description : return the string value in price format
     * param1      : price
     * return      : String
     */
    public static func getCurrencyFormat(_ price: String) -> String {
        let convertPrice = NSNumber(value: Double(price)!)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD" // for county code view this http://www.science.co.il/International/Currency-codes.asp
        let convertedPrice = formatter.string(from: convertPrice)
        return convertedPrice!
    }
    
    
    public static func combineDateWithTime(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!
        mergedComponments.timeZone = nil
        return calendar.date(from: mergedComponments)
    }
}

