//
//  RequestBarberVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 31/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BarberInfoCell: UITableViewCell{
    
    @IBOutlet weak var barberImageView: UIImageView!
    @IBOutlet weak var starImageView: UIImageView!
    
    @IBOutlet weak var barberName: UILabel!
    @IBOutlet weak var barberShopName: UILabel!
    @IBOutlet weak var barberRating: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnViewBarber: UIButton!
    
    
    override func awakeFromNib() {
        self.barberImageView.layer.borderWidth = 1.0
        self.barberImageView.layer.masksToBounds = false
        self.barberImageView.layer.borderColor = UIColor.white.cgColor
        self.barberImageView.layer.cornerRadius = self.barberImageView.frame.size.width/2
        self.barberImageView.clipsToBounds = true
    }
    
    
    func initWithData(obj: BarberListBO){
        
        // Barber Image
       
         if obj.picture != nil{
             let imagePath = KImagePathForServer + obj.picture!
             self.activityIndicator.startAnimating()
             self.barberImageView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
             
             DispatchQueue.main.async(execute: {
             if image != nil{
             self.barberImageView.image = image
             }else{
             self.barberImageView.image = UIImage(named: "ICON_PROFILEIMAGE")
             }
             self.activityIndicator.stopAnimating()
             self.activityIndicator.hidesWhenStopped = true
             })
             })
         }else{
             self.barberImageView.image = UIImage(named: "ICON_PROFILEIMAGE")
             self.activityIndicator.hidesWhenStopped = true
         }
       
        
        
        self.barberName.text = obj.first_name!.capitalized + " " + String(obj.last_name!.characters.prefix(1)).capitalized
        
        
        
        var shopName = obj.barber_shops?.name
        // shopName = shopName! + "(" + (obj.barber_shops?.dist)! + "mi" + ")"
        
       // self.barberShopName.text = shopName
        
        
        var address = ""
        if let shopName = obj.barber_shops?.name{
            address = shopName + " \n"
        }
        if let shopDetails = obj.barber_shops?.address {
            address = address + shopDetails + ", \n"
        }
        if let city = obj.barber_shops?.city {
            address = address + city + ", "
        }
        if let state = obj.barber_shops?.state {
            address = address + state + " "
        }
        if let zipCode = obj.barber_shops?.zip {
            address = address + zipCode
        }
        self.barberShopName.text = address
        BRDSingleton.sharedInstane.fullShopAddress = address.replacingOccurrences(of: (obj.barber_shops?.name)!, with: "", options: .literal, range: nil)
        
        // Add Condition for Star hidden or not
        if obj.is_favourite == true{
            self.starImageView.isHidden = false
        }else{
            self.starImageView.isHidden = true
        }
        
        
        var ratingValue: String = "0"
        
        if obj.ratings?.count == 0{
            ratingValue = "0.0"
        }else{
            var countVal: Float = 0.0
            for temp in obj.ratings!{
                let ratObj = temp as BRD_RatingsBO
                countVal = countVal + ratObj.score!
            }
            let meanVal: Float = countVal / Float((obj.ratings?.count)!)
            ratingValue =  String(format: "%.01f", meanVal)
        }
        self.barberRating.text = ratingValue
        
       
    }
    
    
}

class BarberServicesHeaderCell: UITableViewCell{
    
}

class BarberServicesDetailCell: UITableViewCell{
    
    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblServicePrice: UILabel!
    
    
    func initWithData(obj: BRD_ServicesBO){
        
        self.lblServiceName.text = obj.name
        self.lblServicePrice.text = "$" + String(format: "%.02f", obj.price!)
 
    }
    
}

class BarberServicesTotalCell: UITableViewCell{
    
    @IBOutlet weak var lblTotal: UILabel!
    
    func initWithData(array: [BRD_ServicesBO]){
        
        var totalCount: Double = 0.0
        
        for obj in array{
            totalCount = totalCount + obj.price
        }
        self.lblTotal.text = "Total:   $" + String(format: "%.02f", totalCount)
    }
    
}

class BarberServicesTimeCell: UITableViewCell{
    
    
    @IBOutlet weak var btn10Mins: UIButton!
    @IBOutlet weak var btn20Mins: UIButton!
    @IBOutlet weak var btn30Mins: UIButton!
    @IBOutlet weak var btn40Mins: UIButton!
    @IBOutlet weak var btnSubmitRequest: UIButton!
    
    
    override func awakeFromNib() {
        
    }
    
    func initWithData(tag: Int, arrayServices: [BRD_ServicesBO]){
        
        if tag != 0 && arrayServices.count > 0{
            self.btnSubmitRequest.backgroundColor = kPageMenuColor
            self.btnSubmitRequest.setTitleColor(UIColor.white, for: .normal)
            
        }else{
            self.btnSubmitRequest.backgroundColor = KLightGreyShade
            self.btnSubmitRequest.setTitleColor(UIColor.white, for: .normal)
        }
        
        switch tag {
        case 201:
            
            self.btn10Mins.backgroundColor = kPageMenuColor
            self.btn10Mins.setTitleColor(UIColor.white, for: .normal)
            break
        case 202:
            self.btn20Mins.backgroundColor = kPageMenuColor
            self.btn20Mins.setTitleColor(UIColor.white, for: .normal)
            break
        case 203:
            self.btn30Mins.backgroundColor = kPageMenuColor
            self.btn30Mins.setTitleColor(UIColor.white, for: .normal)
            break
        case 204:
            self.btn40Mins.setTitleColor(UIColor.white, for: .normal)
            self.btn40Mins.backgroundColor = kPageMenuColor
            break
        default:
            break
        }
    }
}


class RequestBarberVC: BRD_BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var objBarberDetail: BarberListBO? = nil
    var arrayTableView = [BRD_ServicesBO]()
    var arraySelectedServices = [BRD_ServicesBO]()
    
    var headerTimeCell :BarberServicesTimeCell!
    
    
    //Instance Variable
    
    var strCustomerTime: String? = nil
    var selectedButtonTag: Int = 0
   

    override func viewDidLoad() {
        super.viewDidLoad()

        let header = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitle.self), owner: self, options: nil)![0] as? NavigationBarWithTitle
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        header?.lblScreenTitle.text = "Request Barber"
        header?.btnBack.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        self.view.addSubview(header!)
        
        if self.objBarberDetail != nil{
            
            print((self.objBarberDetail?.barber_shops?.latLong)!)
            
            
            BRDSingleton.sharedInstane.barberShopLatLong = (self.objBarberDetail?.barber_shops?.latLong)!
            
            self.arrayTableView = (self.objBarberDetail?.barber_services)!
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func btnBackAction(){
        self.navigationController?.popViewController(animated: true)
    }


}

extension RequestBarberVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 0
        case 1:
            return self.arrayTableView.count
        case 2:
            return 0
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //mark
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarberServicesDetailCell", for: indexPath) as? BarberServicesDetailCell
        let obj = self.arrayTableView[indexPath.row]
        cell?.initWithData(obj: obj)
        cell?.lblServiceName.textColor = KBlackFontShade
        cell?.lblServicePrice.textColor = KBlackFontShade
        cell?.viewBackground.backgroundColor = KBlueColor_1
        for (index, element) in self.arraySelectedServices.enumerated() {
            print("Item \(index): \(element)")
            if element == obj{
                cell?.viewBackground.backgroundColor = kPageMenuColor
                //KLightBlueColor
                cell?.lblServiceName.textColor = UIColor.white
                cell?.lblServicePrice.textColor = UIColor.white
            }
        }
        return cell!
    }
    
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
       // self.tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .none)

       // self.updateTotalAmount()
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            let header = tableView.dequeueReusableCell(withIdentifier: "BarberInfoCell") as? BarberInfoCell
            header?.initWithData(obj: self.objBarberDetail!)
            header?.btnViewBarber.addTarget(self, action: #selector(btnViewBarberAction(_:)), for: .touchUpInside)
            return header!
        case 1:
            let header = tableView.dequeueReusableCell(withIdentifier: "BarberServicesHeaderCell") as? BarberServicesHeaderCell
            let view = UIView.init(frame: CGRect.init(x: 5, y: 29, width: self.view.frame.width-10, height: 1))
            view.backgroundColor = UIColor.white
            header?.addSubview(view)
            return header!
        case 2:
            self.headerTimeCell = tableView.dequeueReusableCell(withIdentifier: "BarberServicesTimeCell") as? BarberServicesTimeCell
            
            self.headerTimeCell.initWithData(tag: self.selectedButtonTag, arrayServices: self.arraySelectedServices)
            
            self.headerTimeCell.btn10Mins.addTarget(self, action: #selector(btnSelectTimeAction(sender:)), for: .touchUpInside)
            self.headerTimeCell.btn20Mins.addTarget(self, action: #selector(btnSelectTimeAction(sender:)), for: .touchUpInside)
            self.headerTimeCell.btn30Mins.addTarget(self, action: #selector(btnSelectTimeAction(sender:)), for: .touchUpInside)
            self.headerTimeCell.btn40Mins.addTarget(self, action: #selector(btnSelectTimeAction(sender:)), for: .touchUpInside)
            self.headerTimeCell.btnSubmitRequest.addTarget(self, action: #selector(submitRequestAction), for: .touchUpInside)
            return self.headerTimeCell!
        default:
            return nil
        }
    }
    
    @IBAction func btnViewBarberAction(_ sender: UIButton){
        
        //let indexPath = BRDUtility.indexPath(self.tableView, sender)
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "BRD_ViewProfileVC") as? BRD_ViewProfileVC {
            
            vc.objBarberInfo = self.objBarberDetail
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            return nil
        case 1:
            let footer = tableView.dequeueReusableCell(withIdentifier: "BarberServicesTotalCell") as? BarberServicesTotalCell
            footer?.initWithData(array: self.arraySelectedServices)
            return footer!
        
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 33.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 100.0
        case 1:
            return 30.0
        case 2:
            return 250.0
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 0
        case 1:
            return 30.0
        default:
            return 0
        }
    }
    
    
    // Request Barber
    
    @IBAction func btnRequestBarberAction(_ sender: UIButton) {
        
        //        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        //        if let vc = storyboard.instantiateViewController(withIdentifier: BRDBookAppointmentVC.identifier()) as? BRDBookAppointmentVC {
        //            vc.barberDetails = self.objBarber
        //            vc.shopDetail = self.objSelectedShopData
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
    func submitRequestAction(){
        
        
        var shopName = self.objBarberDetail?.barber_shops?.name
        shopName = shopName! + " (" + String(format: "%.0f", (self.objBarberDetail?.distance!)!) + " mi" + ")"
        
        BRDSingleton.sharedInstane.shopNameAndDistance = shopName
        
        if self.checkValidation() == true{
            var arrayTempServices = [Any]()
            var totalPrice: Double = 0
            for obj in self.arraySelectedServices{
                let dictionary : [String : Any] = ["price": obj.price!,
                                                   "name": obj.name!,
                                                   "service_id": obj.service_id!]
                totalPrice += obj.price!
                arrayTempServices.append(dictionary)
            }
            
//            print(NSDate())
//            let calendar = Calendar.current
//            let date = calendar.date(byAdding: .minute, value: Int(self.strCustomerTime!)!, to: Date())
            
            let appointmentDate = Date.stringFromDate(Date(), Date.DateFormat.yyyy_MM_dd_HH_mm)
            
            BRDSingleton.sharedInstane.shopName = objBarberDetail?.barber_shops?.name
            
            let inputDictionary: [String: Any] =
                ["shop_id": objBarberDetail?.barber_shops?._id!,
                 "barber_id": objBarberDetail?._id!,
                 "services": arrayTempServices,
                 "appointment_date": appointmentDate,
                 "totalPrice": totalPrice,
                 "reach_in":self.strCustomerTime]
        
            let urlString = KBaseURLString + KCustomerNewRequest
            
            let header = BRDSingleton.sharedInstane.getHeaders()
            if header == nil{return}
            
            BRDAPI.customerNewRequest("POST", inputParameter: inputDictionary, header: header!, urlString: urlString, completionHandler: { (appointment, responseString, status, error) in
                
                if status == 200{
                    let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ContactingBarberScreenVC") as! ContactingBarberScreenVC
                    vc.objAppointment = appointment
                    vc.objBarberInfo = self.objBarberDetail
                    vc.strTime = self.strCustomerTime
                    self.navigationController?.pushViewController(vc, animated: false)

                }else{
                    // Show Error
                    _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    })
                }
            })
        }
    }
    
    
    func btnSelectTimeAction(sender: UIButton){
        
        self.headerTimeCell.btn10Mins.setTitleColor(UIColor.black, for: .normal)
        self.headerTimeCell.btn20Mins.setTitleColor(UIColor.black, for: .normal)
        self.headerTimeCell.btn30Mins.setTitleColor(UIColor.black, for: .normal)
        self.headerTimeCell.btn40Mins.setTitleColor(UIColor.black, for: .normal)
        
        switch sender.tag {
        case 201:
            self.selectedButtonTag = 201
            self.strCustomerTime = "10"
            self.headerTimeCell.btn10Mins.backgroundColor = kPageMenuColor
            self.headerTimeCell.btn10Mins.setTitleColor(UIColor.white, for: .normal)
            self.headerTimeCell.btn20Mins.backgroundColor = KBlueColor_1
            self.headerTimeCell.btn30Mins.backgroundColor = KBlueColor_1
            self.headerTimeCell.btn40Mins.backgroundColor = KBlueColor_1
            break
        case 202:
            self.selectedButtonTag = 202
            self.strCustomerTime = "20"
            self.headerTimeCell.btn10Mins.backgroundColor = KBlueColor_1
            self.headerTimeCell.btn20Mins.backgroundColor = kPageMenuColor
            self.headerTimeCell.btn20Mins.setTitleColor(UIColor.white, for: .normal)
            self.headerTimeCell.btn30Mins.backgroundColor = KBlueColor_1
            self.headerTimeCell.btn40Mins.backgroundColor = KBlueColor_1
            break
        case 203:
            self.selectedButtonTag = 203
            self.strCustomerTime = "30"
           self.headerTimeCell.btn10Mins.backgroundColor = KBlueColor_1
            self.headerTimeCell.btn20Mins.backgroundColor = KBlueColor_1
            self.headerTimeCell.btn30Mins.backgroundColor = kPageMenuColor
            self.headerTimeCell.btn30Mins.setTitleColor(UIColor.white, for: .normal)
            self.headerTimeCell.btn40Mins.backgroundColor = KBlueColor_1
            break
        case 204:
            self.selectedButtonTag = 204
            self.strCustomerTime = "45"
            self.headerTimeCell.btn10Mins.backgroundColor = KBlueColor_1
            self.headerTimeCell.btn20Mins.backgroundColor = KBlueColor_1
            self.headerTimeCell.btn30Mins.backgroundColor = KBlueColor_1
            self.headerTimeCell.btn40Mins.setTitleColor(UIColor.white, for: .normal)
            self.headerTimeCell.btn40Mins.backgroundColor = kPageMenuColor
            break
        default:
            break
        }
        
        if self.selectedButtonTag != 0 && self.arraySelectedServices.count > 0{
            
            self.headerTimeCell.btnSubmitRequest.backgroundColor = kPageMenuColor
            self.headerTimeCell.btnSubmitRequest.setTitleColor(UIColor.white, for: .normal)
            
        }else{
            self.headerTimeCell.btnSubmitRequest.backgroundColor = KLightGreyShade
            self.headerTimeCell.btnSubmitRequest.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    private func checkValidation() -> Bool{
        
        if self.arraySelectedServices.count == 0{
            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Please select services", onViewController: self, returnBlock: { (clickedIN) in
                
            })
            return false
        }
        
        if self.strCustomerTime == nil{
            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Please select time", onViewController: self, returnBlock: { (clickedIN) in
                
            })
            return false
        }
        return true
    }
    
}
