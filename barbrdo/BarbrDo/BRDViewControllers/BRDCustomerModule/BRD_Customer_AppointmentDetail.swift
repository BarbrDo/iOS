//
//  BRD_Customer_AppointmentDetail.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 08/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
import EventKit

let KBRD_Customer_AppointmentDetail_StoryboardID = "BRD_Customer_AppointmentDetail_StoryboardID"


class AppointmentDetailTableViewCell : UITableViewCell{
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var btnAddToCalender: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "AppointmentDetailTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnAddToCalender.layer.borderColor = KRedColor.cgColor
        self.btnAddToCalender.layer.borderWidth = 2.0
        self.btnAddToCalender.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(obj: BRD_AppointmentsInfoBO){
        
        self.lblDate.text = Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.EEEE_MMMM_dd)
        self.lblTime.text = Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.TimeFormat.hh_mm_a)
    }
    
}

class ShopDetailTableViewCell: UITableViewCell{
    
    @IBOutlet weak var lblBarberAddress: UILabel!
    
    @IBOutlet weak var btnViewOnMap: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "ShopDetailTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnViewOnMap.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        self.btnViewOnMap.layer.borderColor = KRedColor.cgColor
        self.btnViewOnMap.layer.borderWidth = 2.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(obj: BRD_AppointmentsInfoBO){
        
        if let shopDetail = obj.shop_id{
            
            var address = ""
            if let shopName = shopDetail.name{
                address = shopName + "\n"
            }
            
            if let shopDetails = shopDetail.address {
                address = address + shopDetails + ", \n"
            }
            if let city = shopDetail.city {
                address = address + city + ", "
            }
            if let state = shopDetail.state {
                address = address + state
            }
            self.lblBarberAddress.text =  address
        }
    }
}

class AppointmentDetailSummaryTableViewCell: UITableViewCell{
    
    @IBOutlet weak var lblBarberAddress: UILabel!
    
    @IBOutlet weak var btnViewOnMap: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "AppointmentDetailSummaryTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


class AppointmentDetail_BarberServices: UITableViewCell{
    
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblServiceCost: UILabel!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "AppointmentDetail_BarberServices"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(obj: BRD_ServicesBO) {
        let serviceName = obj.name
        self.lblServiceName.text = serviceName?.capitalized
        
        if obj.price != nil{
            if let price = obj.price{
                self.lblServiceCost.text = "$ " + String(price)
            }
        }
    }
}

class AppointmentDetail_TotalPaid: UITableViewCell{
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTotalAmountDue: UILabel!
    @IBOutlet weak var btnPayNow: UIButton!
    
    
    @IBOutlet weak var payNowHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "AppointmentDetail_TotalPaid"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func iniWithData(obj: BRD_AppointmentsInfoBO) {
        
        
        if obj.payment_status?.lowercased() == "confirm" {
            self.lblTotalAmount.text = "Total Paid"
            self.payNowHeightConstraint.constant = 0
        }else{
            self.lblTotalAmount.text = "Total Due"
            self.payNowHeightConstraint.constant = 35

        }
        
        if (obj.services?.count)! > 0{
            var value: Double = 0
            
            for userServices in obj.services!{
                if userServices.price != nil{
                    value = value + userServices.price!
                }
            }
            self.lblTotalAmountDue.text = "$ " + String(format: "%.2f", value)
                
                //String(describing: value)
        }
    }
}

class AppointmentDetail_BarberProfile: UITableViewCell{
    
    @IBOutlet weak var barberImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblBarberName: UILabel!
    @IBOutlet weak var lblLastCut: UILabel!
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    @IBOutlet weak var btnContactBarber: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "AppointmentDetail_BarberProfile"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.barberImageView?.layer.masksToBounds = false
        self.barberImageView?.layer.cornerRadius = (self.barberImageView?.frame.height)!/2
        self.barberImageView?.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func iniWithData(obj: BRD_AppointmentsInfoBO) {
        
        if let barberDetail = obj.barber_id{
            self.lblBarberName.text = barberDetail.first_name! + " " + barberDetail.last_name!
            
            if let rating = barberDetail.ratings{
                var rateValue: Float = 0
                for item in rating{
                    
                    rateValue = rateValue + item.score!
                }
                
                let avg: Float = rateValue + Float(rating.count)
                self.starRatingView.value = CGFloat(avg)
            }else{
                self.starRatingView.value = 0
            }
            
            self.activityIndicator.startAnimating()
            
            if obj.barber_id?.picture != nil || obj.barber_id?.picture == ""{
                let imagePath = KImagePathForServer + (obj.barber_id?.picture)!
                self.barberImageView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                    
                    DispatchQueue.main.async(execute: {
                        if image != nil{
                            self.barberImageView.image = image
                        }else{
                            self.barberImageView.image = UIImage.init(named: "ICON_PROFILEIMAGE")
                        }
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidesWhenStopped = true
                    })
                })
            }else{
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            }
            
            self.lblLastCut.text = Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMMM_YYYY)
        }
    }
}

class BRD_Customer_AppointmentDetail: UIViewController {
    
    @IBOutlet weak var navigationMenu: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var objAppointment: BRD_AppointmentsInfoBO? = nil
    var arrayTableView = [Any]()
    var strTotalAmount: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Register Nib
        
        self.tableView.register(UINib(nibName: String(describing: BRD_Customer_AppointmentBooked.self), bundle: nil), forCellReuseIdentifier: KBRD_Customer_AppointmentBooked_CellIdentifier)
        
        self.tableView.register(UINib(nibName: String(describing: BRD_Customer_Appointment_SummaryofServices_TableViewCell.self), bundle: nil), forCellReuseIdentifier: KBRD_Customer_Appointment_SummaryofServices_TableViewCell_CellIdentifier)
        
        self.tableView.register(UINib(nibName: String(describing: BRD_Customer_Rating.self), bundle: nil), forCellReuseIdentifier: KBRD_Customer_Rating_CellIdentifier)
        
        self.tableView.register(UINib(nibName:String(describing: BRD_Appointment_TableViewCell.self), bundle: nil), forCellReuseIdentifier:KBRD_Appointment_TableViewCell_CellIdentifier )
        
        
        self.tableView.register(UINib(nibName: String(describing: BRD_Appointment_Paynow_TableViewCell.self), bundle: nil), forCellReuseIdentifier:KBRD_Appointment_Paynow_TableViewCell_CellIdentifier)
    
        
        self.tableView.register(UINib(nibName:String(describing: BRD_Customer_AppointmentDetail_YourBarber_TableViewCell.self), bundle: nil), forCellReuseIdentifier:KBRD_Customer_AppointmentDetail_YourBarber_TableViewCell_CellIdentifier)
        
        
//        let header = Bundle.main.loadNibNamed(String(describing: BRD_TopBar.self), owner: self, options: nil)![0] as? BRD_TopBar
//        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:75)
//        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
//         header?.btnProfile.addTarget(self, action: #selector(btnProfileAction), for: .touchUpInside)
//        self.navigationMenu.addSubview(header!)
//        
        
        
        let header = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitle.self), owner: self, options: nil)![0] as? NavigationBarWithTitle
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        header?.lblScreenTitle.text = KUpcomingAppointmentDetails
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(header!)
        
        self.arrayTableView = self.objAppointment!.services!
    }


    func backButtonAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getListOfServices(obj: BRD_AppointmentsInfoBO){
        
        if obj.services != nil {
            self.arrayTableView = obj.services!
        }
    }
    

}

extension BRD_Customer_AppointmentDetail: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var noOfRows: Int = 0
        switch section {
        case 3:
            noOfRows = self.arrayTableView.count
        default:
            noOfRows = 0
            break
        }
        return noOfRows
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
             let cell:AppointmentDetail_BarberServices = tableView.dequeueReusableCell(withIdentifier: AppointmentDetail_BarberServices.identifier()) as! AppointmentDetail_BarberServices
            cell.initWithData(obj: self.arrayTableView[indexPath.row] as! BRD_ServicesBO)
            return cell
   }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            return nil
        case 1:
            
            let header = tableView.dequeueReusableCell(withIdentifier: AppointmentDetailTableViewCell.identifier()) as? AppointmentDetailTableViewCell
            header?.initWithData(obj: self.objAppointment!)
            header?.btnAddToCalender.addTarget(self, action: #selector(btnAddToCalenderAction), for: .touchUpInside)
            return header
        case 2:
            
            let header = tableView.dequeueReusableCell(withIdentifier: ShopDetailTableViewCell.identifier()) as? ShopDetailTableViewCell
            header?.initWithData(obj: self.objAppointment!)
            header?.btnViewOnMap.addTarget(self, action: #selector(viewOnMapAction), for: .touchUpInside)
            return header
        case 3:
            let header = tableView.dequeueReusableCell(withIdentifier: AppointmentDetailSummaryTableViewCell.identifier()) as? AppointmentDetailSummaryTableViewCell
            return header
        case 4:
            let header = tableView.dequeueReusableCell(withIdentifier: AppointmentDetail_BarberProfile.identifier()) as? AppointmentDetail_BarberProfile
            header?.iniWithData(obj: self.objAppointment!)
            header?.btnContactBarber.addTarget(self, action: #selector(showContactBarberScreen), for: .touchUpInside)
            return header
            
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 3{
            
            let header = tableView.dequeueReusableCell(withIdentifier: AppointmentDetail_TotalPaid.identifier()) as? AppointmentDetail_TotalPaid
            header?.iniWithData(obj: self.objAppointment!)
            self.strTotalAmount = header?.lblTotalAmountDue.text
            header?.btnPayNow.addTarget(self, action: #selector(btnPayNowAction), for: .touchUpInside)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3{
            
            if self.objAppointment?.payment_status?.lowercased() == "confirm"{
                return 25.0
            }
            else if self.objAppointment?.payment_status?.lowercased() == "pending"{
                return 69.0
            }
            return 0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var sectionHeight: CGFloat = 0.0
        
        switch section {
        case 0: sectionHeight = 5.0
            break
        case 1:
            sectionHeight = 102.0
            break
        case 2:
            sectionHeight = 104.0
            break
        case 3:
            sectionHeight = 32.5
            break
        case 4:
            sectionHeight = 141.5
            break
        default:
            sectionHeight = 0.0
            break
            
        }
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 22.0
    }
    
    
    @objc private func showContactBarberScreen(){
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_ContactBarberVC_StoryboardID) as! BRD_Customer_ContactBarberVC
       // vc.objAppointmentInfo = self.objAppointment
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func btnPayNowAction(){
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_PayNowVC_StoryboardID) as! BRD_Customer_PayNowVC
        vc.totalAmount = self.strTotalAmount
        vc.payLaterFlag = true
        vc.appointmentId = self.objAppointment?._id
        
        vc.appointmentDate = self.objAppointment?.appointment_date
//        vc.barberDetails = self.objAppointment
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func viewOnMapAction(){
    
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_GoogleMapsVC_StoryboardID) as! BRD_GoogleMapsVC
        vc.arrayViewShop = [(self.objAppointment?.shop_id)!]
        vc.shouldHideButton = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func btnAddToCalenderAction(){
        var eventDescription: String = ""
        if self.objAppointment?.shop_name != nil{
            eventDescription = (self.objAppointment?.shop_name)! + "\n"
        }
        if self.objAppointment?.shop_id != nil{
            let address = self.objAppointment?.shop_id?.address
            eventDescription = eventDescription + address! + "\n"
            let city = self.objAppointment?.shop_id?.city
            eventDescription = eventDescription + city! + "\n"
            let state = self.objAppointment?.shop_id?.state
            eventDescription = eventDescription + state!
        }
        
        if self.objAppointment?.appointment_date != nil{
            //let appointmentDate: Date = Date.dateFromString((self.objAppointment?.appointment_date)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)!
            //self.addEventToCalendar(title: KAppointmentDetails, description: eventDescription, startDate: appointmentDate, endDate: appointmentDate)
            
            let appointmentStartDate: Date = Date.dateFromString((self.self.objAppointment?.appointment_date)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)!
            
            let calendar = Calendar.current
            let appointmentEndDate = calendar.date(byAdding: .minute, value: 15, to: appointmentStartDate)
            
            self.addEventToCalendar(title: KAppointmentDetails, description: eventDescription, startDate: appointmentStartDate, endDate: appointmentEndDate!)
        }
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
                
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Event added successfully to your iPhone calendar", onViewController: self, returnBlock: { (clickedIN) in
                })
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
}
