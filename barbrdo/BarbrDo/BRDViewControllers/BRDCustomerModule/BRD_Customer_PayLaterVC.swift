//
//  BRD_Customer_PayLaterVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 20/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
import EventKit



class PayLater_TableViewCell: UITableViewCell{
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var btnAddToCalender: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "PayLater_TableViewCell"
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
}

class BarberShopAddress_TableViewCell: UITableViewCell{
    
    @IBOutlet weak var lblBarberAddress: UILabel!
    
    @IBOutlet weak var btnViewOnMap: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "BarberShopAddress_TableViewCell"
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
}

class PayLater_SummaryofService: UITableViewCell{
    // MARK: - Identifier
    static func identifier() -> String {
        return "PayLater_SummaryofService"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class PayLater_BarberServices: UITableViewCell{
    
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblServiceCost: UILabel!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "PayLater_BarberServices"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class PayLater_TotalPaid: UITableViewCell{
    
    @IBOutlet weak var lblTotalCost: UILabel!
    @IBOutlet weak var btnPayNow: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "PayLater_TotalPaid"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


class PayLater_BarberDetail: UITableViewCell{
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblBarberName: UILabel!
    @IBOutlet weak var lblLastHairCut: UILabel!
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "PayLater_BarberDetail"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImageView?.layer.borderWidth = 1
        self.profileImageView?.layer.masksToBounds = false
        self.profileImageView?.layer.cornerRadius = (self.profileImageView?.frame.height)!/2
        self.profileImageView?.clipsToBounds = true
        self.profileImageView?.layer.borderColor = UIColor.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(obj: BRD_BarberInfoBO){
        
        self.lblBarberName.text = obj.first_name! + " " + obj.last_name!
        
        if let rating = obj.ratings{
            var rateValue: Float = 0
            for item in rating{
                rateValue = rateValue + item.score!
            }
            
            let avg: Float = rateValue / Float(rating.count)
            self.starRatingView.value = CGFloat(avg)
        }else{
            self.starRatingView.value = 0
        }
        
        if obj.picture != nil{
            let imagePath = KImagePathForServer + obj.picture!
            self.profileImageView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                
                DispatchQueue.main.async(execute: {
                    if image != nil{
                        self.profileImageView.image = image
                    }else{
                        self.profileImageView.image = UIImage(named: "ICON_PROFILEIMAGE.PNG")
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                })
            })
        }else{
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
        }
        
    }
}

class PayLater_GoHome: UITableViewCell{
    
    @IBOutlet weak var btnGoHome: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "PayLater_GoHome"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}




let KBRD_Customer_PayLaterVC_StoryboardID = "BRD_Customer_PayLaterVC_StoryboardID"

class BRD_Customer_PayLaterVC: UIViewController {
    
    
    @IBOutlet weak var viewNavigationBar: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var barberDetail: BRD_BarberInfoBO? = nil
    var shopDetail: BRD_ShopDataBO? = nil
    var arraryTableView = [BRD_BarberServicesBO]()
    var serviceArray : NSMutableArray = NSMutableArray()
    var strTotalCost: String? = nil
    var strDate: String? = nil
    var strTime: String? = nil
    var timeString : String? = nil
    var appointmentId : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let header = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitle.self), owner: self, options: nil)![0] as? NavigationBarWithTitle
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        header?.lblScreenTitle.text = KPayDuringYourVisit
        self.view.addSubview(header!)
    }

    func backButtonAction(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BRD_Customer_PayLaterVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalNumberofRows: Int = 0
        switch section {
        case 2:
            totalNumberofRows = self.arraryTableView.count
            break
        default:
            break
        }
        return totalNumberofRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: PayLater_BarberServices.identifier()) as? PayLater_BarberServices
        if cell == nil {
            cell = PayLater_BarberServices(style: .value1, reuseIdentifier: PayLater_BarberServices.identifier())
        }
        
        let obj = self.arraryTableView[indexPath.row]
        cell?.lblServiceName.text = obj.name
        cell?.lblServiceCost.text = "$ " + String(describing: obj.price!)
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 22
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section{
            case 0:
                let header = tableView.dequeueReusableCell(withIdentifier: PayLater_TableViewCell.identifier()) as? PayLater_TableViewCell
                header?.lblDate.text = self.strDate
                header?.lblTime.text = self.strTime
                header?.btnAddToCalender.addTarget(self, action: #selector(btnAddtoCalendarAction), for: .touchUpInside)
                return header
            case 1:
                let header = tableView.dequeueReusableCell(withIdentifier: BarberShopAddress_TableViewCell.identifier()) as? BarberShopAddress_TableViewCell
                
                var address = ""
                if let shopName = self.shopDetail?.name {
                    address = shopName + "\n"
                }else{
                    address = "Pop's Barber Shop" + "\n"
                }
                if let shopDetails = self.shopDetail?.address {
                    address = address + shopDetails + ", \n"
                }
                if let city = self.shopDetail?.city {
                    address = address + city + ", "
                }
                if let state = self.shopDetail?.state {
                    address = address + state
                }
                header?.lblBarberAddress.text =  address
                header?.btnViewOnMap.addTarget(self, action: #selector(viewOnMapAction), for: .touchUpInside)
                return header
            case 2:
                let header = tableView.dequeueReusableCell(withIdentifier: PayLater_SummaryofService.identifier()) as? PayLater_SummaryofService
                return header
            case 3:
                let header = tableView.dequeueReusableCell(withIdentifier: PayLater_BarberDetail.identifier()) as? PayLater_BarberDetail
//                header?.lblBarberName.text = (self.barberDetail?.first_name)! + " " + (self.barberDetail?.last_name)!
                
                
                if self.barberDetail != nil{
                    header?.initWithData(obj: self.barberDetail!)
                }
                return header
            case 4:
                
                let header = tableView.dequeueReusableCell(withIdentifier: PayLater_GoHome.identifier()) as? PayLater_GoHome
                header?.btnGoHome.addTarget(self, action: #selector(btnGoHomeAction), for: .touchUpInside)
                return header
            default:
                break
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 2{
            let header = tableView.dequeueReusableCell(withIdentifier: PayLater_TotalPaid.identifier()) as? PayLater_TotalPaid
            if strTotalCost != nil{
              header?.lblTotalCost.text = strTotalCost
            }
            header?.btnPayNow.addTarget(self, action: #selector(btnPayNowAction), for: .touchUpInside)
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
            headerHeight = 106.0
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
       /* let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_GoogleMapsVC_StoryboardID) as! BRD_GoogleMapsVC
        
        if self.shopDetail != nil{
            vc.latitude = (self.shopDetail?.latitude)!
            vc.longitude = (self.shopDetail?.longitude)!
        }
        self.navigationController?.pushViewController(vc, animated: true)*/
        
        
        
        if self.shopDetail?.latitude != nil && self.shopDetail?.longitude != nil{
            
            
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_GoogleMapsVC_StoryboardID) as! BRD_GoogleMapsVC
            vc.arrayViewShop = [self.shopDetail!]
            vc.shouldHideButton = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Could not get of the Shop", onViewController: self, returnBlock: { (clickedIN) in
                
            })
        }
    }
    
    @objc private func btnPayNowAction(){
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_PayNowVC_StoryboardID) as! BRD_Customer_PayNowVC
        
        
        vc.totalAmount = strTotalCost
        vc.serviceArray =  self.serviceArray
        vc.payLaterFlag = true
        vc.appointmentId = self.appointmentId
        vc.barberDetails = self.barberDetail
        vc.appointmentDate = self.timeString
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func btnAddtoCalendarAction(){
        
        var eventDescription: String = ""
        if self.shopDetail != nil{
            if self.shopDetail?.name != nil{
                eventDescription = (self.shopDetail?.name)! + "\n"
            }
            let address = self.shopDetail?.address
            eventDescription = eventDescription + address! + "\n"
            let city = self.shopDetail?.city
            eventDescription = eventDescription + city! + "\n"
            let state = self.shopDetail?.state
            eventDescription = eventDescription + state!
        }
        
        var currentDate: String = self.strDate!
        
        let date1 = Date()
        let calendar = Calendar.current
        let yearr = calendar.component(.year, from: date1)
        
        let combinedString = currentDate + ", " + String(describing: yearr)
        
        currentDate = Date.convert(combinedString, Date.DateFormat.EEEE_MMMM_dd_yyyy, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        let currentDD = Date.dateFromString(currentDate, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        
        let appointmentEndDate = calendar.date(byAdding: .minute, value: 15, to: currentDD!)
        
        self.addEventToCalendar(title: KAppointmentDetails, description: eventDescription, startDate: currentDD!, endDate: appointmentEndDate!)
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
