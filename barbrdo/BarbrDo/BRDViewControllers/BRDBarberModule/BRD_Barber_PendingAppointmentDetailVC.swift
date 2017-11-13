//
//  BRD_Barber_PendingAppointmentDetailVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 25/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
import SwiftLoader
import EventKit

let KBRD_Barber_PendingAppointmentDetailVC_StoryboardID = "BRD_Barber_PendingAppointmentDetailVC_StoryboardID"


class AppointmentBookTableViewCell: UITableViewCell{
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnAddToCalender: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "AppointmentBookTableViewCell"
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
    
    
    func initWithData(objAppointmentDetail: BRD_BarberAppointmentsBO){
        self.lblDate.text = Date.convert(objAppointmentDetail.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.EEEE_MMMM_dd)
        self.lblTime.text = Date.convert(objAppointmentDetail.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.TimeFormat.hh_mm_a)
    }
}


class BarberShopAddressTableViewCell: UITableViewCell{
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnViewOnMap: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "BarberShopAddressTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnViewOnMap.layer.borderColor = KRedColor.cgColor
        self.btnViewOnMap.layer.borderWidth = 2.0
        self.btnViewOnMap.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(objAppointmentData: BRD_BarberAppointmentsBO){
        
        if let shopDetail = objAppointmentData.shop_id{
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
            
            self.lblAddress.text = address
        }
    }
}

class SummaryOfServicesTableViewCell: UITableViewCell{
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "SummaryOfServicesTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
class AppointmentServicesTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblServicePrice: UILabel!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "AppointmentServicesTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class Barber_PaymentReceived: UITableViewCell{
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var btnPaymentReceived: UIButton!
    
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "Barber_PaymentReceived"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(arrayServices: [BRD_ServicesBO]?, objAppointmentInfo: BRD_BarberAppointmentsBO){
        
        if let services = arrayServices{
            
            var value: Double = 0
            for obj in services{
                if obj.price != nil{
                    value = value + obj.price
                }
            }
            
            var strPaymentTitle: String = ""
            
            if objAppointmentInfo.payment_status == KPaymentStatusPending{
                strPaymentTitle = KPaymentDue
            }else{
                strPaymentTitle = KPaymentReceived
            }
            
            self.lblTitle.text = strPaymentTitle
            self.lblTotalAmount.text = "$ " + String(format: "%.2f", value)
                //String(format: "%.02f", totalPrice)
            let btnTitle = strPaymentTitle + " : $ " + String(format: "%.2f", value)
                //String(format: "%.02f", totalPrice)
            self.btnPaymentReceived.setTitle(btnTitle, for: .normal)
        }
    }
}

class CustomerDetailTableViewCell: UITableViewCell{
    
    @IBOutlet weak var customerImageView: UIImageView!
    
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblLastCut: UILabel!
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "CustomerDetailTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.customerImageView.layer.borderWidth = 1.0
        self.customerImageView.layer.masksToBounds = false
        self.customerImageView.layer.borderColor = UIColor.white.cgColor
        self.customerImageView.layer.cornerRadius = self.customerImageView.frame.size.width/2
        self.customerImageView.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func initWithData(objCustomerDetail: BRD_CustomerIDBO){
        
        if objCustomerDetail.first_name != nil && objCustomerDetail.last_name != nil{
            self.lblCustomerName.text = objCustomerDetail.first_name! + " " + objCustomerDetail.last_name!
        }
        
        
        
        if objCustomerDetail.picture != nil || objCustomerDetail.picture == ""{
            
                let imagePath = KImagePathForServer + objCustomerDetail.picture!
                self.customerImageView.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage(named: "ICON_PROFILEIMAGE"))
        }
    }
}

class RescheduleTableViewCell: UITableViewCell{
    
    @IBOutlet weak var btnReschedule: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "RescheduleTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class BRD_Barber_PendingAppointmentDetailVC: UIViewController{
    
    @IBOutlet weak var viewNavigationBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var arrayTableView = [BRD_ServicesBO]()
    
    var objBarberAppointment: BRD_BarberAppointmentsBO? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let header = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitle.self), owner: self, options: nil)![0] as? NavigationBarWithTitle
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        header?.lblScreenTitle.text = KPendingAppointmentDetails
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(header!)

        // Do any additional setup after loading the view.
        
        
        if let services = self.objBarberAppointment?.services{
            self.arrayTableView.removeAll()
            self.arrayTableView = services
            self.tableView.reloadData()
        }
    }
    
    func btnProfileAction() {
        
        let storyboard = UIStoryboard(name:"Customer", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_Profile_StoryboardID) as! BRD_Customer_ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension BRD_Barber_PendingAppointmentDetailVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalNumberofRows: Int = 0
        switch section {
        case 2:
            totalNumberofRows = self.arrayTableView.count
            break
        default:
            break
        }
        return totalNumberofRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: AppointmentServicesTableViewCell.identifier()) as? AppointmentServicesTableViewCell
        if cell == nil {
            cell = AppointmentServicesTableViewCell(style: .value1, reuseIdentifier: AppointmentServicesTableViewCell.identifier())
        }
        
        let obj = self.arrayTableView[indexPath.row]
        if obj.name != nil{
            cell?.lblServiceName.text = obj.name
        }
        if obj.price != nil{
            cell?.lblServicePrice.text = "$ " + String(describing: obj.price!)
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 22
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section{
        case 0:
            let header = tableView.dequeueReusableCell(withIdentifier: AppointmentBookTableViewCell.identifier()) as? AppointmentBookTableViewCell
            header?.initWithData(objAppointmentDetail: self.objBarberAppointment!)
            header?.btnAddToCalender.addTarget(self, action: #selector(btnAddCalendarAction), for: .touchUpInside)
            return header
        case 1:
            let header = tableView.dequeueReusableCell(withIdentifier: BarberShopAddressTableViewCell.identifier()) as? BarberShopAddressTableViewCell
            header?.initWithData(objAppointmentData: self.objBarberAppointment!)
            
          //  header?.lblBarberAddress.text =  address//self.barberDetail?.location
           header?.btnViewOnMap.addTarget(self, action: #selector(viewOnMapAction), for: .touchUpInside)
            return header
        case 2:
            let header = tableView.dequeueReusableCell(withIdentifier: SummaryOfServicesTableViewCell.identifier()) as? SummaryOfServicesTableViewCell
            return header
        case 3:
            let header = tableView.dequeueReusableCell(withIdentifier: CustomerDetailTableViewCell.identifier()) as? CustomerDetailTableViewCell
            if let customerInfo = self.objBarberAppointment?.customer_id{
                header?.initWithData(objCustomerDetail: customerInfo)
            }
            header?.btnConfirm.addTarget(self, action: #selector(btnConfirmAction), for: .touchUpInside)
            return header
        case 4:
            
            let header = tableView.dequeueReusableCell(withIdentifier: RescheduleTableViewCell.identifier()) as? RescheduleTableViewCell
            header?.btnReschedule.addTarget(self, action: #selector(btnRescheduleAction), for: .touchUpInside)
            return header
        default:
            break
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 2{
            let header = tableView.dequeueReusableCell(withIdentifier: Barber_PaymentReceived.identifier()) as? Barber_PaymentReceived
            header?.initWithData(arrayServices: self.arrayTableView,objAppointmentInfo: self.objBarberAppointment!)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerHeight: CGFloat = 0
        switch section {
        case 0:
            headerHeight = 102.0
            break
        case 1:
            headerHeight = 104
            break
        case 2:
            headerHeight = 32.0
            break
        case 3:
            headerHeight = 141.0
            break
        case 4:
            headerHeight = 45.0
        default:
            break
        }
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2{
            return 64
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc private func btnGoHomeAction(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func viewOnMapAction(){
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_GoogleMapsVC_StoryboardID) as! BRD_GoogleMapsVC
        if let objAppointment = self.objBarberAppointment{
            
            if let objShopInfo = objAppointment.shop_id{
                var array = [BRD_ShopDataBO]()
                array.append(objShopInfo)
                vc.arrayViewShop = array
            }
        }
        
        vc.shouldHideButton = true
        vc.isRequestFromBarber = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func btnConfirmAction(){
        
        let obj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        
        let header : [String: String] =
            [KLatitude: String(describing: obj?.latitude),
             KLongitude: String(describing: obj?.latitude),
             KUserID: (obj?._id)!,
             KAppointmentID: (self.objBarberAppointment?._id)!]
        
        
        let urlString = KBaseURLString + KConfirmAppointment + (self.objBarberAppointment?._id)!
        
        SwiftLoader.show(KConfirmAppointmentText, animated: true)
        BRDAPI.confirmAppointment("PUT", inputParameters: nil, header: header , urlString: urlString) { (reponse, responseMessage, status, error) in
            
            SwiftLoader.hide()
            if responseMessage == "Updated successfully"{
                _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: "Appointment Confirmed", onViewController: self, returnBlock: { (clickedIN) in
                    _ = self.navigationController?.popViewController(animated: true)
                })
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
            }
        }
    }
    
    @objc private func btnRescheduleAction(){
        
        let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_ContactCustomerVC_StoryboardID) as! BRD_Barber_ContactCustomerVC
        vc.objBarber = self.objBarberAppointment
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func btnAddCalendarAction(){
        var eventDescription: String = ""
        if self.objBarberAppointment?.shop_id != nil{
            eventDescription = (self.objBarberAppointment?.shop_name)! + "\n"
        }
        if self.objBarberAppointment?.shop_id != nil{
            let address = self.objBarberAppointment?.shop_id?.address
            eventDescription = eventDescription + address! + "\n"
            let city = self.objBarberAppointment?.shop_id?.city
            eventDescription = eventDescription + city! + "\n"
            let state = self.objBarberAppointment?.shop_id?.state
            eventDescription = eventDescription + state!
        }
        
        if self.objBarberAppointment?.appointment_date != nil{
           // var appointmentDate: Date = Date.dateFromString((self.objBarberAppointment?.appointment_date)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)!
        
           // self.addEventToCalendar(title: KAppointmentDetails, description: eventDescription, startDate: appointmentDate, endDate: appointmentDate.addTimeInterval(15))
            
            
            
            let appointmentStartDate: Date = Date.dateFromString((self.objBarberAppointment?.appointment_date)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)!
            
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
