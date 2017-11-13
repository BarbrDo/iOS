//
//  GetCustomerFeedbackVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 22/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView


class GetCustomerFeedbackCell1 : UITableViewCell{
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var btnAddToCalender: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "GetCustomerFeedbackCell1"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(obj: BRD_AppointmentsInfoBO){
        
        self.lblDate.text = Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.EEEE_MMMM_dd)
        self.lblTime.text = Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.TimeFormat.hh_mm_a)
    }
    
}

class GetCustomerFeedbackCell2: UITableViewCell{
    
    @IBOutlet weak var lblBarberAddress: UILabel!
    
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "GetCustomerFeedbackCell2"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
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


class GetCustomerFeedbackCell3: UITableViewCell{
    
    @IBOutlet weak var barberImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblBarberName: UILabel!
    @IBOutlet weak var lblLastCut: UILabel!
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "GetCustomerFeedbackCell3"
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
    
    func initWithData(obj: BRD_AppointmentsInfoBO) {
        
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
                        }
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidesWhenStopped = true
                    })
                })
            }else{
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            }
            
            self.lblLastCut.text = ""
        }
    }
}


class GetCustomerFeedbackCell4: UITableViewCell{
    
    
    
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    @IBOutlet weak var btnRateBarber: UIButton!
    
    static func identifier() -> String {
        return "GetCustomerFeedbackCell4"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.starRatingView.value = 1.0
      }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //hello indis
}

class GetCustomerFeedbackVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var arrayTableView = [BRD_AppointmentsInfoBO]()

    var objAppointmentInfo:BRD_AppointmentsInfoBO? = nil
    
    var headerRatingCell: GetCustomerFeedbackCell4!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.headerRatingCell == nil{
           self.headerRatingCell = tableView.dequeueReusableCell(withIdentifier: GetCustomerFeedbackCell4.identifier()) as? GetCustomerFeedbackCell4
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func backButtonAction(sender: UIButton){
        
       dismiss(animated: true, completion: nil)
    }

}

extension GetCustomerFeedbackVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0 // self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BarberHairCuts = tableView.dequeueReusableCell(withIdentifier: "BarberHairCuts") as! BarberHairCuts
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 102.0
        case 1:
            return 104.0
        case 2:
            return 106.0
        case 3:
            return 110.0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
 
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch  section {
        case 0:
            let header = tableView.dequeueReusableCell(withIdentifier: GetCustomerFeedbackCell1.identifier()) as? GetCustomerFeedbackCell1
            header?.initWithData(obj: self.objAppointmentInfo!)
            return header
        case 1:
            
            let header = tableView.dequeueReusableCell(withIdentifier: GetCustomerFeedbackCell2.identifier()) as? GetCustomerFeedbackCell2
            header?.initWithData(obj: self.objAppointmentInfo!)
            return header
        case 2:
            
            let header = tableView.dequeueReusableCell(withIdentifier: GetCustomerFeedbackCell3.identifier()) as? GetCustomerFeedbackCell3
            header?.initWithData(obj: self.objAppointmentInfo!)
            return header
        case 3:
            
            self.headerRatingCell = tableView.dequeueReusableCell(withIdentifier: GetCustomerFeedbackCell4.identifier()) as? GetCustomerFeedbackCell4
            self.headerRatingCell.btnRateBarber.addTarget(self, action: #selector(btnRateBarberAction), for: .touchUpInside)
            self.headerRatingCell.starRatingView.addTarget(self, action: #selector(starRatingChangeAction), for: .valueChanged)
            return self.headerRatingCell
        default:
            return nil
        }
    }
    
    func btnRateBarberAction(){
        
        let headers = BRDSingleton.sharedInstane.getHeaders()
        
        if headers == nil{return}
        
        let inputParamerter: [String: Any] =
        ["barber_id": (self.objAppointmentInfo?.barber_id?._id)!,
         "appointment_id": (self.objAppointmentInfo?._id)!,
         "appointment_date": (self.objAppointmentInfo?.appointment_date)!,
         "score": self.headerRatingCell.starRatingView.value,
         "rated_by_name": (BRDSingleton.sharedInstane.objBRD_UserInfoBO?.first_name)! + " " + (BRDSingleton.sharedInstane.objBRD_UserInfoBO?.last_name)!]
        
        print(inputParamerter)
        
        let urlString = KBaseURLString + KRateBarber
        BRDAPI.rateBarber("POST", inputParameter: inputParamerter, header: headers!, urlString: urlString) { (response, responseString, status, error) in
            if responseString == "Updated successfully"{
                
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Updated successfully", onViewController: self, returnBlock: { (clickedIN) in
                    
                    self.dismiss(animated: true, completion: nil)
                })
                
            }else{
                
                if error != nil{
                    _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                        
                    })

                }
            }
        }
        
        
        
    }
    
    func starRatingChangeAction(){
        
        print(self.headerRatingCell.starRatingView.value)
    }
    
    
}
