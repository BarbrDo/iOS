//
//  BRD_Customer_AppointmentDetail_AppointmentBooked_TableViewCell.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 08/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_Customer_AppointmentDetail_AppointmentBooked_TableViewCell_CellIdentifier = "BRD_Customer_AppointmentDetail_AppointmentBooked_TableViewCell_CellIdentifier"
class BRD_Customer_AppointmentDetail_AppointmentBooked_TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblAppointmentBooked: UILabel!
    
    @IBOutlet weak var viewAppointmentBooked: UIView!
    @IBOutlet weak var viewDate: UIView!
    
    @IBOutlet weak var lblDate: UIButton!
    @IBOutlet weak var lblTime: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // self.viewAppointmentBooked.round(corners: [.topLeft, .topRight], radius: 3.0, borderColor: UIColor.clear, borderWidth: 1.0)
       // self.viewDate.round(corners: [.bottomRight, .bottomLeft], radius: 3.0, borderColor: UIColor.clear, borderWidth: 1.0)
    }
    
    override func layoutSubviews() {
       //
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initWithData(obj: BRD_AppointmentsInfoBO){
        
        let data = self.convertDateString(obj: obj.appointment_date!)
        
        
        self.lblDate.setTitle(data, for: .normal)
        
        let time12 = self.calculateTime(dateString: obj.appointment_date!)
        
        self.lblTime.setTitle(time12, for: .normal)

    }
    
    
    
    func convertDateString(obj: String) -> String?{
        let myDate = obj //obj.appointment_date // "2016-06-20T13:01:46.457+02:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from:myDate)!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:date)
        
        print(dateString)
        
        return self.getDayOfWeek(dateString)
    }
    
    func getDayOfWeek(_ today:String) -> String? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        let day = myCalendar.component(.day, from: todayDate)
        let month = myCalendar.component(.month, from: todayDate)
        
        let weekDay1 = self.getWeekDay(value: myCalendar.component(.weekday, from: todayDate))
        let monthName = self.getMonth(value: myCalendar.component(.month, from: todayDate))
        
         let string = weekDay1 + ", " + monthName + " " + String(month)
        
        
        return string
    }
    

    func calculateTime(dateString: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let apidate = dateFormatter.date(from: dateString)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        let dateString1 = formatter.string(from: apidate!)
        print(dateString1)
        
        // "4:44 PM on June 23, 2016\n"
        return dateString1
    }
    
    
    func getWeekDay(value: Int) -> String{
        var weekDay: String = BRDRawStaticStrings.KEmptyString
        switch value {
        case 0:
            weekDay = "Sunday"
            break
        case 1:
            weekDay = "Monday"
            break
        case 2:
            weekDay = "Tuesday"
            break
        case 3:
            weekDay = "Wednesday"
            break
        case 4:
            weekDay = "Thrusday"
            break
        case 5:
            weekDay = "Friday"
            break
        case 6:
            weekDay = "Saturday"
            break
        default:
            weekDay = "Sunday"
            break
        }
        
        return weekDay
    }
    
    func getMonth(value: Int) -> String{
        var monthName: String = BRDRawStaticStrings.KEmptyString
        switch value {
        case 1:
            monthName = "January"
            break
        case 2:
            monthName = "February"
            break
        case 3:
            monthName = "March"
            break
        case 4:
            monthName = "April"
            break
        case 5:
            monthName = "May"
            break
        case 6:
            monthName = "June"
            break
        case 7:
            monthName = "July"
            break
        case 8:
            monthName = "August"
            break
        case 9:
            monthName = "September"
            break
        case 10:
            monthName = "October"
            break
        case 11:
            monthName = "November"
            break
        case 12:
            monthName = "December"
            break
        default:
            monthName = "January"
            break
        }
        
        return monthName
    }

    
}
