//
//  CreateEventVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 28/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader
class CreateEventTableViewCell: UITableViewCell{
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnPreviousDate: UIButton!
    @IBOutlet weak var btnNextDate: UIButton!
    @IBOutlet weak var btnMarkDayAsOff: UIButton!
    @IBOutlet weak var endTimeTF: BRD_UIButton!
    @IBOutlet weak var startTimeTF: BRD_UIButton!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var bottomSpaceToView: NSLayoutConstraint!
    @IBOutlet weak var btnStartTimeofEvent: BRD_UIButton!
    @IBOutlet weak var btnEndTimeofEvent: BRD_UIButton!
    @IBOutlet weak var btnRepeat: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnMonday: UIButton!
    @IBOutlet weak var btnTuesday: UIButton!
    @IBOutlet weak var btnWednesday: UIButton!
    @IBOutlet weak var btnThrusday: UIButton!
    @IBOutlet weak var btnFriday: UIButton!
    @IBOutlet weak var btnSaturday: UIButton!
    @IBOutlet weak var btnSunday: UIButton!
    
    @IBOutlet weak var weekSchedule: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "CreateEventTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        let value =   (Calendar.current as NSCalendar).date(byAdding: .day, value: 0, to: Date(), options: [])!
//        self.lblDate.text = self.convertDateToString(date: value as NSDate)
        
        let dateFormatter = DateFormatter()
        //if some one want 12AM,5PM then use "hh mm a"
        //if some one want 00AM,17PM then use "HH mm a"
        dateFormatter.dateFormat = "hh mm a"
        let stringDate = dateFormatter.string(from: Date())
       
        
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .minute, value: 15, to: Date())

        
        let stringEnd = dateFormatter.string(from: endDate!)

        self.btnStartTimeofEvent .setTitle(stringDate, for: .normal)
        self.btnEndTimeofEvent .setTitle(stringEnd, for: .normal)
    
    }
    func convertDateToString(date: NSDate)->String{
        //Mark
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM"
        let str = formatter.string(from: date as Date)
        return str
    }

}

class CreateEventVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var dayoffFlag : Bool = false
    var repeatFlag : Bool = false
    var dateConstant : String? = ""

    var arrayCollectionView = [" Monday" , " Tuesday" , " Wednesday" , " Thursday" , " Friday" , " Saturday" , " Sunday"]
    var daysNumber = ["1" , "2" ,"3" , "4", "5" , "6" , "7"]
    var repeatArray = NSMutableArray()
    @IBOutlet weak var toolBar: UIToolbar!
    var startAt : String? = ""
    var endAt : String? = ""
    var btnTimeEvent: Int = 0
    var dateCounter: Int = 0

    var strSelectedDate: String? = nil
    
    
    var objCalendar : DDCalendarEvent?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
                    // Do any additional setup after loading the view.
        
        //let dateString = Date.dateFromString(strSelectedDate!, Date.DateFormat.yyyy_MM_dd)
        
        //self.lblDate.text =  Date.convert(strSelectedDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.EEEE_dd_MMMM)
        
        //let value =   (Calendar.current as NSCalendar).date(byAdding: .day, value: 0, to: Date(), options: [])!

        //let dateString = Date.stringFromDate(value, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        
        self.dateConstant = Date.convert(strSelectedDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.YYYY_MM_DD)
        
        


        let navigationView = (Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitle.self), owner: self, options: nil)![0] as? NavigationBarWithTitle)!
        navigationView.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        navigationView.lblScreenTitle.text = "Create Event"
        navigationView.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(navigationView)
        
        self.datePicker.addTarget(self, action: #selector(dateChangeAction(sender:)), for: .valueChanged)
        
        let datedemo = Date.stringFromDate(Date(), Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
        
        
        self.startAt = Date.convert(datedemo, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
        
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .minute, value: 15, to: Date())
        let endDateStr = Date.stringFromDate(endDate!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
        self.endAt = Date.convert(endDateStr, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
        
        SwiftLoader.show(KLoading, animated: true)
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            
            if self.objCalendar != nil{
                
                print("This is an edit")
                
                
                let indexPath = IndexPath.init(row: 0, section: 0)
                
                let cell : CreateEventTableViewCell = self.tableView.cellForRow(at: indexPath) as! CreateEventTableViewCell
                
                cell.titleTF.text = self.objCalendar?.title
                
                self.startAt = Date.stringFromDate((self.objCalendar?.dateBegin)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                self.endAt = Date.stringFromDate((self.objCalendar?.dateEnd)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                
                if let checkObj = self.objCalendar?.userInfo{
                    
                    if let objTemp = checkObj["event"] as? EventsBO{
                        
                        if objTemp.dayoff == true{
                            cell.btnMarkDayAsOff.isSelected = true
                        }
                        
                        if (objTemp.repeatEvent?.count)! > 0{
                            cell.btnRepeat.isSelected = true
                        }
                        
                    }
                }
                
                print((self.objCalendar?.dateBegin)!)
                
                let sDate = Date.stringFromDate((self.objCalendar?.dateBegin)!, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
                let eDate = Date.stringFromDate((self.objCalendar?.dateEnd)!, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)

                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = Date.TimeFormat.hh_mm_a
                cell.btnStartTimeofEvent.setTitle(Date.convert(sDate, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.TimeFormat.hh_mm_a), for: .normal)
                cell.btnEndTimeofEvent.setTitle(Date.convert(eDate, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.TimeFormat.hh_mm_a), for: .normal)
                
                SwiftLoader.hide()
                
            }else{
                SwiftLoader.hide()
            }
        }        
    }
    
    
    
    func convertDateToYYYYMM(date: NSDate)->String{
        //Mark
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'"
        let str = formatter.string(from: date as Date)
        return str
    }

    @objc private func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveEvent()
    {
        let indexPath = IndexPath.init(row: 0, section: 0)
        
        let cell : CreateEventTableViewCell = self.tableView.cellForRow(at: indexPath) as! CreateEventTableViewCell
        let strStartTime = Date.convert((cell.btnStartTimeofEvent.titleLabel?.text!)!, Date.TimeFormat.hh_mm_a, Date.TimeFormat.HH_mm_ss_SSSZ)
        let strEndTime = Date.convert((cell.btnEndTimeofEvent.titleLabel?.text!)!, Date.TimeFormat.hh_mm_a, Date.TimeFormat.HH_mm_ss_SSSZ)
        
         let strCurrentDate = Date.convert(strSelectedDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.YYYY_MM_DD)
        
        var strFinalStartDate: String = ""
        var strFinalEndDate :String = ""
        if dayoffFlag == true{
            
            strFinalStartDate = strCurrentDate + "00:00:00.000+0000"
            strFinalEndDate = strCurrentDate + "23:59:59.000+0000"
        }else{
            strFinalStartDate = strCurrentDate + strStartTime
            strFinalEndDate = strCurrentDate + strEndTime
        }
        
        SwiftLoader.show("Sending", animated: true)
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()!
        if header ==  nil{return}
        
        let shopInfoObj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        
        if let shopInfo = shopInfoObj
        {
           
            let inputParameters : [String: Any] = ["title": cell.titleTF.text!,
                                   "startsAt" : strFinalStartDate,
                                   "endsAt" : strFinalEndDate,
                                   "dayoff" : dayoffFlag ,
                                   "repeat" : self.repeatArray ]
            print(inputParameters)
            let urlString = KBaseURLString + KAddBarberEvent
            
            
            if self.objCalendar != nil{
                
                // Call update
                
                var theURL: String?
                if let checkObj = self.objCalendar?.userInfo{
                    
                    if let objTemp = checkObj["event"] as? EventsBO{
                        theURL = urlString + "/" + objTemp._id!
                    }
                }

                
                BRDAPI.updateService("PUT", inputParameters: inputParameters, header: header!, urlString: theURL!, completionHandler: { (response, responseString, status, error) in
                    
                    SwiftLoader.hide()
                    self.navigationController?.popViewController(animated: true)
                    
                })
            }else{
                
                BRDAPI.addService("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                    SwiftLoader.hide()
                    
                    if responseMessage == "Successfully updated fields" {
                        
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                    }
                    
                    
                    if error != nil{
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                            
                        })
                        return
                    }
                }
            }
        }
    }
    
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
        var message : String? = ""
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        
        let cell : CreateEventTableViewCell = self.tableView.cellForRow(at: indexPath) as! CreateEventTableViewCell
        print  ("event -- \(self.repeatArray)")
        
        if (startAt?.isEmpty)!

        {
            message = "Please enter the Start Date."
            _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: message, onViewController: self, returnBlock: { (clickedIN) in
                
            })
        }
            
        else if (endAt?.isEmpty)!
        {
            message = "Please enter the End Date."
            _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: message, onViewController: self, returnBlock: { (clickedIN) in
                
            })
        }
      
        else
        {
            self.saveEvent()
        }
    }
    @IBAction func dayOffAction(_ sender: UIButton) {
        
      if  sender.isSelected == true{
        dayoffFlag = false
        }else{
        dayoffFlag = true
        }
    }
    @IBAction func repeatAction(_ sender: UIButton) {
       
        let indexPath = IndexPath.init(row: 0, section: 0)

        let cell : CreateEventTableViewCell = self.tableView.cellForRow(at: indexPath) as! CreateEventTableViewCell
        if  sender.isSelected == true
        {
            repeatFlag = true
            cell.weekSchedule.isHidden = true
            cell.bottomSpaceToView.constant = 180
        }
        else
        {
            repeatFlag = false
            cell.weekSchedule.isHidden = false
            cell.bottomSpaceToView.constant = 40
        }

    }
    
    func convertDateString(obj: String) -> String?{
        let myDate = obj //obj.appointment_date // "2016-06-20T13:01:46.457+02:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from:myDate)!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'"
        let dateString = dateFormatter.string(from:date)
        
        print(dateString)
        
        return dateString
    }

//    2017-07-28T19:47:00.000Z
     func dateChangeAction(sender: UIDatePicker){
        
        print(sender.date)
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.TimeFormat.HH_mm_ss_SSSZ
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = Date.TimeFormat.hh_mm_a
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell : CreateEventTableViewCell = self.tableView.cellForRow(at: indexPath) as! CreateEventTableViewCell
        
        
        if self.btnTimeEvent == 103
        {
           cell.btnStartTimeofEvent.setTitle(dateFormatter1.string(from: sender.date), for: .normal)
           
            if let currentDate1 = self.dateConstant
            {
                startAt = currentDate1 + dateFormatter.string(from: sender.date)
            }
        }
        else if self.btnTimeEvent == 104
        {
            cell.btnEndTimeofEvent.setTitle(dateFormatter1.string(from: sender.date), for: .normal)
     
            if let currentDate1 = self.dateConstant
            {
                endAt = currentDate1 + dateFormatter.string(from: sender.date)
            }
        }
        
        print(endAt ?? "test")

    }
    


}

extension CreateEventVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: CreateEventTableViewCell.identifier()) as? CreateEventTableViewCell
        if cell == nil {
            cell = CreateEventTableViewCell(style: .value1, reuseIdentifier: CreateEventTableViewCell.identifier())
        }
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        layout.itemSize = CGSize(width: 100, height: 40)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        cell?.collectionView.collectionViewLayout = layout
        
        
       // let tempDate = Date.dateFromString(strSelectedDate!, Date.DateFormat.yyyy_MM_dd)
        
        cell?.lblDate.text = Date.convert(strSelectedDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.EEEE_dd_MMMM)
//        cell?.lblDate.text =  Date.convert(strSelectedDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.EEEE_dd_MMMM)

        cell?.btnStartTimeofEvent.addTarget(self, action: #selector(showTimePicker(sender:)), for: .touchUpInside)
        cell?.btnEndTimeofEvent.addTarget(self, action: #selector(showTimePicker), for: .touchUpInside)
        cell?.btnMarkDayAsOff.addTarget(self, action: #selector(changeButtonMode(sender:)), for: .touchUpInside)
        cell?.btnRepeat.addTarget(self, action: #selector(changeButtonMode(sender:)), for: .touchUpInside)
        
        
        cell?.btnStartTimeofEvent.addImage(name: "ARROW_DOWN")
        cell?.btnStartTimeofEvent.addLabel()
        
        cell?.btnEndTimeofEvent.addImage(name: "ARROW_DOWN")
        cell?.btnEndTimeofEvent.addLabel()
        
        cell?.btnPreviousDate.addTarget(self, action: #selector(btnPreviousDateAction(sender:)), for: .touchUpInside)
        cell?.btnNextDate.addTarget(self, action: #selector(btnNextDateAction(sender:)), for: .touchUpInside)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 503.0
    }
    
    func changeButtonMode(sender: UIButton){
        if sender.tag == 105{
            sender.isSelected = !sender.isSelected
        }else if sender.tag == 106{
            sender.isSelected = !sender.isSelected
        }
    }
    
    func showTimePicker(sender: UIButton){
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell : CreateEventTableViewCell = self.tableView.cellForRow(at: indexPath) as! CreateEventTableViewCell
        cell.titleTF?.resignFirstResponder()
        self.btnTimeEvent = sender.tag
        
        self.viewPicker.isHidden = false
        self.viewPicker.bringSubview(toFront: self.tableView)
    }
    
    @IBAction func toolBarButtonAction(sender: UIBarButtonItem){
        
        if sender.tag == 101{
            
            
        }else if sender.tag == 102{
            
        }else{
            
        }
        self.viewPicker.isHidden = true
        
    }
    
    func btnNextDateAction(sender: Any) {
        
        //Mark
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell : CreateEventTableViewCell = self.tableView.cellForRow(at: indexPath) as! CreateEventTableViewCell
        
        dateCounter = dateCounter + 1
        
        print(strSelectedDate ?? "No Date")
        let strCurrentDate = Date.convert(strSelectedDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        print(strCurrentDate)
        let currentDate = Date.dateFromString(strCurrentDate, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        //Mark
        let value =   (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: currentDate!, options: [])!
        
        print(value)
        let dateString = Date.stringFromDate(value, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        
        print(dateString)
        
        strSelectedDate = Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.yyyy_MM_dd)
        print(strSelectedDate)
        cell.lblDate.text =  Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.EEEE_dd_MMMM)
       // currentDate = self.convertDateToYYYYMM(date: value as NSDate)

        self.dateConstant = Date.convert(strSelectedDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.YYYY_MM_DD)
    }
    
    
     func btnPreviousDateAction(sender: Any) {
        //Mark
//        dateCounter = dateCounter - 1
//        let value =   (Calendar.current as NSCalendar).date(byAdding: .day, value: dateCounter, to: Date(), options: [])!
        
        //Mark
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell : CreateEventTableViewCell = self.tableView.cellForRow(at: indexPath) as! CreateEventTableViewCell
         dateCounter = dateCounter - 1
        
        let strCurrentDate = Date.convert(strSelectedDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        let currentDate = Date.dateFromString(strCurrentDate, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
//        //Mark
        let value =   (Calendar.current as NSCalendar).date(byAdding: .day, value: -1, to: currentDate!, options: [])!

        
        let dateString = Date.stringFromDate(value, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        strSelectedDate = Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.yyyy_MM_dd)
        cell.lblDate.text =  Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.EEEE_dd_MMMM)
        
        self.dateConstant = Date.convert(strSelectedDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.YYYY_MM_DD)
    }

    


    func selectBtnTapped ( _ sender : UIButton)
    {
        sender.isSelected = !sender.isSelected
        if (sender.isSelected == true)
        {
            
           self.repeatArray.add(daysNumber[sender.tag])
        }
        else
        {
            self.repeatArray.remove(daysNumber[sender.tag])

        }
    }
    
    
}
extension CreateEventVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayCollectionView.count
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:EventCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EventCollectionCell
        cell.daysBtn.setTitle(self.arrayCollectionView[indexPath.row], for: .normal)

        cell.daysBtn.tag = indexPath.row
        cell.daysBtn.addTarget(self, action: #selector(CreateEventVC.selectBtnTapped(_:)) , for: .touchUpInside)
        
        //        cell.initWithData(obj: self.arrayCollectionView[indexPath.row])
        //cell.activityIndicator.startAnimating()
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // your code here
        // let height = width * 1.5 //ratio
        return CGSize(width: CGFloat((collectionView.frame.size.width / 3) ), height: CGFloat(40))
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
         }
    
        // handle tap events
//        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_GalleryViewVC_StoryboardID) as! BRD_Customer_GalleryViewVC
//        let obj = self.arrayCollectionView[indexPath.row]
//        vc.strImagePath = obj.name
//        vc.imageID = obj._id
//        self.navigationController?.pushViewController(vc, animated: false)
        

}
