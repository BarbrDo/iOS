//
//  BRD_ViewProfileVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 25/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
import SwiftLoader

//Mark
class ProfileTableViewCell : UITableViewCell{
    
    
    @IBOutlet weak var lblMemberSince: UILabel!
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    @IBOutlet weak var txtBio: UITextView!
    
    @IBOutlet weak var viewShop: UIView!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblZip: UILabel!
    
    func initWithdata(objProfile: BRD_UserInfoBO?){
        
        if objProfile != nil{
            
            self.lblMemberSince.text = Date.convert((objProfile?.licensed_since!)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMMM_dd)
            
            
            var ratingValue : Float = 0.0
            if let arrayRating = objProfile?.rating{
                
                for objData in arrayRating{
                    if let value: Float = objData.score {
                        ratingValue = ratingValue + value
                    }
                }
                let fMean: Float = Float((arrayRating.count))
                ratingValue = ratingValue/fMean
                self.starRatingView.value = CGFloat(ratingValue)
            }
            
            self.txtBio.text = objProfile?.bio
            
            
            if objProfile?.is_Online == true{
                
                self.viewShop.isHidden = false
                
                if objProfile?.shopInfo != nil{
                    self.lblShopName.text = objProfile?.shopInfo?.name
                    self.lblZip.text = objProfile?.shopInfo?.zip
                    self.lblCity.text = objProfile?.shopInfo?.city
                    self.lblState.text = objProfile?.shopInfo?.state
                    self.lblAddress.text = objProfile?.shopInfo?.address
                }
                
//                self.lblShopName.text = objProfile?.
            }else{
                self.viewShop.isHidden = true
            }
            
            
            //self.lblShopName.text = objProfile?.barberProfile.

        }
    }
}



class BRD_ViewProfileVC: BRD_BaseViewController, UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var viewTopBar: UIView!
    
    //Mark
    
    @IBOutlet weak var profileTableView: UITableView!
    var objBarber: BRD_BarberInfoBO? = nil
    var objCustomer: BRD_CustomerIDBO? = nil
    var objSelectedShopData: BRD_ShopDataBO? = nil
    
    var objProfile: BRD_UserInfoBO? = nil
    var ratingIndex: Float = 0
    var header:BRD_ProfileViewHeader? = nil
    var objUserProfile : BRD_UserProfileBO? = nil
    
    var objBarberInfo: BarberListBO? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.header = Bundle.main.loadNibNamed(String(describing: BRD_ProfileViewHeader.self), owner: self, options: nil)![0] as? BRD_ProfileViewHeader
        self.header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:220)
        self.header?.backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.header?.btnPhoto.addTarget(self, action: #selector(btnViewPhotos), for: .touchUpInside)
        self.header?.btnCuts.addTarget(self, action: #selector(btnCutsAction), for: .touchUpInside)
        if self.objCustomer != nil{
            self.header?.lblProfile.text = "Customer Profile"
        }else{
            self.header?.lblProfile.text = "Barber Profile"
        }
        
        
        self.header?.profileButton.isHidden = true
        self.viewTopBar.addSubview(self.header!)
        
        profileTableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        
        self.objProfile = BRD_UserInfoBO.init()
        
        if self.objCustomer != nil{
            self.getCustomerDetail()
        }else{
             self.getBarberDetail()
        }
        
    }
    
    @IBAction func viewProfileBtnAction(_ sender: UIButton) {
        
        if sender.tag == 101{
            
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_ProfileAndCutsVC_StoryboardID) as! BRD_ProfileAndCutsVC
            vc.objProfile = self.objProfile
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @objc private func btnCutsAction(){
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_ProfileAndCutsVC_StoryboardID) as! BRD_ProfileAndCutsVC
        vc.objProfile = self.objProfile
        vc.showCuts = true
        vc.objSelectedBarber = self.objBarber
        vc.objSelectedShopData = self.objSelectedShopData
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc private func btnViewPhotos(){
     
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_ProfileAndCutsVC_StoryboardID) as! BRD_ProfileAndCutsVC
        vc.objProfile = self.objProfile
        vc.objSelectedBarber = self.objBarber
        vc.objSelectedShopData = self.objSelectedShopData
        if self.objUserProfile != nil{
            vc.objUserProfile = self.objUserProfile!
        }
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @objc private func getBarberDetail(){
        
        let obj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        
        let latitude = BRDSingleton.sharedInstane.latitude
        let longitude = BRDSingleton.sharedInstane.longitude
        
        let header : [String: String] =
            [KLatitude : latitude!,
             KLongitude :longitude!,
             KUserID : (obj?._id)!,
             KBarberID :(self.objBarberInfo?._id)!]
        
        
        BRDSingleton.sharedInstane.displayLoader(viewController: self, message: "Fetching Barber Detail...")
        
        let urlString = KBaseURLString + KGetUserProfileURL + (self.objBarberInfo?._id)!
        
        print(urlString)
        
        BRDAPI.getBarberDetail(nil, header: header, url: urlString) { (response, objBarber, status, error) in
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
            
            if objBarber != nil{
                BRDSingleton.sharedInstane.objBarberInfo = objBarber
                self.objProfile = objBarber
                self.profileTableView.reloadData()
                
                self.header?.initWithData(obj: self.objProfile!)
                
//                if self.objProfile?.picture != nil || self.objProfile?.picture == ""{
//                    let imagePath = KImagePathForServer + (self.objProfile?.picture)!
//                    self.header?.userImageView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
//                        
//                        DispatchQueue.main.async(execute: {
//                            if image != nil{
//                                self.header?.userImageView.image = image
//                                
//                            }else{
//                                self.header?.userImageView.image = UIImage.init(named: "ICON_PROFILEIMAGE")
//                            }
//                            self.header?.activityIndicator.stopAnimating()
//                            self.header?.activityIndicator.hidesWhenStopped = true
//                        })
//                    })
//                }else{
//                    self.header?.activityIndicator.stopAnimating()
//                    self.header?.activityIndicator.hidesWhenStopped = true
//                }
            }
        }
    }
    
    
    
    
    func getCustomerDetail(){
        
        let obj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        
        let latitude = BRDSingleton.sharedInstane.latitude
        let longitude = BRDSingleton.sharedInstane.longitude
        
        let header : [String: String] =
            [KLatitude : latitude!,
             KLongitude :longitude!,
             KUserID : (obj?._id)!,
             "id" :(self.objCustomer?._id)!]

        
        let userID = self.objCustomer?._id
        let urlString = KBaseURLString + KUserProfile + userID!
        
        SwiftLoader.show(KLoading, animated: true)
        
        BRDAPI.getUserProfile("GET", inputParameter: nil, header: header, urlString: urlString) { (response, userInfo, status, error) in
            
            
            SwiftLoader.hide()
            if userInfo != nil{
                self.objUserProfile = userInfo!
                self.updateCustomerDetails(obj: self.objUserProfile!)
               // self.tableViewProfile.reloadData()
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: error.debugDescription, onViewController: self, returnBlock: { (clickedIN) in
                })
            }
        }
        
    }
    
    
    func updateCustomerDetails(obj: BRD_UserProfileBO){
        
        self.header?.initWithData(obj: nil, objUserProfile: obj)
        
        let email = obj.email
        let phone = obj.mobile_number
        let memberSince = Date.convert(obj.created_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMMM_dd)
        self.profileTableView.reloadData()
    }
    
    
    func updateProfile(obj: BRD_UserInfoBO){
        
        
        self.header?.initWithData(obj: obj)
        
        let email = obj.email
        let phone = obj.mobile_number?.toPhoneNumber()
        let memberSince = Date.convert(obj.created_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMMM_dd)
        let licenseNumber = obj.barberProfile?.license_number ?? "No License Number"
       
        
        // Calculate Rating
        if let arrayRating = obj.rating{
            var totalRating: Float = 0
            for data in arrayRating{
                totalRating =  totalRating + data.score!
            }
            self.ratingIndex = totalRating/Float(arrayRating.count)
        }
        
        self.profileTableView.reloadData()
    }
    
    
    func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : TableViewDelegate/DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //mark
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProfileTableViewCell
        
        if self.objProfile != nil{
            cell?.initWithdata(objProfile: self.objProfile)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 480.0
    }
    
}
