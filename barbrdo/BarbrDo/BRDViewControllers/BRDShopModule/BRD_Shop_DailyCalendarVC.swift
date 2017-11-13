//
//  BRD_Shop_DailyCalendarVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/31/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader
import SwiftyStarRatingView
import EventKit
import EventKitUI

let KBRD_Shop_DailyCalendarVC_StoryboardID = "BRD_Shop_DailyCalendarVCStoryboardID"

class ChairTableViewCell: UITableViewCell{
    
    @IBOutlet weak var lblChair: UILabel!
    
    override func awakeFromNib() {
        
    }
}



class BRD_Shop_DailyCalendarVC: BRD_BaseViewController ,UITableViewDataSource,UITableViewDelegate,  DDCalendarViewDelegate, DDCalendarViewDataSource, EKEventViewDelegate {
    
    
    @IBOutlet weak var btnChair: UIButton!
    @IBOutlet weak var tableViewChair: UITableView!
    
    @IBOutlet weak var viewChairConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewChairDetail: UIView!
    
    @IBOutlet weak var lblBarberName: UILabel!
    @IBOutlet weak var imageViewBarber: UIImageView!
    @IBOutlet weak var lblMemberSince: UILabel!
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var dateCounter = 0
    @IBOutlet weak var currentDate: UILabel!
    
    
    @IBOutlet var calendarView: DDCalendarView!;
    var arrayTable: [DDCalendarEvent] = [DDCalendarEvent]()
    @IBOutlet var dayLabel: UILabel!;
    
    var dict = Dictionary<Int, [DDCalendarEvent]>()
    var mgr = EventManager()
    
    var arrayEvents = [EventsBO]()
    
    var arrayTableViewChair = [BRD_ChairInfo]()
    var timeDisplayArray = ["8 AM","9 AM","10 AM","11 AM","12 PM","1 PM","2 PM","3 PM","4 PM","5 PM","6 PM","7 PM","8 PM"]
    
    
    var objUserProfile : BRD_UserProfileBO = BRD_UserProfileBO.init()
    var strCurrentDate: String? = nil
    
    var objBarberInfo : BRD_BarberInfoBO? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageViewBarber?.layer.borderWidth = 1
        self.imageViewBarber?.layer.masksToBounds = false
        self.imageViewBarber?.layer.cornerRadius = (self.imageViewBarber?.frame.height)!/2
        self.imageViewBarber?.clipsToBounds = true
        self.imageViewBarber?.layer.borderColor = UIColor.white.cgColor
        
        
        self.addTopNavigationBar(title: "")
        let value =   (Calendar.current as NSCalendar).date(byAdding: .day, value: dateCounter, to: Date(), options: [])!
        
        let dateString = Date.stringFromDate(value, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        currentDate.text =  Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.EEEE_dd_MMMM)
        self.strCurrentDate = Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.yyyy_MM_dd)
        
        //        let actualDate = Date.dateFromString("2017-07-20", Date.DateFormat.yyyy_MM_dd)
        //        self.calendarView.scrollDateToVisible(actualDate!, animated: false)
        //        self.calendarView.reloadData()
        
        calendarView.showsTomorrow = false
        self.getAllChairs()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        NSIndexPath * indexPath = IndexPath(row: ROW_YOU_WANT_TO_SELECT, section: SECTION_YOU_WANT_TO_SELECT)
//        tableView(playListTbl, didSelectRowAt: indexPath)
        
        if BRDSingleton.sharedInstane.indexPathForEvent != nil{
            
            if self.arrayTableViewChair.count > (BRDSingleton.sharedInstane.indexPathForEvent?.row)!{
            
                tableView(self.tableViewChair, didSelectRowAt: BRDSingleton.sharedInstane.indexPathForEvent!)
            }
            
        }
        
        
    }
    
    
    @IBAction func btnChairAction(sender: UIButton){
        
        if self.arrayTableViewChair.count > 0 {
            self.tableViewChair.isHidden = false
            self.tableViewChair.reloadData()
        }else{
            self.tableViewChair.isHidden = true
        }
        
        
    }
    
    
    func getAllChairs(){
        
        /*
         let userID = BRDSingleton.sharedInstane.objBRD_UserInfoBO?._id
         if userID == nil{return}
         let urlString = KBaseURLString + KUserProfile + userID!
         
         SwiftLoader.show(KLoading, animated: true)
         
         BRDAPI.getUserProfile("GET", inputParameter: nil, header: nil, urlString: urlString) { (response, userInfo, status, error) in
         
         print(userInfo)
         SwiftLoader.hide()
         if userInfo != nil{
         self.objUserProfile = userInfo!
         
         print(self.objUserProfile.shops)
         var arrayCollection = [BRD_ChairInfo]()
         if let chairsArray = self.objUserProfile.shops?[0].chairs{
         
         for obj in chairsArray{
         if obj.isActive == true{
         arrayCollection.append(obj)
         }
         }
         }
         self.arrayTableViewChair = arrayCollection
         print(arrayCollection.count)
         self.tableViewChair.reloadData()
         }else{
         _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: error.debugDescription, onViewController: self, returnBlock: { (clickedIN) in
         })
         }
         }*/
        
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{return}
        
        SwiftLoader.show(KLoading, animated: true)
        
        
        let user_id =   BRDSingleton.sharedInstane.objBRD_UserInfoBO?._id
        
        let urlString = KBaseURLString + KShopsList + "/" + user_id!
        
        BRDAPI.getShopsListing("GET", inputParameters: nil, header: header!, urlString: urlString) { (response, arrayServices, status, error) in
            
            SwiftLoader.hide()
            self.arrayTableViewChair.removeAll()
            if(arrayServices != nil){
                if  (arrayServices?.count)! > 0{
                    BRDSingleton.removeEmptyMessage(self.view)
                    
                    for obj in arrayServices!{
                        if(obj.isActive == true)
                        {
                            self.arrayTableViewChair.append(obj)
                        }
                    }
                    self.tableViewChair.reloadData()
                }
            }
            else{
                self.arrayTableViewChair.removeAll()
            }
            
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                    
                })
                return
            }
        }
        
    }
    
    
    
    
    
    //Mark -
    
    @IBAction func acnNextDate(_ sender: Any) {
        
        
        self.viewChairConstraint.constant = 0
        self.btnChair.titleLabel?.text = "Select Chair"
        
        
        
        let strCurrentDate = Date.convert(self.strCurrentDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        let currentDate = Date.dateFromString(strCurrentDate, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        
        
        //Mark
        let value = (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: currentDate!, options: [])!
        
        //Mark
        
        let dateString = Date.stringFromDate(value, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        self.strCurrentDate = Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.yyyy_MM_dd)
        //self.dayLabel.text =  Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.EEEE_dd_MMMM)
        
        
        self.currentDate.text =  Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.EEEE_dd_MMMM)
        //self.getAllEvents()
    }
    
    
    @IBAction func acnPreviousDate(_ sender: Any) {

        self.viewChairConstraint.constant = 0
        self.btnChair.titleLabel?.text = "Select Chair"
        
        dateCounter = dateCounter - 1
        
        let strCurrentDate = Date.convert(self.strCurrentDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        let currentDate = Date.dateFromString(strCurrentDate, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        
        let value =   (Calendar.current as NSCalendar).date(byAdding: .day, value: -1, to: currentDate!, options: [])!
        
        //Mark
        let dateString = Date.stringFromDate(value, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        self.strCurrentDate = Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.yyyy_MM_dd)
        self.currentDate.text =  Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.EEEE_dd_MMMM)
    }
    
    
    
    //MARK : TableViewDelegate/DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTableViewChair.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChairTableViewCell", for: indexPath) as? ChairTableViewCell
        let obj = self.arrayTableViewChair[indexPath.row]
        if obj.name != nil{
            cell?.lblChair.text = obj.name
        }
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        BRDSingleton.sharedInstane.indexPathForEvent = indexPath
        
        self.btnChair.titleLabel?.text = self.arrayTableViewChair[indexPath.row].name
        self.tableViewChair.isHidden = true
        
        if let barberArray = self.arrayTableViewChair[indexPath.row].barberArray{
            
            if barberArray.count > 0 {
                
                let obj = self.arrayTableViewChair[indexPath.row]
                
                if !(obj.booking_start?.isEmpty)! && !(obj.booking_end?.isEmpty)!{
                    
                    let startDate = Date.dateFromString(obj.booking_start!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                    let endDate = Date.dateFromString(obj.booking_end!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                    let strBooking = Date.convert(self.strCurrentDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                    let bookingDate = Date.dateFromString(strBooking, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                    
                    let isDateExist = (startDate?.compare(bookingDate!).rawValue)! * (bookingDate?.compare(endDate!).rawValue)! >= 0
                    
                    
                    if isDateExist == true{
                        // Selected Date comes under the booking of the barber
                        
                        if barberArray.count > 0 {
                            if let objBarber = barberArray[0] as? BRD_BarberInfoBO{
                                
                                self.lblBarberName.text = objBarber.first_name! + " " + objBarber.last_name!
                                
                                self.lblMemberSince.text = Date.convert(objBarber.created_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMMM_YYYY)
                                
                                
                                if objBarber.picture != nil && objBarber.picture != ""{
                                    let imagePath = KImagePathForServer +  objBarber.picture!
                                    self.imageViewBarber.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                                        
                                        DispatchQueue.main.async(execute: {
                                            if image != nil{
                                                self.imageViewBarber.image = image
                                            }else{
                                                self.imageViewBarber.image = UIImage(named: "ICON_PROFILEIMAGE.PNG")
                                            }
                                        })
                                    })
                                }else{
                                    self.imageViewBarber.image = UIImage(named: "ICON_PROFILEIMAGE.PNG")
                                }
                                
                                if let arrayRating = objBarber.ratings{
                                    
                                    var avgRate: Float = 0.0
                                    for objRate in arrayRating{
                                        if objRate.score != nil{
                                            avgRate = avgRate + objRate.score!
                                        }
                                    }
                                    let totalRating: Float = Float(arrayRating.count)
                                    avgRate = avgRate/totalRating
                                    
                                    self.starRatingView.value = CGFloat(avgRate)
                                }
                                
                                self.viewChairConstraint.constant = 97.0
                                self.getAllEvents(objBarber: objBarber)
                            }
                        }else{
                            
                            self.reloadCalendarWithZeroRecords()
                        }
                    }
                    else{
                        self.reloadCalendarWithZeroRecords()
                    }
                    
                }else{
                    self.reloadCalendarWithZeroRecords()
                }
                
            }else{
                
                print("is comign here")
                self.reloadCalendarWithZeroRecords()
            }
        }else{
            
            self.reloadCalendarWithZeroRecords()
        }
        
    }
    
    
    func reloadCalendarWithZeroRecords(){
        
        self.viewChairConstraint.constant = 0
        
        self.arrayTable.removeAll()
        let tempDate = Date.dateFromString(self.strCurrentDate!, Date.DateFormat.yyyy_MM_dd)
        self .loadCachedEvents(0, handler: { (array) in
            self.calendarView.reloadData()
        })
        self.calendarView.scrollDateToVisible(tempDate!, animated: false)
        self.calendarView.reloadData()
        
    }
    
    
    func fetchCalendarRecords(){
        if self.objBarberInfo != nil{
            self.tableViewTopConstraint.constant = 0
            //self.getAllEvents(objBarber: self.objBarberInfo!)
            self.arrayTable.removeAll()
            let tempDate = Date.dateFromString(self.strCurrentDate!, Date.DateFormat.yyyy_MM_dd)
            self .loadCachedEvents(0, handler: { (array) in
                self.calendarView.reloadData()
            })
            self.calendarView.scrollDateToVisible(tempDate!, animated: false)
            self.calendarView.reloadData()
        }else{
            if self.arrayTableViewChair.count > 0{
                if let barberArray = self.arrayTableViewChair[0].barberArray{
                    if barberArray.count > 0 {
                        if let objBarber = barberArray[0] as? BRD_BarberInfoBO{
                            self.objBarberInfo = objBarber
                            self.getAllEvents(objBarber: self.objBarberInfo!)
                        }
                    }
                }
            }
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getAllEvents(objBarber: BRD_BarberInfoBO){
        
        
        let barberID = objBarber._id
        let dateString = "&date=" + self.strCurrentDate!
        
        let urlString =  KBaseURLString + "shops/event?barber_id=" + barberID! + dateString
        print(urlString)
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{return}
        
        SwiftLoader.show(KLoading, animated: true)
        
        BRDAPI.getAllShopsEvent("GET", inputParameter: nil, header: header!, urlString: urlString) { (response, arrayAppointments, arratEvents, status, error) in
            print(response)
            
            self.arrayEvents.removeAll()
            self.arrayTable.removeAll()
            SwiftLoader.hide()
            if(arrayAppointments != nil){
                
                for obj in arrayAppointments!{
                    
                    let objEvent: EventsBO = EventsBO.init()
                    objEvent.title = obj.customer_name
                    objEvent.startsAt = obj.appointment_date
                    objEvent.endsAt = obj.appointment_date
                    
                    objEvent.objShopEvents = obj
                    self.arrayEvents.append(objEvent)
                }
            }
            if(arratEvents != nil){
                
                for obj in arratEvents!{
                    
                    let objEvent: EventsBO = EventsBO.init()
                    objEvent.title = obj.title
                    objEvent.startsAt = obj.startsAt
                    objEvent.endsAt = obj.endsAt
                    
                    objEvent.objShopEvents = nil
                    self.arrayEvents.append(objEvent)
                }
            }
                
            
            
            
            var ddEvents = [DDCalendarEvent]()
            
            for ekEvent in self.arrayEvents {
                let ddEvent = DDCalendarEvent()
                ddEvent.title = ekEvent.title
                
                //                let startDate = Date.dateFromString(ekEvent.startsAt!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                //                let endDate = Date.dateFromString(ekEvent.endsAt!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                
                //let startDate = Date.dateFromString("2017-07-09T11:30:00.000Z", Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                // let endDate = Date.dateFromString("2017-07-09T12:30:00.000Z", Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                
                
                let startDate = Date.dateFromString(ekEvent.startsAt!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                let calendar = Calendar.current
                let endDate = calendar.date(byAdding: .minute, value: 30, to: startDate!)
                /*
                 // Above timezone was in UTC
                 ddEvent.dateBegin = startDate!
                 ddEvent.dateEnd = endDate!
                 */
                
                // This timezone is in local
                
                let startDateString = Date.stringFromDate(startDate!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                let endDateString = Date.stringFromDate(endDate!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                
                let newStartDateString = Date.convertWithSystemTimeZone(startDateString, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                
                let newEndDateString = Date.convertWithSystemTimeZone(endDateString, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                
                let newStartDate = Date.dateFromString(newStartDateString, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                let newEndDate =  Date.dateFromString(newEndDateString, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                ddEvent.dateBegin = newStartDate!
                ddEvent.dateEnd = newEndDate!
                
                ddEvent.userInfo = ["event":ekEvent]
                
                ddEvents.append(ddEvent)
            }
            print(ddEvents)
            self.arrayTable.removeAll()
            self.arrayTable = ddEvents
            let tempDate = Date.dateFromString(self.strCurrentDate!, Date.DateFormat.yyyy_MM_dd)
            self.calendarView.scrollDateToVisible(tempDate!, animated: false)
            self.calendarView.reloadData()
        }
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
        let daysModifier = (date as NSDate).days(from: Date())
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
