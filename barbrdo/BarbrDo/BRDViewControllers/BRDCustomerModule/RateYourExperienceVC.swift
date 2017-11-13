//
//  RateYourExperienceVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 07/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
import SwiftLoader

class RateYourExperienceCell: UITableViewCell{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageViewBarber: UIImageView!
    @IBOutlet weak var imageViewFavorite: UIImageView!
    @IBOutlet weak var lblBarberName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblBookingTime: UILabel!
    
    
    @IBOutlet weak var btnYES: UIButton!
    @IBOutlet weak var btnNO: UIButton!
    
    @IBOutlet weak var swiftRating: SwiftyStarRatingView!
    @IBOutlet weak var btnAddToFavorite: UIButton!    
    @IBOutlet weak var btnSumitRating: UIButton!
    
    
    override func awakeFromNib() {
        
        self.imageViewBarber.layer.borderWidth = 1.0
        self.imageViewBarber.layer.masksToBounds = false
        self.imageViewBarber.layer.borderColor = UIColor.white.cgColor
        self.imageViewBarber.layer.cornerRadius = self.imageViewBarber.frame.size.width/2
        self.imageViewBarber.clipsToBounds = true
        
    }
    
    func initWithData(objAppointment: AppointmentCompletedBO?){
        
        
        if objAppointment != nil{
            
            if let objBarber = objAppointment?.barber_id{
                let fullName = objBarber.first_name!.capitalized + " " + String(objBarber.last_name!.characters.prefix(1)).capitalized
                
                self.lblBarberName.text = fullName
                
                
                var ratingValue: String = "0"
                
                if objBarber.ratings.count == 0{
                    ratingValue = "0.0"
                }else{
                    var countVal: Float = 0.0
                    for temp in objBarber.ratings{
                        let ratObj = temp as BRD_RatingsBO
                        countVal = countVal + ratObj.score!
                    }
                    let meanVal: Float = countVal / Float((objBarber.ratings.count))
                    ratingValue =  String(format: "%.01f", meanVal)
                }
                print(ratingValue)
                self.lblRating.text = ratingValue
                
                
                
                if objBarber.picture != nil{
                    let imagePath = KImagePathForServer + objBarber.picture!
                    self.activityIndicator.startAnimating()
                    self.imageViewBarber.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                        
                        DispatchQueue.main.async(execute: {
                            if image != nil{
                                self.imageViewBarber.image = image
                            }else{
                                self.imageViewBarber.image = UIImage(named: "ICON_PROFILEIMAGE")
                            }
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.hidesWhenStopped = true
                        })
                    })
                }else{
                    self.activityIndicator.hidesWhenStopped = true
                    self.imageViewBarber.image = UIImage(named: "ICON_PROFILEIMAGE")
                }
                
            }
            
            if let objShopDetail = objAppointment?.shop_id{
                self.lblShopName.text = objShopDetail.name
            }
            
            var services: String = ""
            
            for temp in (objAppointment?.services)!{
                services += temp.name! + ": $" + String(format: "%.02f", temp.price!)
                services += ", "
                
            }
            
            let endIndex = services.index(services.endIndex, offsetBy: -2)
            let truncated = services.substring(to: endIndex)
            self.lblBookingTime.text = truncated
        }
        
    }
    
}


class RateYourExperienceVC: BRD_BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    //IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    var arrayCompleted = [AppointmentCompletedBO]()
    var arrayConfirm = [Any]()
    var rateYourExperience: RateYourExperienceCell!
    var objAppointment : AppointmentCompletedBO?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.addTopNavigationBar(title: "Rate Your Experience")
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: KStopCustomerTimer), object: nil)
        getAppointmentDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAppointmentDetails(){
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
            
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        
        SwiftLoader.show("Fetching data...", animated: true)
        let urlString: String = KBaseURLString + KCustomerAppointmentDetails
        print(urlString)
        BRDAPI.getAppointmentDetail("GET", inputParameters: nil, header: header, urlString: urlString) { (arrayCompleted,arrayConfirm, error) in
            
            
            SwiftLoader.hide()
            if arrayCompleted != nil{
                
                if arrayCompleted?.count == 0{
                    
                    // Post a notification
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: KNotificationReloadMaps), object: nil)

                    self.navigationController?.popToRootViewController(animated: true)
                }
                if (arrayCompleted?.count)! > 0{
                    
                    self.arrayCompleted.removeAll()
                    
                    self.arrayCompleted = arrayCompleted!
                    self.objAppointment = self.arrayCompleted[0]
                    self.tableView.reloadData()

                }
            }
        }
        
    }
    
    
    //MARK: UITABLEVIEW DELEGATE, UITABLEVIEW DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //mark
        rateYourExperience = tableView.dequeueReusableCell(withIdentifier: "RateYourExperienceCell", for: indexPath) as? RateYourExperienceCell
        //cell?.initWithData(objAppointment: self.arrayCompleted[0])
        if self.objAppointment != nil{
            rateYourExperience?.initWithData(objAppointment: self.objAppointment)
        }
        rateYourExperience.btnYES.addTarget(self, action: #selector(rateYourButtonAction(_:)), for: .touchUpInside)
        rateYourExperience.btnNO.addTarget(self, action: #selector(rateYourButtonAction(_:)), for: .touchUpInside)
        rateYourExperience.btnAddToFavorite.addTarget(self, action: #selector(rateYourButtonAction(_:)), for: .touchUpInside)
        rateYourExperience?.btnSumitRating.addTarget(self, action: #selector
            (btnSumitRatingAction(_:)), for: .touchUpInside)
        
        return rateYourExperience!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 457.0
    }
    
    func rateYourButtonAction(_ sender: UIButton){
        
        switch sender.tag {
        case 201:
            // Yes
            rateYourExperience.btnYES.isSelected = true
            rateYourExperience.btnNO.isSelected = false
            rateYourExperience.btnSumitRating.backgroundColor = kNavigationBarColor
            break
        case 202:
            //NO
            rateYourExperience.btnYES.isSelected = false
            rateYourExperience.btnNO.isSelected = true
            rateYourExperience.btnSumitRating.backgroundColor = kNavigationBarColor
            break
        case 203:
            rateYourExperience.btnAddToFavorite.isSelected = !rateYourExperience.btnAddToFavorite.isSelected
        default:
            break
        }
    }
    
    // Request Barber
    @IBAction func btnSumitRatingAction(_ sender: UIButton) {
        
        
        if rateYourExperience.btnYES.isSelected == false && rateYourExperience.btnNO.isSelected == false{
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Please select option were you next in the chair", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        
        var isNextToChair: Bool = false
        if rateYourExperience.btnYES.isSelected == true{
            isNextToChair = true
        }
        
        
        let rating = rateYourExperience.swiftRating.value
        let objAppointment = arrayCompleted[0]
        
        var addtoFavorite: Bool = false
        if rateYourExperience.btnAddToFavorite.isSelected == true{
        
            addtoFavorite = true
        }
        
        let objUser = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        
        let headers = BRDSingleton.sharedInstane.getHeaders()
        if headers == nil{return}
        
        SwiftLoader.show(KLoading, animated: true)
        
        let inputParamerter: [String: Any] =
            ["user_id": (objUser?._id)!,
             "appointment_id": (objAppointment._id)!,
             "barber_id": (objAppointment.barber_id?._id)!,
             "score": rating,
             "appointment_date": objAppointment.appointment_date!,
             "next_in_chair": isNextToChair,
             "is_favourite": addtoFavorite]
        
        print(inputParamerter)
        
        let urlString = KBaseURLString + KRateBarber
        BRDAPI.rateBarber("POST", inputParameter: inputParamerter, header: headers!, urlString: urlString) { (response, responseString, status, error) in
            
            SwiftLoader.hide()
            
            if status == 200{
                self.getAppointmentDetails()
            }else{
                
                if let errorMessage = response?["msg"] as? String{
                    _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: errorMessage, onViewController: self, returnBlock: { (clickedIN) in
                        
                    })

                }else{
                    _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                        
                    })
                }
            }
        }
    }
    
    
 
}
