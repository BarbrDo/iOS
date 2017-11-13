//
//  BRD_Shop_ProfileVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 6/1/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

let KBRD_Shop_ProfileVC_StoryboardID = "BRD_Shop_ProfileVCStoryboardID"

class ShopProfileCell: UITableViewCell{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageViewBG: UIImageView!
    @IBOutlet weak var imageViewProfileImage: UIImageView!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var btnCuts: UIButton!
    @IBOutlet weak var btnChangeProfileImage: UIButton!
    
    @IBOutlet weak var lblFullName: UILabel!
    
    
    override func awakeFromNib() {
        //Nothing to do...
        
        self.imageViewProfileImage.layer.cornerRadius = 40.0
        self.imageViewProfileImage.clipsToBounds = true
        self.imageViewProfileImage.layer.borderColor = UIColor.white.cgColor
        self.imageViewProfileImage.layer.borderWidth = 2.0
    }
    
    
    func initWithData(obj: BRD_UserProfileBO){
        
        var fullName: String = ""
        
        if obj.first_name != nil{
            fullName = obj.first_name! + " "
        }
        if obj.last_name != nil{
            fullName = fullName + obj.last_name!
        }
        
        self.lblFullName.text = fullName
        
        if obj.image != nil{
            self.imageViewProfileImage.image = obj.image
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
            
        }else{
            if obj.picture != nil{
                let imagePath = KImagePathForServer + obj.picture!
                self.activityIndicator.startAnimating()
                self.imageViewProfileImage.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                    
                    DispatchQueue.main.async(execute: {
                        if image != nil{
                            self.imageViewProfileImage.image = image
                        }else{
                            self.imageViewProfileImage.image = UIImage(named: "ICON_PROFILEIMAGE")
                        }
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidesWhenStopped = true
                    })
                })
            }else{
                self.imageViewProfileImage.image = UIImage(named: "ICON_PROFILEIMAGE")
                self.activityIndicator.hidesWhenStopped = true
            }
        }
        
        
        if let shops = obj.shops{
            
            if shops.count > 0{
                if let hairCut = shops[0].chairs as? [BRD_ChairInfo]{
                    
                    var array = [BRD_ChairInfo]()
                    for tempData in hairCut{
                        if tempData.isActive == true && tempData.availability == "booked" && tempData.barber_id != nil{
                            array.append(tempData)
                        }
                    }
                    let btnTitle = String(describing: array.count) + " Barbers"
                    self.btnPhoto.setTitle(btnTitle, for: .normal)
                }
            }
            // New Changes
            
        }else{
            let btnTitle = "0 Barbers"
            self.btnPhoto.setTitle(btnTitle, for: .normal)
        }

/*
        if let rating = obj.ratings?.count{
            let cuts: String = String(describing: rating)
            self.btnCuts.setTitle(cuts + " Cuts", for: .normal)
        }*/
        self.btnCuts.setTitle("0 Cuts", for: .normal)
    }
}

class ShopCell:UITableViewCell
{
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtLicenseNumber: UITextField!
    @IBOutlet weak var txtMemberSince: UITextField!
    
    @IBOutlet weak var txtShopName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZipCode: UITextField!
    
    @IBOutlet weak var imageViewPassword: UIImageView!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imageViewConfirmPassword: UIImageView!
    
    @IBOutlet weak var lblConfirmPassword: UILabel!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "ShopCell"
    }
    
    override func awakeFromNib() {
        //Nothing to do...
    }
    
    
    func initWithData(obj: BRD_UserProfileBO){
        
        
        if obj.first_name != nil{
            self.txtFirstName.text = obj.first_name!
        }
        
        if obj.last_name != nil{
            self.txtLastName.text = obj.last_name!
        }
        
        if obj.email != nil{
            self.txtEmailAddress.text = obj.email
        }
        
        if obj.mobile_number != nil{
            self.txtMobileNumber.text = (obj.mobile_number!).toPhoneNumber()
        }
        
        if let barber = obj.barbers{
            if barber.count > 0{
                
                let firstBarber = barber[0]
                if firstBarber.licenseNumber != nil{
                    self.txtLicenseNumber.text = firstBarber.licenseNumber!
                }
            }
        }
        
        
        if obj.created_date != nil{
            
            if let createdDate = obj.created_date {
                self.txtMemberSince.text = Date.convert(createdDate, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMM_YYYY)
            }
        }
        
        if let shopData = obj.shops{
            
            if shopData.count > 0{
                if let objShop = shopData[0] as? BRD_ShopDataBO{
                    if objShop.name != nil{
                        self.txtShopName.text = objShop.name!
                    }
                    
                    if objShop.zip != nil{
                        self.txtZipCode.text = objShop.zip!
                    }
                    
                    if objShop.address != nil{
                        self.txtAddress.text = objShop.address!
                    }
                    if objShop.city != nil{
                        self.txtCity.text = objShop.city!
                    }
                    if objShop.state != nil{
                        self.txtState.text = objShop.state!
                    }
                }
            }
            
        }
    }
    
}

class BRD_Shop_ProfileVC: BRD_BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var tableViewProfile: UITableView!
    
    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var personalprofileArray = NSMutableArray()
    var shopprofileArray = NSMutableArray()
    
    var isActiveField: Bool = false
    var userName     : String = ""
    
    
    var objUserInfo: BRD_UserInfoBO = BRD_UserInfoBO.init()
    var objUserProfile : BRD_UserProfileBO = BRD_UserProfileBO.init()
    var isEditingMode: Bool = false
    var isBtnChangePasswordTapped: Bool = false
    var globalImage: UIImage? = nil
    
    var objUserProfileCell: ShopProfileCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveButton.isHidden = true
        self.getUserProfile()
    }
    
    func getUserProfile(){
        
        let userID = BRDSingleton.sharedInstane.objBRD_UserInfoBO?._id
        if userID == nil{return}
        let urlString = KBaseURLString + KUserProfile + userID!
        
        SwiftLoader.show(KLoading, animated: true)
        
        BRDAPI.getUserProfile("GET", inputParameter: nil, header: nil, urlString: urlString) { (response, userInfo, status, error) in
            
            SwiftLoader.hide()
            if userInfo != nil{
                self.objUserProfile = userInfo!
                self.tableViewProfile.reloadData()
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: error.debugDescription, onViewController: self, returnBlock: { (clickedIN) in
                })
            }
        }
        
    }
    
    @IBAction func btnChangeProfilePictureAction(_ sender: UIButton) {
    }
    
    
    @IBAction func btnEditSaveAction(sender: UIButton){
        
        if sender.tag == 201{
            
            // Edit Button Action
            self.isEditingMode = true
            
            isActiveField = true
            self.tableViewProfile.reloadData()
            self.saveButton.isHidden = false
            self.editbutton.isHidden = true
        }
        
        if sender.tag == 202{
            // Save Button Action
            //isEditingMode = false
            //self.saveDetails()
            self.updateShopDetails()
        }
    }
    
    func updateShopDetails(){
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableViewProfile.cellForRow(at: indexPath) as? ShopCell
        
        if cell != nil{
            
            self.objUserInfo.password = cell?.txtPassword.text
            self.objUserInfo.confirmPassword = cell?.txtConfirmPassword.text
            let result = self.validatePassword(password: self.objUserInfo.password!, confirmPassword: self.objUserInfo.confirmPassword!)
            if result == false{
                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: KPasswordValidation, onViewController: self, returnBlock: { (clickedIN) in
                })
                return
            }else if (self.objUserInfo.password?.characters.count)! > 0 {
                if (self.objUserInfo.password?.characters.count)! < 6 || (self.objUserInfo.confirmPassword?.characters.count)! < 6{
                    _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: KPasswordAndConfirmValidation, onViewController: self, returnBlock: { (clickedIN) in
                    })
                    return
                }
            }
        }

        
        let header = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{
            return
        }
        
        let urlString = KBaseURLString + KUpdateShopDetails
        SwiftLoader.show(KUpdating, animated: true)
        
        var inputParameter = [String: Any]()
        
        if cell != nil{
            if let shopArray = self.objUserProfile.shops{
                if shopArray.count > 0{
                    if let objShop1 = shopArray[0] as? BRD_ShopDataBO{
                        
                        inputParameter =  ["_id" : objShop1._id!,
                                           "name" : (cell?.txtShopName.text)!,
                                           "address": (cell?.txtAddress.text)!,
                                           "state" : (cell?.txtState.text)!,
                                           "zip" : (cell?.txtZipCode.text)!,
                                           "city" : (cell?.txtCity.text)!]
                    }
                }
            }
            
        }
        
        BRDAPI.updateShopDetails("PUT", inputParameter: inputParameter, header: header!, urlString: urlString) { (response, responseMessage, status, error) in
            
            if responseMessage == KUpdatedSuccessfully{
                
                self.saveDetails()
            }else{
                SwiftLoader.hide()
                if error != nil{
                    
                    _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    })
                }
            }
        }
    }
    
    
    func saveDetails(){
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableViewProfile.cellForRow(at: indexPath) as? ShopCell

        
        self.objUserProfile.first_name = cell?.txtFirstName.text
        self.objUserProfile.last_name  = cell?.txtLastName.text
        let mobile: String = (cell?.txtMobileNumber.text)!
        self.objUserProfile.mobile_number = mobile.getMobileNumber(mobile)
        
        var inputParameter: [String: Any] =
            [KFirstName: self.objUserProfile.first_name!,
             KLastName: self.objUserProfile.last_name!,
             KMobileNumber:self.objUserProfile.mobile_number!]
        
        
        if let shopArray = self.objUserProfile.shops{
            
            if shopArray.count > 0{
                if let objShop1 = shopArray[0] as? BRD_ShopDataBO{
                    
                    objShop1.name = cell?.txtShopName.text!
                    objShop1.address = cell?.txtAddress.text!
                    objShop1.state = cell?.txtState.text!
                    objShop1.zip = cell?.txtZipCode.text!
                    objShop1.city = cell?.txtCity.text!
                }
            }
        }
        
        if cell != nil{
            
            if (cell?.txtPassword.text?.characters.count)! > 0{
                inputParameter[KPassword] = self.objUserInfo.password
                inputParameter[KConfirm] = self.objUserInfo.confirmPassword
            }
        }
        print(inputParameter)
        
        var imageDictionary: [String: Data]? = nil
        let userImage = self.objUserProfileCell.imageViewProfileImage.image
        
        if userImage != nil{
            let imageData: Data = UIImageJPEGRepresentation(userImage!, 1.0)!
            imageDictionary = [KType: imageData]
        }
        
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{
            return
        }
        
        let urlString = KBaseURLString + KAccount
        
        SwiftLoader.show(KUpdating, animated: true)
        
        
        BRDAPI.updateAccount("PUT", imageData: imageDictionary, imageType: ImageType.jpeg, dictionary: inputParameter, header: header!, url: urlString) { (response, user,userProfile, status, error) in
            SwiftLoader.hide()
            if user != nil{
                
                self.isActiveField = false
                self.isEditingMode = false
                self.saveButton.isHidden = true
                self.editbutton.isHidden = false
                                
                BRDSingleton.sharedInstane.objBRD_UserInfoBO = user
                let data = NSKeyedArchiver.archivedData(withRootObject: user!)
                UserDefaults.standard.set(data, forKey: BRDRawStaticStrings.kUserData)
                
                self.objUserInfo = user!
                self.tableViewProfile.reloadData()
                NotificationCenter.default.post(name: Notification.Name(rawValue: imageUpdated), object: nil)
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: KProfileUpdatedSuccessfully, onViewController: self, returnBlock: { (clickedIN) in
                })
                
            }else{
                
                if error?.localizedDescription == nil || error?.localizedDescription == ""{
                    _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: KPleaseTryAgainLater, onViewController: self, returnBlock: { (clickedIN) in
                    })
                }
            }
        }
        
        self.view.resignFirstResponder()
        self.tableViewProfile.reloadData()
    }
    
    func validatePassword(password: String, confirmPassword: String) -> Bool{
        
        if password == confirmPassword{
            return true
        }else{
            return false
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Textfield Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.characters.count == 0 {
            return true
        }
        
        // SPECIAL CHARACTERS VALIDATION
        if string.rangeOfCharacter(from: KCharacterset.inverted) != nil{
            return false
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableViewProfile.cellForRow(at: indexPath) as? ShopCell
        
        if cell != nil{
            if textField == cell?.txtFirstName{
                self.checkMaxLength(textField, maxLength: 14)
            }
            if textField == cell?.txtLastName{
                self.checkMaxLength(textField, maxLength: 14)
            }
            if textField == cell?.txtMobileNumber{
                
                
                let length = Int(BRDSingleton.getStringLength(textField.text!))
                if length == 10 {
                    if range.length == 0 {
                        return false
                    }
                }
                if length == 3 {
                    
                    let num: NSString = BRDSingleton.formatStringintoMobileNumber(textField.text!) as NSString
                    textField.text = "(\(num)) "
                    if range.length > 0 {
                        textField.text = num.substring(to: 3)
                    }
                }
                else if length == 6 {
                    let num: NSString = BRDSingleton.formatStringintoMobileNumber(textField.text!) as NSString
                    textField.text = "(\(num.substring(to: 3)))" + " \(num.substring(from: 3))-"
                    if range.length > 0 {
                        textField.text = (num.substring(to: 3)) + " \(num.substring(from: 3))"
                    }
                }
            }
            
            if textField == cell?.txtPassword{
                self.checkMaxLength(textField, maxLength: 9)
            }
            if textField == cell?.txtConfirmPassword{
                self.checkMaxLength(textField, maxLength: 9)
            }
        }
        return true
    }
    
    func checkMaxLength(_ textField: UITextField!, maxLength: Int) {
        if (textField.text!.characters.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension BRD_Shop_ProfileVC: UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK:- UITableView DataSource and Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopCell.identifier(), for: indexPath as IndexPath) as! ShopCell
        cell.initWithData(obj: self.objUserProfile)
        
        cell.imageViewPassword.isHidden = true
        cell.lblPassword.isHidden = true
        cell.txtPassword.isHidden = true
        
        cell.imageViewConfirmPassword.isHidden = true
        cell.lblConfirmPassword.isHidden = true
        cell.txtConfirmPassword.isHidden = true
        
        cell.txtEmailAddress.isUserInteractionEnabled = false
        cell.txtLicenseNumber.isUserInteractionEnabled = false
        cell.txtMemberSince.isUserInteractionEnabled = false
        
        if self.isEditingMode == true && BRDSingleton.sharedInstane.objBRD_UserInfoBO?.facebook == ""{
            cell.txtFirstName.isUserInteractionEnabled = true
            cell.txtLastName.isUserInteractionEnabled = true
            cell.txtMobileNumber.isUserInteractionEnabled = true
            cell.txtShopName.isUserInteractionEnabled = true
            cell.txtAddress.isUserInteractionEnabled = true
            cell.txtCity.isUserInteractionEnabled = true
            cell.txtState.isUserInteractionEnabled = true
            cell.txtZipCode.isUserInteractionEnabled = true
            
            // Password
            cell.imageViewPassword.isHidden = false
            cell.lblPassword.isHidden = false
            cell.txtPassword.isHidden = false
            
            cell.imageViewConfirmPassword.isHidden = false
            cell.lblConfirmPassword.isHidden = false
            cell.txtConfirmPassword.isHidden = false
            
            cell.txtMobileNumber.delegate = self
            
        }else{
            cell.txtFirstName.isUserInteractionEnabled = false
            cell.txtLastName.isUserInteractionEnabled = false
            cell.txtMobileNumber.isUserInteractionEnabled = false
            cell.txtShopName.isUserInteractionEnabled = false
            cell.txtAddress.isUserInteractionEnabled = false
            cell.txtCity.isUserInteractionEnabled = false
            cell.txtState.isUserInteractionEnabled = false
            cell.txtZipCode.isUserInteractionEnabled = false
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var sectionHeight: CGFloat = 0.0
        if section == 0{
            sectionHeight = 170.0
        }else{
            sectionHeight = 10.0
        }
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            self.objUserProfileCell = tableView.dequeueReusableCell(withIdentifier: "ShopProfileCell") as! ShopProfileCell
            
            self.objUserProfileCell.initWithData(obj: self.objUserProfile)
            self.objUserProfileCell.btnChangeProfileImage.addTarget(self, action: #selector(btnActionForHeader(sender:)), for: .touchUpInside)
            self.objUserProfileCell.btnPhoto.addTarget(self, action: #selector(btnActionForHeader(sender:)), for: .touchUpInside)
            self.objUserProfileCell.btnCuts.addTarget(self, action: #selector(btnActionForHeader(sender:)), for: .touchUpInside)
            return self.objUserProfileCell
            
        }else{
            let view = UIView()
            view.frame = CGRect.init(x: 0, y: 0, width: 320, height: 10)
            view.backgroundColor = UIColor(red: 199.0/255.0, green: 200.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            return view
        }
    }
    
    func btnActionForHeader(sender: UIButton){
        
        switch sender.tag {
        case 101:
            
            if self.isEditingMode == false{return}
            self.openPicker()
            break
        case 102:
            let storyboard = UIStoryboard(name:shopStoryboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Shop_DashboardVC_StoryboardID) as! BRD_Shop_DashboardVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 103:/*
            let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BarberCutsVC") as! BarberCutsVC
            
            if let arrayCuts = self.objUserInfo.rating{
                vc.arrayTableView = arrayCuts
            }
            self.navigationController?.pushViewController(vc, animated: true)*/
            break
        default:
            break
        }
        
    }
    
    func openPicker(){
        if editbutton.isHidden == false{return}
        
        let optionMenu = UIAlertController(title: nil, message: KChooseOption, preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: KPhotoLibrary, style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: { imageP in
                
            })
            
        })
        
        let deleteAction = UIAlertAction(title: KCamera, style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .camera
                imagePickerController.allowsEditing = true
                self.present(imagePickerController, animated: true, completion: { imageP in
                    
                })
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: KCameraAlert, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
                return
            }
        })
        
        let cancelAction = UIAlertAction(title: KCancel, style: .cancel, handler:{
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            self.objUserProfile.image =
                BRDSingleton.resizingCapturedImage(CapturedImage: image)
            self.tableViewProfile.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
}
