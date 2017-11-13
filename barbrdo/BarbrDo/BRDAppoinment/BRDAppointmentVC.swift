
//
//  BRDAppointmentVC.swift
//  BarbrDo
//
//  Created by Vishwajeet Kumar on 5/15/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
import SwiftLoader

fileprivate let cellHeight: CGFloat      =      40.0

class BRDAppointmentCell: UITableViewCell {
    
    // label
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // view
    @IBOutlet weak var cellBackgroundView: UIView!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "BRDAppointmentCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellBackgroundView.layer.cornerRadius = 5.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class BRDAppointmentVC: BRD_BaseViewController {
    
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    var arrayTableView = [BRD_BarberServicesBO]()
    var arraySelectedServices = [BRD_BarberServicesBO]()
    
    @IBOutlet weak var viewNavigationBar: UIView!
    @IBOutlet weak var appointmentView: UIView!
    
    @IBOutlet weak var ratingView: SwiftyStarRatingView!
    
    // tableView
    @IBOutlet weak var tableView: UITableView!
    
    // imageView
    @IBOutlet weak var profileImageview: UIImageView!
    
    // label
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memberDateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var barberDetails: BRD_BarberInfoBO?
    var shopDetails: BRD_ShopDataBO?
    var shopID : String? = nil
    var timeString: String = ""
    var dateString: String = ""
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "BRDAppointmentVC"
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = Bundle.main.loadNibNamed(String(describing: BRD_TopBar.self), owner: self, options: nil)![0] as? BRD_TopBar
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:75)
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        header?.btnProfile.addTarget(self, action: #selector(btnProfileAction), for: .touchUpInside)

        self.viewNavigationBar.addSubview(header!)
        
        self.tableView.register(UINib(nibName: String(describing: BRD_BookAnAppointment_TableViewCell.self), bundle: nil), forCellReuseIdentifier: KBRD_BookAnAppointment_TableViewCell_CellIdentifier)
        
        
        _initialization()
        self.getBarberServices()
        
        self.lblTotalAmount.text = "$ 0"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.shopID = nil
    }
    func backButtonAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    func btnProfileAction() {
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_Profile_StoryboardID) as! BRD_Customer_ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Memory Management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Other Method
    private func _initialization() {
        self.navigationController?.isNavigationBarHidden = true
        
        if let firstname = barberDetails?.first_name {
            self.nameLabel.text = firstname
            if let lastname = barberDetails?.last_name {
                self.nameLabel.text = "\(firstname) \(lastname)"
            }
        }
        if let createDate = barberDetails?.created_date {
             let dateString = Date.convert(createDate, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMMM_dd)
            if dateString == ""{
                self.memberDateLabel.text = KMemberSince
            }else{
               self.memberDateLabel.text = KMemberSince + dateString
            }
        }
        
        if let rating = barberDetails?.ratings{
            var rateValue: Float = 0
            for item in rating{
                rateValue = rateValue + item.score!
            }
            
            let avg: Float = rateValue / Float(rating.count)
            self.ratingView.value = CGFloat(avg)
        }else{
            self.ratingView.value = 0
        }
        
        if self.dateString.characters.count > 0 {
            let dateString = Date.convert(self.dateString, Date.DateFormat.MMM_dd, Date.DateFormat.EEEE_MMM_dd)
            self.dateLabel.text = dateString.uppercased()
        }
        
        self.timeLabel.text = self.timeString.uppercased()
        
        self.profileImageview = self.profileImageview.circularImageView()
        self.appointmentView.layer.cornerRadius = 5.0
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = .clear
    }
    
    
    func getBarberServices() {
        
        let obj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        var latitude: String? = "30.23"
        var longtitude: String? = "70.25"
       
        if let lat = obj?.latitude{
             latitude = String(format:"%f", lat)
        }
        
        if let long = obj?.longitude{
            longtitude = String(format:"%f", long)
        }
      
        
        
        let header: [String: String] =
            [KLatitude : latitude!,
             KLongitude: longtitude!,
             KUserID : (obj?._id)!,
             KBarberID : (self.barberDetails?._id)!]
        
        let urlComponent = "barber/services/" + (self.barberDetails?._id)!
        BRD_BarberServicesBOBL.initWithParameters("Get", urlComponent: urlComponent, inputParameters: [:], headers: header) { (array, error) in
            
            if array != nil{
                if (array?.count)! > 0{
                    self.arrayTableView.removeAll()
                    self.arrayTableView = array!
                    self.tableView.reloadData()
                }
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
                return
            }
        }
        
        
    }
    
    @IBAction func btnAppointmentPaymentAction(_ sender: UIButton) {
        if self.lblTotalAmount.text == "$ 0"{
            _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: KSelectBarberServices, onViewController: self, returnBlock: { (clickedIN) in
                
            })
            return
        }
        
        
        if sender.tag == 101{
            
            self.postApppointment()
//            let storyboard = UIStoryboard(name:"Customer", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_PayLaterVC_StoryboardID) as! BRD_Customer_PayLaterVC
//            vc.arraryTableView = self.arraySelectedServices
//            vc.strTotalCost = self.lblTotalAmount.text
//            vc.barberDetail = self.barberDetails
//            vc.strDate = self.dateLabel.text
//            vc.strTime = self.timeLabel.text
//            vc.shopDetail = self.shopDetails
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        if sender.tag == 102{
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_PayNowVC_StoryboardID) as! BRD_Customer_PayNowVC
            vc.totalAmount = self.lblTotalAmount.text
            vc.shopDetail =   self.shopDetails
            vc.barberDetails = self.barberDetails
            vc.appointmentFlag = true
            
            var services = [Any]()
            for obj in self.arraySelectedServices{
                let dict: [String: Any] = ["id": obj._id!, "name": obj.name ?? "Barber Service", "price": obj.price ?? "10"]
                services.append(dict)
            }

            vc.serviceArray = services as! NSMutableArray
            let calendar = Calendar.autoupdatingCurrent
            let components = calendar.dateComponents([.hour, .minute, .year], from: Date())
            let year = components.year
            
            let strDateStringf = self.dateLabel.text! + ", " + String(describing: year!)
            
            let dateString = Date.convert(strDateStringf, Date.DateFormat.EEEE_MMMM_dd_yyyy, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
            // let timeString = Date.convert(self.timeLabel.text!, Date.TimeFormat.hh_mm_a, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            let item = self.timeLabel.text!
            let date = dateFormatter.date(from: item)
            print("Start: \(String(describing: date))") // Start: Optional(2000-01-01 19:00:00 +0000)
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z
            let timeString = formatter1.string(from: date!)
            
            
            
            let dDate = Date.dateFromString(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
            let tDate = Date.dateFromString(timeString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
            
            let fDate = Date.combineDateWithTime(date: dDate!, time: tDate!)
            
            let finalDateString = Date.stringFromDate(fDate!, Date.DateFormat.yyyy_MM_dd_HH_mm_ss)
            
            vc.appointmentDate = finalDateString
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateTotalAmount() {
        
        var totalAmount: Int = 0
        for (index, element) in self.arraySelectedServices.enumerated(){
            totalAmount = totalAmount + element.price!
        }
        self.lblTotalAmount.text = "$ " + String(describing: totalAmount)
    }
    
    
    func postApppointment(){
        //   API PARAMETERS
        /*
            "shop_id": "591be658b902f60fcc14a9d6",
            "barber_id": "591be608b902f60fcc14a9d3",
            "payment_method": "cash",
            "services": [
            {
            "id": "591bf1d39f3ee312abea7e95"
            }
            ],
            "appointment_date": "2017-07-10 10:00:00"
            }
        */
        
        SwiftLoader.show(KLoading, animated: true)
        
        
        let calendar = Calendar.autoupdatingCurrent
        let components = calendar.dateComponents([.hour, .minute, .year], from: Date())
        let year = components.year
      
        let strDateStringf = self.dateLabel.text! + ", " + String(describing: year!)
        
        let dateString = Date.convert(strDateStringf, Date.DateFormat.EEEE_MMMM_dd_yyyy, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
       // let timeString = Date.convert(self.timeLabel.text!, Date.TimeFormat.hh_mm_a, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let item = self.timeLabel.text!
        let date = dateFormatter.date(from: item)
        print("Start: \(String(describing: date))") // Start: Optional(2000-01-01 19:00:00 +0000)
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z
        let timeString = formatter1.string(from: date!)
        
        
        
        let dDate = Date.dateFromString(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        let tDate = Date.dateFromString(timeString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        
        let fDate = Date.combineDateWithTime(date: dDate!, time: tDate!)
        
        let finalDateString = Date.stringFromDate(fDate!, Date.DateFormat.yyyy_MM_dd_HH_mm_ss)
        
        let header : [String: String]? = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{return}
        
        var services = [Any]()
        for obj in self.arraySelectedServices{
            let dict: [String: Any] = ["_id": obj._id!,
                                       "name": obj.name ?? "Barber Service",
                                       "price": obj.price]
            services.append(dict)
        }
        var shop_ID : String = ""
        
        if self.shopID != nil{
            shop_ID = self.shopID!
        }else{
            if self.shopDetails != nil{
                shop_ID = (self.shopDetails?._id)!
            }else{
                shop_ID = (self.barberDetails?.shop_id)!
            }
        }
        let obj = self.barberDetails
        
        let amount = self.lblTotalAmount.text?.replacingOccurrences(of: "$ ", with: "")
        
        
        let  chair_id = obj?.chair_id
        let chair_name = obj?.chair_name
        
        let chair_type = obj?.chair_type
        let chair_amount = obj?.chair_amount
        let chair_shop_percentage = obj?.chair_shop_percentage
        let chair_barber_percentage = obj?.chair_barber_percentage
        let inputParameters :[String: Any] = ["shop_id": shop_ID,
                               "barber_id": (self.barberDetails?._id)!,
                               "amount": amount! , "payment_method" : "card" , "services":  services ,"appointment_date" : finalDateString   , "totalPrice" : amount! , "chair_id" : chair_id! , "chair_name" : chair_name! , "chair_type" : chair_type! , "chair_amount" : chair_amount == nil ? "" : chair_amount! , "chair_shop_percentage" : chair_shop_percentage  , "chair_barber_percentage" : chair_barber_percentage   ] as [String: Any]
        
//       let inputParameters :[String: Any] = ["shop_id": shop_ID,
//                                               "barber_id": (self.barberDetails?._id)!, "payment_method":"cash", "appointment_date":finalDateString,
//                                               "services": services,
//                                               ]
        
        print(inputParameters)
        
        let urlString = KBaseURLString + KGetAllAppointmentURL
        
        BRDAPI.postAnAppointment("POST", inputParameter: inputParameters, header: header!, urlString: urlString) { (response, responseString, status, error) in
            
            
            var services = [Any]()
            for obj in self.arraySelectedServices{
                let dict: [String: Any] = ["_id": obj._id!, "name": obj.name ?? "Barber Service", "price": obj.price ?? "10"]
                services.append(dict)
            }
            
            SwiftLoader.hide()
            
            if status == ResponseStatus.success{
                // Success code here
                if  responseString != nil
                {
                    let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_PayLaterVC_StoryboardID) as! BRD_Customer_PayLaterVC
                    vc.arraryTableView =  BRD_BarberServicesBO.modelsFromDictionaryArray(array: services as NSArray)
                    vc.serviceArray = (services as? NSMutableArray)!
                    vc.strTotalCost = self.lblTotalAmount.text
                    vc.barberDetail = self.barberDetails
                    vc.appointmentId = responseString?._id
                    vc.strDate = self.dateLabel.text
                    vc.strTime = self.timeLabel.text
                    vc.timeString = finalDateString
                    vc.shopDetail = self.shopDetails
                    self.navigationController?.pushViewController(vc, animated: true)

                }
            }else{
                var errorMessage: String = "Please try again later"
                
                if error != nil{
                    errorMessage = (error?.localizedDescription)!
                }
                
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: errorMessage, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
                return
            }
        }
        
//        BRD_AppointmentsInfoBOBL.initWithPOSTRequest("POST", inputParameters: dict, header: header!, urlComponent: "appointment", completionHandler: { (resposnse, error) in
//            
//            print(resposnse)
//            SwiftLoader.hide()
//            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
//            
//            if resposnse == "SUCCESS"{
//                let storyboard = UIStoryboard(name:"Customer", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_PayLaterVC_StoryboardID) as! BRD_Customer_PayLaterVC
//                vc.arraryTableView = self.arraySelectedServices
//                vc.strTotalCost = self.lblTotalAmount.text
//                vc.barberDetail = self.barberDetails
//                vc.strDate = self.dateLabel.text
//                vc.strTime = self.timeLabel.text
//                vc.shopDetail = self.shopDetails
//                self.navigationController?.pushViewController(vc, animated: true)
//
//            }else{
//                
//            }
//        })
    }
}

extension BRDAppointmentVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTableView.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  cellHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: BRDAppointmentCell.identifier()) as? BRDAppointmentCell
        if cell == nil {
            cell = BRDAppointmentCell(style: .value1, reuseIdentifier: BRDAppointmentCell.identifier())
            cell?.titleLabel.textColor = KLightGreyColor
            cell?.priceLabel.textColor = KLightGreyColor
        }
        let obj = self.arrayTableView[indexPath.row]
        cell?.titleLabel.textColor = KLightGreyColor
        cell?.priceLabel.textColor = KLightGreyColor
        cell?.titleLabel.text = obj.name
        cell?.priceLabel.text = "$ " + String(describing: obj.price!)

        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        cell?.cellBackgroundView.backgroundColor = UIColor.white
        for (index, element) in self.arraySelectedServices.enumerated() {
            print("Item \(index): \(element)")
            if element == obj{
                cell?.cellBackgroundView.backgroundColor = KLightBlueColor
                cell?.titleLabel.textColor = UIColor.white
                cell?.priceLabel.textColor = UIColor.white
            }
        }
        return cell!
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if self.arraySelectedServices.contains(self.arrayTableView[indexPath.row]) {
            if let index = self.arraySelectedServices.index(of: self.arrayTableView[indexPath.row]) {
             if self.arraySelectedServices.count > index  {
                self.arraySelectedServices.remove(at: index)
            }
            }
        }
        else {
            self.arraySelectedServices.append(self.arrayTableView[indexPath.row])
        }
        self.tableView.reloadData()
        self.updateTotalAmount()
    }
    
}
