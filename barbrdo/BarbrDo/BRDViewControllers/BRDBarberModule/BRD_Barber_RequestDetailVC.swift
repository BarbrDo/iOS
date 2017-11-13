
//
//  BRD_Barber_RequestDetailVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/23/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

let KBRD_Barber_RequestDetailVC_StoryboardID = "BRD_Barber_RequestDetailVC_StoryboardID"

class RequestChairHeaderCell: UITableViewCell{
    
    @IBOutlet weak var lblAddress : UILabel!
    @IBOutlet weak var btnShop : UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "RequestChairHeaderCell"
    }
    
    override func awakeFromNib() {
        self.btnShop.layer.cornerRadius = 2.0
        self.btnShop.layer.borderWidth = 1.0
        self.btnShop.layer.borderColor = UIColor.red.cgColor
        //self.whiteView.layer.cornerRadius = 4.0
    }
    
    func initWithData(obj: BRD_ShopDataBO){
        
        
        var address = ""
        if let shopName = obj.name {
            address = shopName + "\n"
        }else{
            address = "Pop's Barber Shop" + "\n"
        }
        if let shopDetails = obj.address {
            address = address + shopDetails + ", \n"
        }
        if let city = obj.city {
            address = address + city + ", "
        }
        if let state = obj.state {
            address = address + state
        }
        self.lblAddress?.text =  address
    }
}



class RequestDetailCell:UITableViewCell
{
    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var profileIconImage: UIImageView!
    @IBOutlet weak var chairLbl: UILabel!
    @IBOutlet weak var chairSplitLbl: UILabel!
    @IBOutlet weak var btnRequest: UIButton!
    
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var lblPending: UILabel!
    
    override func awakeFromNib() {
        
        self.backgroundColor = UIColor.clear
        self.profileIconImage?.layer.masksToBounds = false
        self.profileIconImage?.layer.cornerRadius = (self.profileIconImage?.frame.height)!/2
        self.profileIconImage?.clipsToBounds = true
        self.whiteBackgroundView.layer.cornerRadius = 4.0
    }
    
    func initWithData(objChairBarber: BRD_ChairInfo, selectedDate: Date){
        
        self.btnRequest.isHidden = true
        self.btnAccept.isHidden = true
        self.btnDecline.isHidden = true
        self.lblPending.isHidden = true
        
        
        
        self.chairLbl.text = objChairBarber.name
        var startDate: Date? = nil
        var endDate: Date? = nil
        if objChairBarber.booking_start != nil && objChairBarber.booking_start != ""{
            startDate = Date.dateFromString(objChairBarber.booking_start!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)!
        }
        if objChairBarber.booking_end != nil && objChairBarber.booking_end != ""{
            endDate = Date.dateFromString(objChairBarber.booking_end!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
        }
        
        var isDateExist: Bool = false
        if (startDate != nil) && endDate != nil{
            isDateExist = (startDate?.compare(selectedDate).rawValue)! * (selectedDate.compare(endDate!).rawValue) >= 0
        }
        
        
        // Button conditions
        if(objChairBarber.availability! == "booked" && isDateExist == true && objChairBarber.type != "self"){
            // If selected date from calendar lies between booki
            //ng start and booking end date - Then display Barber Info
            //
            if let barberArray = objChairBarber.barberInfo{
                if barberArray.count > 0{
                   if let objBarberDetail: BRD_BarberInfoBO = barberArray[0]{
                        
                        if objBarberDetail.picture != nil && objBarberDetail.picture != ""{
                            let imagePath = KImagePathForServer +  objBarberDetail.picture!
                            self.profileIconImage.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                                
                                DispatchQueue.main.async(execute: {
                                    if image != nil{
                                        self.profileIconImage.image = image
                                    }else{
                                        self.profileIconImage.image = UIImage.init(named: "ICON_PROFILEIMAGE")
                                    }
                                })
                            })
                        }
                        self.chairSplitLbl.text = objBarberDetail.first_name! + " " +  objBarberDetail.last_name!
                    }
                }
                
            }
        }else if(objChairBarber.availability == "booked" && objChairBarber.type == "self"){
            self.chairSplitLbl.text = "Booked by Non-BarbrDo Barber"
        
        }else{
            if objChairBarber.type == "weekly"{
                // Weekly
                self.chairSplitLbl.text = "Chair Rental: $" + String(describing: objChairBarber.amount!) + "/week"
            }else if (objChairBarber.type == "monthly"){
                self.chairSplitLbl.text = "Chair Rental: $" + String(describing: objChairBarber.amount!) + "/month"
            }else{
                // Show Percentage
                
                var ShopPercentage: String = ""
                var barberPercentage: String = ""
                
                if objChairBarber.shop_percentage != nil{
                    ShopPercentage = String(describing: objChairBarber.shop_percentage!)
                }
                if objChairBarber.barber_percentage != nil{
                    barberPercentage = String(describing: objChairBarber.barber_percentage!)
                }
                let chairSplitRatio = "Chair Split : " + barberPercentage + "/" + ShopPercentage
                
                self.chairSplitLbl.text = chairSplitRatio
                
            }
    if(objChairBarber.barberRequest != nil)
    {
            if (objChairBarber.barberRequest?.count)! > 0 {
                var isBarberFound : Bool = false
                for objBarberRequest in objChairBarber.barberRequest! {
                    let bookingDate = Date.dateFromString(objBarberRequest.booking_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                    
                    let isBookingDateSame: Bool = (selectedDate == bookingDate) ? true : false
                    
                    if(BRDSingleton.sharedInstane.objBRD_UserInfoBO?._id ==  objBarberRequest.barber_id && isBookingDateSame == true && objBarberRequest.requested_by == "barber"){
                        //Display 'PENDING'
                        
                        // DISPLAY TEXT AS PENDING
                        self.lblPending.isHidden = false
                        isBarberFound = true
                        break
                    } else if (BRDSingleton.sharedInstane.objBRD_UserInfoBO?._id ==  objBarberRequest.barber_id && isBookingDateSame == true && objBarberRequest.requested_by == "shop"){
                        // DISPLAY button Accept or Decline
                        self.btnAccept.isHidden = false
                        self.btnDecline.isHidden = false
                        isBarberFound = true
                        break
                    }
                }
                if(isBarberFound == false){
                    self.btnRequest.isHidden = false
                }
        }
    }
            else{
                self.btnRequest.isHidden = false
                
            }
        }
    }

    

}
class BRD_Barber_RequestDetailVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var shopNameLbl: UILabel!
    @IBOutlet weak var shopAddressLbl: UILabel!
    @IBOutlet weak var viewMapBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //var arrayTableView = [ChairBarberBO]()
    var arrayTableView = [BRD_ChairInfo]()
    var objBarberShops: BRD_ShopDataBO? = nil
    var calendarSelectedDate: String? = nil
    var shopId : String? = nil
    var selectedDate: Date!
    var manageRequestFlag : Bool? = false
    
    var shop_user_id: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let navigationView = (Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitle.self), owner: self, options: nil)![0] as? NavigationBarWithTitle)!
        navigationView.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        if self.objBarberShops?.name != nil{
            navigationView.lblScreenTitle.text = self.objBarberShops?.name
        }
        navigationView.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(navigationView)
        
        
        self.selectedDate = Date.dateFromString(self.calendarSelectedDate!, Date.DateFormat.yyyy_MM_dd)
        
        self.getChairDetails()
        
        
    }
    
    
    func getChairDetails(){
        
        let headers = BRDSingleton.sharedInstane.getHeaders()
        if headers == nil{return}
        
        SwiftLoader.show(KLoading, animated: true)
        
        //http://172.24.3.154:3000/api/v1/shopdetail/59661cff1661a410ecde21b3
        
        let userID = self.objBarberShops?._id! == nil ? shopId : self.objBarberShops?._id!
        let urlString = KBaseURLString + KShopDetail + userID!
        
        print(urlString)
        
        BRDAPI.getShopDataWithChair("GET", inputParameters: nil, header: headers!, urlString: urlString) { (response, responseObject, status, error) in
            
            
            SwiftLoader.hide()
            
            if responseObject != nil && (responseObject?.count)! > 0{
                if let array = responseObject?[0].chairs{
                    self.shop_user_id = responseObject?[0].shop_user_id
                    self.arrayTableView = array
                    self.tableView.reloadData()
                }
            }else{
                
            }
        }
    }
    
    
    
    func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UITableView DataSource and Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestdetailcell", for: indexPath as IndexPath) as! RequestDetailCell
        cell.btnRequest.addTarget(self, action: #selector(BRD_Barber_RequestDetailVC.requestButtonClicked), for: .touchUpInside)
        let obj = self.arrayTableView[indexPath.row]
        cell.initWithData(objChairBarber: obj, selectedDate: self.selectedDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "RequestChairHeaderCell") as! RequestChairHeaderCell
        
         if self.manageRequestFlag == true
         {
            
        }
        else
         {
        header.initWithData(obj: self.objBarberShops!)
        }
        header.btnShop.addTarget(self, action: #selector(btnViewOnMapAction), for: .touchUpInside)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 259.0
    }
    
    func btnViewOnMapAction(){
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_GoogleMapsVC_StoryboardID) as! BRD_GoogleMapsVC
        self.objBarberShops?.barbers = self.arrayTableView.count
        let array = [self.objBarberShops]
        vc.arrayViewShop = array as! [BRD_ShopDataBO]
        
        vc.hidesBottomBarWhenPushed = true
        vc.shouldHideButton = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - TableViewCell Button Action Method.
    
    func requestButtonClicked(sender:UIButton) {
        print("Request")
//        print("Shop ID", self.objBarberShops?._id)
//         let indexPath = BRDUtility.indexPath(self.tableView, sender)
//        print ("Chair ID", self.arrayTableView[indexPath.row]._id)
//        
//        let barberDetails = BRDSingleton.sharedInstane.objBRD_UserInfoBO
//
//        print("Barber ID", barberDetails?._id)
        //        {
        //            "shop_id": "591be658b902f60fcc14a9d6",
        //            "chair_id": "591bef92ae46f6126981f8c3",
        //            "barber_id": "591be608b902f60fcc14a9d3",
        //            "barber_name": "Barber One",
        //            "booking_date": "2017-07-20"
        //        }
        
        let barberDetails = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        
        let indexPath = BRDUtility.indexPath(self.tableView, sender)
        
        let objChairBarber = self.arrayTableView[indexPath.row]
        let shopID: String
            = (self.objBarberShops?._id)!
        
        let chairID: String = objChairBarber._id!
        let barberID: String = (barberDetails?._id)!
        let barberName: String  = (barberDetails?.first_name)! + " " + (barberDetails?.last_name)!
        let bookingDate = self.calendarSelectedDate!
        
        
        let inputParameters: [String: Any] = ["shop_id": shopID,
                                              "chair_id": chairID,
                                              "barber_id": barberID,
                                              "barber_name": barberName,
                                              "booking_date": bookingDate,
                                              KUserType: UserType.Barber.rawValue]
        
        print(inputParameters)
        
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{
            return
        }

        
        let urlString = KBaseURLString + KRequestChair
        
        SwiftLoader.show(KLoading, animated: true)
        BRDAPI.requestChair("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, chairInfo, status, error) in
            SwiftLoader.hide()
            print(reponse)
            if status == 200{
               /* if responseMessage == "Already requested" {
                    _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: responseMessage, onViewController: self, returnBlock: { (clickedIN) in
                    })
                }else if chairInfo != nil{*/
                    let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "RequestChairDetailVC") as! RequestChairDetailVC
                    
                    vc.objChairBarber = self.arrayTableView[indexPath.row]
                    vc.bookingDate =  self.calendarSelectedDate
                    vc.objBarberShopInfo = self.objBarberShops
                    vc.shop_user_id = self.shop_user_id
                    self.navigationController?.pushViewController(vc, animated: false)
                    
//                }else{
//                    _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error.debugDescription, onViewController: self, returnBlock: { (clickedIN) in
//                    })
//                }
            }/*else
            if chairInfo != nil{
                let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "RequestChairDetailVC") as! RequestChairDetailVC
                
                vc.objChairBarber = self.arrayTableView[indexPath.row]
                vc.bookingDate = self.calendarSelectedDate
                vc.objBarberShopInfo = self.objBarberShops
                self.navigationController?.pushViewController(vc, animated: false)
                
            }*/else if reponse != nil {
                
                if let responseMessage = reponse?["msg"] as? String {
                    _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: responseMessage, onViewController: self, returnBlock: { (clickedIN) in
                    })
                }
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error.debugDescription, onViewController: self, returnBlock: { (clickedIN) in
                })
            }
        }
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
