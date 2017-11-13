//
//  BRD_Barber_SearchChairVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/18/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import CVCalendar

let KBRD_Barber_SearchChairVC_StoryboardID = "BRD_Barber_SearchChairVC_StoryboardID"
class BRD_Barber_SearchChairVC: BRD_BaseViewController  {
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calanderView: CVCalendarView!
    @IBOutlet weak var selectedDateLbl: UILabel!
    var currentMonths : Int = 0
    var currentYear : Int = 0
    var selectedDateStatus : Bool = false
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTopNavigationBar(title: KSearchForChair)
        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        let dateString = Date.stringFromDate(Date(), Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        selectedDateLbl.text = Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.MMMM_YYYY)
        self.disablePreviousDays()
        
        //Mark
        let dateStr = Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.MM_YYYY)
        let strArray = dateStr.components(separatedBy: " ")
        if(strArray.count>1){
            currentMonths = Int(strArray[0])!
            currentYear = Int(strArray[1])!
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        selectedDateStatus = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calanderView.commitCalendarViewUpdate()
        
    }

    //MARK: -getMonthNameByMonthNumber
    fileprivate func getMonthName(month: Int)->String{
        switch month {
        case 1:
            return monthsName.Jan.rawValue
        case 2:
            return monthsName.Feb.rawValue
        case 3:
            return monthsName.Mar.rawValue
        case 4:
            return monthsName.Apr.rawValue
        case 5:
            return monthsName.May.rawValue
        case 6:
            return monthsName.Jun.rawValue
        case 7:
            return monthsName.Jul.rawValue
        case 8:
            return monthsName.Aug.rawValue
        case 9:
            return monthsName.Sep.rawValue
        case 10:
            return monthsName.Oct.rawValue
        case 11:
            return monthsName.Nov.rawValue
        case 12:
            return monthsName.Dec.rawValue
        default:
            return ""
        }
        
        
    }
    
    //Mark
    @IBAction func acnPreviousMonth(_ sender: Any) {
        self.disablePreviousDays()
        //Mark - previous
        //Mark check for current months and year
        calanderView.loadPreviousView()
        // calanderView.appearance)
        
    }
    
    
    @IBAction func acnNextMonth(_ sender: Any) {
        self.disablePreviousDays()
        //Mark
        calanderView.loadNextView()
        
    }
    
}

extension BRD_Barber_SearchChairVC: CVCalendarViewDelegate, CVCalendarMenuViewDelegate  {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .short
    }
    
    func dayOfWeekTextColor() -> UIColor {
        return UIColor.white
    }
    
    func dayOfWeekBackGroundColor() -> UIColor {
        return UIColor.lightGray
    }
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        selectedDateStatus = false
        return true
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        self.disablePreviousDays()
        // yyyy-MM-dd
        let year = String(describing: calanderView.presentedDate.year)
        var month = String(describing: calanderView.presentedDate.month)
        let day = String(describing: calanderView.presentedDate.day)
        
        if month.characters.count == 1{
            month = "0" + month
        }
        
        let combineDate = year + "-" + month + "-" + day
        print(combineDate)
        //Mark - Navigate to other screen
        
        if(selectedDateStatus == true){
            if(dayView.isCurrentDay){
                selectedDateStatus = true
            }
        }
        
        //Mark -
        selectedDateLbl.text = getMonthName(month: calanderView.presentedDate.month) + " \(calanderView.presentedDate.year)"
        //Mark - Navigate only in case of date greater than current date
        if(calanderView.presentedDate.year>currentYear){
            //mark
            if(selectedDateStatus){
                
                let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_ShopListVC_StoryboardID) as! BRD_Barber_ShopListVC
                vc.calendarSelectedDate = combineDate
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
        else if(calanderView.presentedDate.year == currentYear){
            if(calanderView.presentedDate.month>=currentMonths){
                if(selectedDateStatus){
                    let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_ShopListVC_StoryboardID) as! BRD_Barber_ShopListVC
                    vc.calendarSelectedDate = combineDate
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        }
        
        
        if(selectedDateStatus == false){
            selectedDateStatus = true
        }
        
        //Mark - Navigate to SearchScreen
    }
    
    //Mark - Deselect previous date
    func disablePreviousDays() {
        let calendar = NSCalendar.current
        for weekV in calanderView.contentController.presentedMonthView.weekViews {
            for dayView in weekV.dayViews {
                if calendar.compare(dayView.date.convertedDate(calendar: calendar)!, to: NSDate() as Date, toGranularity: .day) == .orderedAscending
                {
                    dayView.isUserInteractionEnabled = false
                    dayView.dayLabel.textColor = calanderView.appearance.dayLabelWeekdayOutTextColor
                    
                }
            }
        }
    }
    
    
}

//extension BRD_Barber_SearchChairVC: UIScrollViewDelegate {
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        (calanderView.contentController as! MonthContentViewController).scrollViewWillBeginDragging(scrollView)
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        (calanderView.contentController as! MonthContentViewController).scrollViewDidEndDecelerating(scrollView)
//         self.disablePreviousDays()
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        (calanderView.contentController as! MonthContentViewController).scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
//    }
//}

