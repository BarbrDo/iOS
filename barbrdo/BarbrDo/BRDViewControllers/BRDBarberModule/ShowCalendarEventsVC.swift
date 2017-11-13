//
//  ShowCalendarEventsVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 07/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import SwiftLoader

class ShowCalendarEventsVC: BRD_BaseViewController, DDCalendarViewDelegate, DDCalendarViewDataSource, EKEventViewDelegate  {
    @IBOutlet var dayLabel: UILabel!;
    @IBOutlet var calendarView: DDCalendarView!;
    
    @IBOutlet weak var lblDate: UILabel!
    
    var dict = Dictionary<Int, [DDCalendarEvent]>()
    var mgr = EventManager()
    var dateCounter = 0
    var strSelectedDate: String? = nil
    
    var arrayTable: [DDCalendarEvent] = [DDCalendarEvent]()
    
    override func viewDidLoad() {
        
        self.addTopNavigationBar(title: "")
        self.lblDate.text =  Date.convert(strSelectedDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.EEEE_dd_MMMM)
        
        //self.getAllEvents()
        BRDSingleton.sharedInstane.calendarDate = self.strSelectedDate
        self.getDayOfWeek(today: self.strSelectedDate!)
    }
    
    
    
    
    
    func getDayOfWeek(today:String)->Int {
    
        
        let todayDate = Date.dateFromString(today, Date.DateFormat.yyyy_MM_dd)
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate!)
        let weekDay = myComponents.weekday
        return weekDay! - 1
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.arrayTable.removeAll()
        
        DispatchQueue.main.async {
            self.dict[0] = self.arrayTable
            self .loadCachedEvents(0, handler: { (array) in
                self.calendarView.reloadData()
            })
        }
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            if BRDSingleton.sharedInstane.calendarDate != nil{
                self.strSelectedDate = BRDSingleton.sharedInstane.calendarDate
                self.getAllEvents()
            }
        }
    }
    
    func getAllEvents(){
        //2017-07-20
        
        
        let urlString = KBaseURLString + KGetAllEvents + strSelectedDate!
        
        print(urlString)
        
        var userId: String? = nil
        if let barberID = BRDSingleton.sharedInstane.objBRD_UserInfoBO?._id{
            userId = barberID
        }
        
        if userId == nil{
            return
        }
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
            
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        
        print(header!)
        SwiftLoader.show(KLoading, animated: true)
        
        BRDAPI.getAllEventsAndAppointment("GET", inputParameter: nil, header: header!, urlString: urlString) { (response, events, status, errror) in
            
            self.arrayTable.removeAll()
            SwiftLoader.hide()
            print(response ?? "No Response")
            
            if events != nil{
                
                if let appointment = events?.appointments{
                    
                    var arrayAppointment = [DDCalendarEvent]()
                    
                    for ekEvent in appointment {
                        let ddEvent = DDCalendarEvent()
                        
                        ddEvent.title = "Appointment"
                        let startDate = Date.dateFromString(ekEvent.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                        
                        let calendar = Calendar.current
                        let endDate = calendar.date(byAdding: .minute, value: 30, to: startDate!)
                        
                        //let endDate = Date.dateFromString(ekEvent.!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                        ddEvent.dateBegin = startDate!
                        ddEvent.dateEnd = endDate!
                        ddEvent.userInfo = ["event":ekEvent]
                        arrayAppointment.append(ddEvent)
                        self.arrayTable.append(ddEvent)
                    }
                }
                
                if let event = events?.events{
                    print(event)
                    var ddEvents = [DDCalendarEvent]()

                    for ekEvent in event {
                        
                        let currentDay = self.getDayOfWeek(today: self.strSelectedDate!)
                        
                        let ddEvent = DDCalendarEvent()
                        
                        if ekEvent.dayoff == true{
                            ddEvent.title = ekEvent.title
                            let strSDate = self.strSelectedDate! + " " + "00:00:00"
                            let strEDate = self.strSelectedDate! + " " + "23:59:59"
                            let startDate = Date.dateFromString(strSDate, Date.DateFormat.yyyy_MM_dd_HH_mm_ss)
                            let endDate = Date.dateFromString(strEDate, Date.DateFormat.yyyy_MM_dd_HH_mm_ss)
                            ddEvent.dateBegin = startDate!
                            ddEvent.dateEnd = endDate!
                            ddEvent.userInfo = ["event":ekEvent]
                            ddEvents.append(ddEvent)
                            
                            self.arrayTable.append(ddEvent)
                            
                            let tempDate = Date.dateFromString(self.strSelectedDate!, Date.DateFormat.yyyy_MM_dd)
                            
                            self .loadCachedEvents(0, handler: { (array) in
                                self.calendarView.reloadData()
                            })
                            self.calendarView.scrollDateToVisible(tempDate!, animated: false)
                            self.calendarView.reloadData()
                            return
                        }
                        
                        
                        var isCurrentDate :Bool = false
                        let teapdd = Date.convert(ekEvent.startsAt!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.yyyy_MM_dd)
                        let eventDate1 = Date.dateFromString(teapdd, Date.DateFormat.yyyy_MM_dd)
                        
                        let eventDate2 = Date.dateFromString(self.strSelectedDate!, Date.DateFormat.yyyy_MM_dd)
                        
                        if eventDate1 == eventDate2{
                            isCurrentDate = true
                        }
                        
                        if ekEvent.repeatEvent != nil{
                            // Check whether array contains this day or not
                            if ekEvent.repeatEvent!.contains(String(describing: currentDay)) || isCurrentDate == true{
                                
                                let startString = ekEvent.startsAt?.components(separatedBy: "T")[1]
                                let strStartDate = self.strSelectedDate! + "T" + startString!
                                
                                let endString = ekEvent.endsAt?.components(separatedBy: "T")[1]
                                let strEndDate = self.strSelectedDate! + "T" + endString!
                                
                                
                                ddEvent.title = ekEvent.title
                                //                            let startDate = Date.dateFromString(ekEvent.startsAt!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                                //                            let endDate = Date.dateFromString(ekEvent.endsAt!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                                let startDate = Date.dateFromString(strStartDate, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                                let endDate = Date.dateFromString(strEndDate, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                                ddEvent.dateBegin = startDate!
                                ddEvent.dateEnd = endDate!
                                ddEvent.userInfo = ["event":ekEvent]
                                ddEvents.append(ddEvent)
                                
                                self.arrayTable.append(ddEvent)
                            }
                        }
                        
                        
                    }
                    //self.arrayTable = ddEvents
                    let tempDate = Date.dateFromString(self.strSelectedDate!, Date.DateFormat.yyyy_MM_dd)
//                  
                    self .loadCachedEvents(0, handler: { (array) in
                        self.calendarView.reloadData()
                    })
                    self.calendarView.scrollDateToVisible(tempDate!, animated: false)
                    self.calendarView.reloadData()

                }
            }else{
                // Do Nothing
            }
            
        }
    }
    
    
    @IBAction func acnNextDate(_ sender: Any) {
        
        dateCounter = dateCounter + 1
        
        let strCurrentDate = Date.convert(strSelectedDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        let currentDate = Date.dateFromString(strCurrentDate, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        
        
        //Mark
        let value = (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: currentDate!, options: [])!
        
        //Mark
        
        let dateString = Date.stringFromDate(value, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        self.strSelectedDate = Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.yyyy_MM_dd)
        self.lblDate.text =  Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.EEEE_dd_MMMM)
        
        BRDSingleton.sharedInstane.calendarDate = self.strSelectedDate

        self.getAllEvents()
    }
    
    
    @IBAction func acnPreviousDate(_ sender: Any) {
        //Mark
        dateCounter = dateCounter - 1
        
        let strCurrentDate = Date.convert(strSelectedDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        let currentDate = Date.dateFromString(strCurrentDate, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        
        let value =   (Calendar.current as NSCalendar).date(byAdding: .day, value: -1, to: currentDate!, options: [])!
        
        //Mark
        let dateString = Date.stringFromDate(value, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        self.strSelectedDate = Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.yyyy_MM_dd)
        self.lblDate.text =  Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.EEEE_dd_MMMM)
        
         BRDSingleton.sharedInstane.calendarDate = self.strSelectedDate
        self.getAllEvents()
    }
    
    @IBAction func addAnEventAction(){
        
        BRDSingleton.sharedInstane.calendarDate = self.strSelectedDate
        //Mark
        let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateEventVC") as! CreateEventVC
        vc.strSelectedDate = self.strSelectedDate!
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: delegate
    
    
    
    func calendarView(_ view: DDCalendarView, focussedOnDay date: Date) {
        //dayLabel.text = (date as NSDate).stringWithDateOnly()
        
        
        let days = (date as NSDate).days(from: Date())
        /*self.loadCachedEvents(days) { (events) -> Void in
         self.loadCachedEvents(days-1) { (events) -> Void in
         self.loadCachedEvents(days+1) { (events) -> Void in
         self.calendarView.reloadData()
         }
         }
         }*/
        print(days)
        self.loadCachedEvents(days) { (events) -> Void in
            self.calendarView.reloadData()
        }
        
    }
    
    func calendarView(_ view: DDCalendarView, didSelect event: DDCalendarEvent) {
        print(event)
        print(event.title)
        print(event.dateBegin)
        print(event.dateEnd)
        
        
        /*
         let dateStartString = Date.stringFromDate(event.dateBegin, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
         let startTime = Date.convert(dateStartString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.MMM_dd_yyyy_hh_mm)
         
         
         let dateEndString = Date.stringFromDate(event.dateEnd, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
         let EndTime = Date.convert(dateEndString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.MMM_dd_yyyy_hh_mm)
         
         let completeEventInfo = "Start Time: " + startTime + " \n" +
         "End Time: " + EndTime
         
         
         _ = BRDAlertManager.showOKAlert(withTitle: event.title, withMessage: completeEventInfo, onViewController: self, returnBlock: { (clickedIN) in
         })*/
        
        //        let storyboard = UIStoryboard(name: shopStoryboard, bundle: nil)
        //        let controller = storyboard.instantiateViewController(withIdentifier: "EventDescriptionVC")
        //        controller.objDDCalendarEvent = event
        ////        self.present(controller, animated: true, completion: nil)
        //        self.navigationController?.pushViewController(controller, animated: true)
        
        let storyboard = UIStoryboard(name:shopStoryboard, bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "EventDescriptionVC") as! EventDescriptionVC
        vc.objDDCalendarEvent = event
        
        print(event.userInfo)
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    func calendarView(_ view: DDCalendarView, allowEditing event: DDCalendarEvent) -> Bool {
        //NOTE some check could be here, we just say true :D
        let ekEvent = event.userInfo["event"] as! EKEvent
        let ekCal = ekEvent.calendarItemIdentifier
        print(ekCal)
        
        return true
    }
    
    func calendarView(_ view: DDCalendarView, commitEdit event: DDCalendarEvent) {
        //NOTE we dont actually save anything because this demo doesnt wanna mess with your calendar :)
    }
    
    // MARK: dataSource
    
    public func calendarView(_ view: DDCalendarView, eventsForDay date: Date) -> [Any]? {
        
        let dateSTr = Date.convert(self.strSelectedDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        let newDate = Date.dateFromString(dateSTr, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        let daysModifier = (date as NSDate).days(from: newDate)

//        let daysModifier = (date as NSDate).days(from: Date())
        return dict[daysModifier]
    }
    
    public func calendarView(_ view: DDCalendarView, viewFor event: DDCalendarEvent) -> DDCalendarEventView? {
        return EventView(event: event)
    }
    
    // MARK: helper
    
    func loadCachedEvents(_ day:Int, handler:@escaping ([DDCalendarEvent])->Void) {
        //        let events = dict[day]
        //        if(events == nil) {
        //            mgr.getEvents(day, calendars: nil, handler: { (newEvents) -> Void in
        //                //make DDEvents
        //                var ddEvents = [DDCalendarEvent]()
        //                for ekEvent in newEvents {
        //                    if ekEvent.isAllDay == false {
        //                        let ddEvent = DDCalendarEvent()
        //                        ddEvent.title = ekEvent.title
        //                        ddEvent.dateBegin = ekEvent.startDate
        //                        ddEvent.dateEnd = ekEvent.endDate
        //
        //                        print(ekEvent.startDate,ekEvent.endDate)
        //
        //                        ddEvent.userInfo = ["event":ekEvent]
        //                        ddEvents.append(ddEvent)
        //                    }
        //                }
        //                print(ddEvents)
        //                self.dict[day] = ddEvents
        //
        ////                if self.arrayTable.count > 0 {
        ////                    self.dict[day] = self.arrayTable
        ////                }
        //                handler(ddEvents)
        //            })
        //        }
        //        else {
        //            handler(self.arrayTable)
        //        }
        self.dict[day] = self.arrayTable
        handler(self.arrayTable)
    }
    
    // MARK: delegate
    
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        self.dismiss(animated: true, completion: nil)
    }
}
