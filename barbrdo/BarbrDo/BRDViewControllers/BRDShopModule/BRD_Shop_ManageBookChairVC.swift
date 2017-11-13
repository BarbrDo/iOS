//
//  BRD_Shop_ManageBookChairVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 6/1/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader
let KBRD_Shop_ManageBooked_StoryboardID = "BRD_Shop_ManageBookedVCStoryboardID"
class BRD_Shop_ManageBookChairVC: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var removeChairBtn: UIButton!
    @IBOutlet weak var searchBarberBtn: UIButton!
    @IBOutlet weak var postChairBtn: UIButton!
    @IBOutlet weak var makeChairBookBtn: UIButton!
    @IBOutlet weak var rentView: UIView!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var percentLbl: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var availableView: UIView!
    @IBOutlet weak var whiteBackgroundView : UIView!
    @IBOutlet weak var chairImage: UIImageView!
    @IBOutlet weak var chairLbl: UILabel!
    @IBOutlet weak var barberNameLbl: UILabel!
    @IBOutlet weak var chairSplitLbl: UILabel!
    @IBOutlet weak var requestBtn: UIButton!
    var chairInfoObj : BRD_ChairInfo?
    var shopType : String?
    var barberInfo : BRD_BarberInfoBO = BRD_BarberInfoBO()
    @IBOutlet weak var percentView: UIView!
    @IBOutlet weak var percentageBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var availableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var weeklyRadioBtn: UIButton!
    @IBOutlet weak var monthRadioBtn: UIButton!
    @IBOutlet weak var rentBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let obj = chairInfoObj
        {
            titleLbl.text = obj.name
            if(obj.availability?.lowercased() == booked )
            {
                buttonsView.isHidden = true
                whiteBackgroundView.isHidden = false
                self.whiteBackgroundView.layer.cornerRadius = 4.0
                self.availableView.isHidden = true
                chairLbl.text = obj.name
                
                if let barberName = obj.barber_name
                {
                    barberNameLbl.text = barberName
                }
                    
                else
                {
                    barberNameLbl.isHidden = true
                }
                if let barberPercentage = obj.barber_percentage
                {
                    
                    
                    chairSplitLbl.text = "Chair Split : \(String(describing: obj.shop_percentage!))/\(String(describing: barberPercentage))"
                }
                    
                else    if(obj.type == monthly)
                {
                if let amount = obj.amount
                {
                    let convertAmount = String(format: "%g", amount)
                    chairSplitLbl.text = "Chair Rental : $\(convertAmount)/month"
                }
                }
                else    if(obj.type == weekly)
                {
                if let amount = obj.amount
                {
                    let convertAmount = String(format: "%g", amount)
                    chairSplitLbl.text = "Chair Rental : $\(convertAmount)/week"
                }
                }
                    
                else
                {
                    chairSplitLbl.isHidden = true
                }
                
                
            }
                
            else if(obj.availability?.lowercased() == available || obj.availability?.lowercased() == closed)
            {
                
                if(obj.type?.lowercased() == percentage)
                {
                    self.rentView.isHidden = true
                    self.percentView.isHidden = false
                    self.percentageBtn.isSelected = true
                    self.rentBtn.isSelected = false
                }
                
                else if(obj.type?.lowercased() == monthly || obj.type?.lowercased() == weekly )
                {
                    self.rentView.isHidden = false
                    self.percentView.isHidden = true
                    self.percentageBtn.isSelected = false
                    self.rentBtn.isSelected = true
                }
                
                else
                {
                    self.rentView.isHidden = true
                    self.percentView.isHidden = false
                    self.percentageBtn.isSelected = true
                    self.rentBtn.isSelected = false

                }
                self.availableView.layer.cornerRadius = 4.0
                
                
//                rentView.isHidden = true
                whiteBackgroundView.isHidden = true
                availableView.isHidden = false
                weeklyRadioBtn.isSelected = true
                shopType = weekly
                
                if let price = obj.amount
                {
                    priceTF.text = String(format : "%g", price)
                }
                
                if let weekly = obj.type
                {
                    if (weekly == weekly)
                    {
                        weeklyRadioBtn.isSelected = true
                        monthRadioBtn.isSelected = false
                    }
                    
                    
                }
                
                if let  month = obj.type
                {
                    if (month == monthly)
                    {
                        weeklyRadioBtn.isSelected = false
                        monthRadioBtn.isSelected = true
                    }
                }
                
                
                //                makeChairBookBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, -40, 20)
                makeChairBookBtn.set(image: UIImage(named : "mark_chair"), title: "Mark chair as booked", titlePosition: .bottom, additionalSpacing: 0, state: .normal)
                postChairBtn.set(image: UIImage(named : "post_chair"), title: "Post chair as all barber", titlePosition: .bottom, additionalSpacing: 0, state: .normal)
                searchBarberBtn.set(image: UIImage(named : "search"), title: "Search for Specific Barber", titlePosition: .bottom, additionalSpacing: 0, state: .normal)
                removeChairBtn.set(image: UIImage(named : "removechair"), title: "Remove Chair", titlePosition: .bottom, additionalSpacing: 0, state: .normal)
                DispatchQueue.main.async {
                    self.scrollView.contentSize = CGSize(width : self.view.frame.width,height : self.view.frame.height)
                    
                }
                
                if let sliderValue = obj.shop_percentage
                {
                    slider.value = Float(sliderValue)
                    percentLbl.text = String(format: "%.0f%@",slider.value,"%")
                    
                }
            }
            
            
            
        }
    }
    @IBAction func monthlyRadioBtnAction(_ sender: UIButton) {

       
            shopType = monthly
            weeklyRadioBtn.isSelected = false
            monthRadioBtn.isSelected = true
        
        
    }
    @IBAction func weeklyRadioBtnAction(_ sender: UIButton) {

        
            shopType = weekly
            weeklyRadioBtn.isSelected = true
            monthRadioBtn.isSelected = false
         }
    
    @IBAction func percentageBtnAction(_ sender: UIButton) {
        percentageBtn.isSelected = true
        rentBtn.isSelected = false
        self.rentView.isHidden = true
        self.percentView.isHidden = false
        
        
    }
    @IBAction func rentBtnAction(_ sender: UIButton) {
        rentBtn.isSelected = true
        percentageBtn.isSelected = false
        self.rentView.isHidden = false
        self.percentView.isHidden = true
        
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
        if(rentBtn.isSelected)
        {
            if(priceTF.text!.isEmpty)
            {
                _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: "Please fill the amount", onViewController: self, returnBlock: { (clickedIN) in
                    
                })
            }
            else
            {
                weeklyMonthlyChair()
            }
        }
        else
        {
            percentageSplit ()
        }
    }
    
    
    func percentageSplit ()
    {
        SwiftLoader.show(KUpdating, animated: true)
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{
            return
        }
        
        if let obj = chairInfoObj
        {
            
            let shopInfoObj = BRDSingleton.sharedInstane.objShopInfo
            
            var   barberPercent : Any?
            barberPercent = String(format : "%.0f",100.0 - slider.value)
            
            var shopPerecent : Any?
            shopPerecent = String(format : "%.0f", slider.value)
            
            if let shopInfo = shopInfoObj
            {
                
                let inputParameters = ["chair_id": obj._id!,
                                       "type": "percentage",
                                       "barber_percentage": barberPercent! , "shop_percentage" :shopPerecent! , "shop_id" : shopInfo._id!] as [String: Any]
                print(inputParameters)
                let urlString = KBaseURLString + KManageChair
                
                print(urlString)
                BRDAPI.updateService("PUT", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                    SwiftLoader.hide()
                    
                    if let serverMessage = responseMessage {
                        if serverMessage == "Updated successfully"{
                            
                            // SUCCESS CASE
                            _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: "Successfully updated", onViewController: self, returnBlock: { (clickedIN) in
                                
                            })
                        }
                    }
                    else{
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                    }
                    
                    
                    if error != nil{
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                            
                        })
                        return
                    }
                }
            }
            
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 6 // Bool
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // User finished typing (hit return): hide the keyboard.
        
        self.priceTF.text = String(format : "%.2f",self.priceTF.text!)
        
        textField.resignFirstResponder()
        return true
    }
    func postChairToallBarbers()
    {
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{
            return
        }
        
        if let obj = chairInfoObj
        {
            
            if(obj.availability?.lowercased() == "available")
            {
                _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: "Chair Already posted", onViewController: self, returnBlock: { (clickedIN) in
                    
                    let value: Int = clickedIN
                    if value == 0{
                        _ = self.navigationController?.popViewController(animated: true)
                        
                    }
                    
                })

                
                return
            }
            SwiftLoader.show(KUpdating, animated: true)

            let inputParameters = ["chair_id": obj._id!]
                as [String: Any]
            print(inputParameters)
            let urlString = KBaseURLString + KPostchairtoallbarbers
            
            print(urlString)
            BRDAPI.updateService("PUT", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                SwiftLoader.hide()
                
                if let serverMessage = responseMessage {
                    
                    if(serverMessage == "Please select the type of chair.")
                    {
                        _ = BRDAlertManager.showOKAlert(withTitle: serverMessage, withMessage: nil, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                        
                        return
                    }
                    
                    _ = self.navigationController?.popViewController(animated: true)

                    
                        // SUCCESS CASE
                        _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: serverMessage, onViewController: self, returnBlock: { (clickedIN) in
                            
                            let value: Int = clickedIN
                            if value == 0{
                                
                            }
                            
                        })
                    
                }
                else{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: "Please add chair information in order to post chair to barbers.", onViewController: self, returnBlock: { (clickedIN) in
                        
                    })
                }
                
                
                if error != nil{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: "Please add chair information in order to post chair to barbers.", onViewController: self, returnBlock: { (clickedIN) in
                        
                        
                    })
                    return
                }
            }
        }
    }
    
    
    
    func weeklyMonthlyChair()
    {
        SwiftLoader.show(KUpdating, animated: true)
        
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{
            return
        }
        
        if let obj = chairInfoObj
        {
            
            let shopInfoObj = BRDSingleton.sharedInstane.objShopInfo
            
            if let shopInfo = shopInfoObj
            {
                let inputParameters = ["chair_id": obj._id!,
                                       "type": shopType!,
                                       "amount": self.priceTF.text! , "shop_id" : shopInfo._id!] as [String: Any]
                print(inputParameters)
                let urlString = KBaseURLString + KManageChair
                
                print(urlString)
                BRDAPI.updateService("PUT", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                    SwiftLoader.hide()
                    
                    if let serverMessage = responseMessage {
                        if serverMessage == "Updated successfully"{
                            
                            // SUCCESS CASE
                            _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: "Service Successfully updated", onViewController: self, returnBlock: { (clickedIN) in
                            })
                        }
                    }
                    else{
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                    }
                    
                    
                    if error != nil{
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                            
                        })
                        return
                    }
                }
            }
        }
    }
    
    
    
    
    
    @IBAction func rentWeeklyAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true)
        {
            rentView.isHidden = false
            rentBtn.isSelected = true
            self.saveBtn.bringSubview(toFront: self.view)
            DispatchQueue.main.async {
                
                //                self.scrollView.contentSize = CGSize(width : self.view.frame.width,height : UIScreen.main.bounds.size.height + 100.0)
                
            }
            
        }
        else
        {
            rentBtn.isSelected = false
            
            
            //            DispatchQueue.main.async {
            //                self.scrollView.contentSize = CGSize(width : self.view.frame.width,height : 544)
            //
            //            }
            
//            rentView.isHidden = true
        }
    }
    
    func requestRemoveBarber()
    {
        SwiftLoader.show(KUpdating, animated: true)
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{
            return
        }
        
        if let shopInfo = chairInfoObj
        {
            
            
            let urlString = KBaseURLString + KShopRemoveBarber
            
            print(urlString)
            let shopID: String = BRDSingleton.sharedInstane.objShop_id!
            let shopName : String = (BRDSingleton.sharedInstane.objShopInfo?.name)!
            let email : String = (BRDSingleton.sharedInstane.objBRD_UserInfoBO?.email)!
            let chairID: String = (shopInfo._id)!
            
            let barberID: String = (shopInfo.barberArray![0]._id)! == nil ? "" : (shopInfo.barberArray![0]._id)!
           
            let barberName: String  = (shopInfo.barberArray![0].first_name)! + " " + (shopInfo.barberArray![0].last_name)!
//
            let chairName : String? = shopInfo.name

            
            
            let inputParameters = ["chair_name": chairName,
                                   "name" : shopName,
                                   "barber_name":barberName,
                "chair_id":chairID,
                "barber_id":barberID,
                "shop_id":shopID ,"email" : email ] as [String: Any]
            print(inputParameters)

            
            BRDAPI.addService("POST", inputParameters: inputParameters as! [String : String], header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                SwiftLoader.hide()
                
                if let serverMessage = responseMessage {
                    
                    
                    // SUCCESS CASE
                    _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: serverMessage, onViewController: self, returnBlock: { (clickedIN) in
                        let value: Int = clickedIN
                        if value == 0{
                            _ = self.navigationController?.popViewController(animated: true)
                            
                        }
                        
                    })
                    
                }
                else{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                        
                    })
                }
                
                
                if error != nil{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                        
                        
                    })
                    return
                }
            }
        }

    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func requestBarberButtonAction(_ sender: Any) {
        self.requestRemoveBarber()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let step: Float = 5
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        percentLbl.text = String(format: "%.0f%@",sender.value,"%")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeChairAction(_ sender: Any) {
        self.removeChair()
    }
    @IBAction func makeChairBookAction(_ sender: Any) {
        markChairAsBooked()
    }
    
    @IBAction func postChairAction(_ sender: Any) {
        postChairToallBarbers()
    }
    @IBAction func searchBarberAction(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchBarbersVC") as! SearchBarbersVC
        
        controller.chairInfoObj = self.chairInfoObj
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func markChairAsBooked()
    {
        
        SwiftLoader.show(KUpdating, animated: true)
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{
            return
        }
        
        if let obj = chairInfoObj
        {
            
            
            let urlString = KBaseURLString + KMarkChairAsBooked + "/" + obj._id!
            
            print(urlString)
            BRDAPI.updateService("PUT", inputParameters: nil, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                SwiftLoader.hide()
                
                if let serverMessage = responseMessage {
                  
                        
                        // SUCCESS CASE
                        _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: serverMessage, onViewController: self, returnBlock: { (clickedIN) in
                            let value: Int = clickedIN
                            if value == 0{
                                _ = self.navigationController?.popViewController(animated: true)
                                
                            }
                            
                        })
                    
                }
                else{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                        
                    })
                }
                
                
                if error != nil{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                        
                        
                    })
                    return
                }
            }
        }
        
    }
    
    func deleteChair()
    {
        SwiftLoader.show(KUpdating, animated: true)
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{
            return
        }
        
        if let obj = chairInfoObj
        {
            
            let shopInfoObj = BRDSingleton.sharedInstane.objShopInfo
            
            if let shopInfo = shopInfoObj
            {
                
                let inputParameters = ["chair_id": obj._id!,
                                       "shop_id" : shopInfo._id!] as [String: Any]
                print(inputParameters)
                let urlString = KBaseURLString + KDeleteChairShop
                
                print(urlString)
                BRDAPI.deleteChairShop("DELETE", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                    SwiftLoader.hide()
                    
                    if let serverMessage = responseMessage {
                        
                            
                        _ = self.navigationController?.popViewController(animated: true)

                            _ =  BRDAlertManager.showAlertWithSimilarButtonsType(.default, withTitle: "BarbrDo", withMessage: serverMessage, buttonTitles: ["OK"], onViewController: self, animated: true, presentationCompletionHandler: {
                            }, returnBlock: { response in
                                let value: Int = response
                                if value == 0{
                                    
                                }
                                
                            })
                            return
                            
                        }
                    
                    else{
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                    }
                    
                    
                    if error != nil{
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                            
                        })
                        return
                    }
                }
            }
        }
        
    }
    
    func removeChair()
    {
        _ =  BRDAlertManager.showAlertWithSimilarButtonsType(.default, withTitle: "BarbrDo", withMessage: "Do you really want to remove the chair", buttonTitles: ["OK", "Cancel"], onViewController: self, animated: true, presentationCompletionHandler: {
        }, returnBlock: { response in
            let value: Int = response
            if value == 0{
                // Logout
                
                self.deleteChair()
            }else{
                // Do not logout
            }
            
        })
        return
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension UIButton {
    
    //    This method sets an image and title for a UIButton and
    //    repositions the titlePosition with respect to the button image.
    //    Add additionalSpacing between the button image & title as required
    //    For titlePosition, the function only respects UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft and UIViewContentModeRight
    //    All other titlePositions are ignored
    @objc func set(image anImage: UIImage?, title: NSString!, titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        
        positionLabelRespectToImage(title: title!, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .center
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.setTitle(title as String?, for: .normal)
    }
    
    private func positionLabelRespectToImage(title: NSString, position: UIViewContentMode, spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(attributes: [NSFontAttributeName: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 5, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}
