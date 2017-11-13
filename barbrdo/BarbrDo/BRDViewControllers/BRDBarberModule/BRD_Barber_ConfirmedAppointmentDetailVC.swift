//
//  BRD_Barber_ConfirmedAppointmentDetailVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 29/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader
import SwiftyStarRatingView
import EventKit


let KBRD_Barber_ConfirmedAppointmentDetailVC_StoryboardID = "BRD_Barber_ConfirmedAppointmentDetailVC_StoryboardID"


class Barber_AppointmentBooked: UITableViewCell{
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnAddToCalender: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "Barber_AppointmentBooked"
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


class Barber_ShopAddress: UITableViewCell{
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnViewOnMap: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "Barber_ShopAddress"
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

class Barber_SummaryofServices: UITableViewCell{
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "Barber_SummaryofServices"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
class Barber_AppointmentServices: UITableViewCell{
    
    
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblServicePrice: UILabel!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "Barber_AppointmentServices"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class Barber_TotalPayment: UITableViewCell{
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblPaymentReceived: UILabel!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "Barber_TotalPayment"
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
            
            let totalPrice = Float(value)
            self.lblTotalAmount.text = "$ " + String(format: "%.02f", totalPrice)
            self.lblPaymentReceived.text = strPaymentTitle + ": $ " + String(format: "%.02f", totalPrice)
        }
    }
}

class Barber_CustomerDetail: UITableViewCell{
    
    @IBOutlet weak var customerImageView: UIImageView!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblLastCut: UILabel!
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    @IBOutlet weak var btnConfirm: UIButton!
    
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "Barber_CustomerDetail"
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

class BRD_Barber_ConfirmedAppointmentDetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayTableView = [BRD_ServicesBO]()
    var objBarberAppointment: BRD_BarberAppointmentsBO? = nil
    var headerMarkComplete: Barber_CustomerDetail? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitle.self), owner: self, options: nil)![0] as? NavigationBarWithTitle
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        header?.lblScreenTitle.text = KConfirmedAppointmentDetails
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(header!)

        // Do any additional setup after loading the view.
        
        if let services = self.objBarberAppointment?.services{
            self.arrayTableView.removeAll()
            self.arrayTableView = services
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BRD_Barber_ConfirmedAppointmentDetailVC: UITableViewDelegate, UITableViewDataSource{
    
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
        cell?.lblServiceName.text = obj.name
        
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
            let header = tableView.dequeueReusableCell(withIdentifier: Barber_AppointmentBooked.identifier()) as? Barber_AppointmentBooked
            header?.initWithData(objAppointmentDetail: self.objBarberAppointment!)
            header?.btnAddToCalender.addTarget(self, action: #selector(btnAddCalendarAction), for: .touchUpInside)
            return header
        case 1:
            let header = tableView.dequeueReusableCell(withIdentifier: Barber_ShopAddress.identifier()) as? Barber_ShopAddress
            header?.initWithData(objAppointmentData: self.objBarberAppointment!)
            header?.btnViewOnMap.addTarget(self, action: #selector(viewOnMapAction), for: .touchUpInside)
            return header
        case 2:
            let header = tableView.dequeueReusableCell(withIdentifier: SummaryOfServicesTableViewCell.identifier()) as? SummaryOfServicesTableViewCell
            return header
        case 3:
        
            self.headerMarkComplete = tableView.dequeueReusableCell(withIdentifier: Barber_CustomerDetail.identifier()) as? Barber_CustomerDetail
            if let customerInfo = self.objBarberAppointment?.customer_id{
                self.headerMarkComplete?.initWithData(objCustomerDetail: customerInfo)
            }
            
            self.headerMarkComplete?.starRatingView.addTarget(self, action: #selector(ratingValueChanged), for: .valueChanged)
            self.headerMarkComplete?.btnConfirm.addTarget(self, action: #selector(btnConfirmAction), for: .touchUpInside)
            return self.headerMarkComplete
        default:
            break
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 2{
            let header = tableView.dequeueReusableCell(withIdentifier: Barber_TotalPayment.identifier()) as? Barber_TotalPayment
            header?.initWithData(arrayServices: self.arrayTableView, objAppointmentInfo: self.objBarberAppointment!)
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
            headerHeight = 104.0
            break
        case 2:
            headerHeight = 32.0
            break
        case 3:
            headerHeight = 141.0
            break
        default:
            break
        }
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2{
            return 64.0
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
        
        /*if self.headerMarkComplete?.starRatingView.value == 0 {
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Please Rate Your Customer", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
            
        }else{
            print("No")
        }*/
        
        let obj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        let result = formatter.string(from: date)
        
        /*let inputParameters: [String: Any] = ["customer_id": (self.objBarberAppointment?.customer_id?._id)!,
                                              "score": (self.headerMarkComplete?.starRatingView.value)!,
                                                "rated_by_name": (self.objBarberAppointment?.customer_name)!,
                                                "appointment_date": result]*/
        let inputParameters: [String: Any] = ["customer_id": (self.objBarberAppointment?.customer_id?._id)!,
                                              "score": 0,
                                              "rated_by_name": (self.objBarberAppointment?.customer_name)!,
                                              "appointment_date": result]
        print(inputParameters)
        
        let header : [String: String] =
            [KLatitude : String(describing: obj?.latitude),
             KLongitude: String(describing: obj?.latitude),
             KUserID : (obj?._id)!,
             KAppointmentID : (self.objBarberAppointment?._id)!]
        
        let urlString = KBaseURLString + KCompleteAppointment + (self.objBarberAppointment?._id)!
        
        SwiftLoader.show(KLoading, animated: true)
        BRDAPI.completeAppointment("PUT", inputParameters: inputParameters, header: header , urlString: urlString) { (reponse, responseMessage, status, error) in
            
            SwiftLoader.hide()
            if responseMessage == "Updated successfully"{
                _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: "Updated successfully", onViewController: self, returnBlock: { (clickedIN) in
                    self.navigationController?.popViewController(animated: true)
                })
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
            }
        }
    }
    
    @objc private func ratingValueChanged(){
        print(self.headerMarkComplete?.starRatingView.value ?? "Could Not Get Value")
    }
    
    
    @objc private func btnRateCustomer(){
        
        print("Rate Customer")
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
