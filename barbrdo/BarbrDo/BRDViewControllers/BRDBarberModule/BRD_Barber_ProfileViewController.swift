//
//  BRD_Barber_ProfileViewController.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/30/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader
let KBRD_Barber_Profile_StoryboardID = "BRD_Barber_ProfileViewController"


class BarberProfileCell: UITableViewCell{
    
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
    
    
    func initWithData(obj: BRD_UserInfoBO){
        
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
        
        if obj.gallery != nil{
            if let imageCount = obj.gallery?.count{
                let btnTitle = String(describing: imageCount) + " Photos"
                self.btnPhoto.setTitle(btnTitle, for: .normal)
            }
        }
        
        if let rating = obj.rating?.count{
            let cuts: String = String(describing: rating)
            self.btnCuts.setTitle(cuts + " Cuts", for: .normal)
        }
    }
}

class BarberCell:UITableViewCell
{
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtLicenseNumber: UITextField!
    @IBOutlet weak var txtLicensedSince: UITextField!
    
    @IBOutlet weak var lblTypeYourYourself: UILabel!
    @IBOutlet weak var txtBio: UITextView!
    
    @IBOutlet weak var imageViewPassword: UIImageView!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imageViewConfirmPassword: UIImageView!
    
    @IBOutlet weak var lblConfirmPassword: UILabel!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var viewBio: UIView!
    
    @IBOutlet weak var viewSubscription: UIView!
    
    @IBOutlet weak var lblSubscriptionPlan: UILabel!
    @IBOutlet weak var lblExpiryDate: UILabel!
    @IBOutlet weak var btnUpgrade: UIButton!
    
    @IBOutlet weak var btnLicenseSince: UIButton!
    
    
    override func awakeFromNib() {
        //Nothing to do...
        self.viewBio.layer.cornerRadius = 5
        self.viewSubscription.layer.cornerRadius = 5
    }
    
    
    func initWithData(obj: BRD_UserProfileBO){
        
        self.txtFirstName.text = obj.first_name
        self.txtLastName.text = obj.last_name
        self.txtEmailAddress.text = obj.email
        self.txtBio.text = obj.bio
        
        if obj.bio == nil || obj.bio == "" || (obj.bio?.characters.count)! == 0{
            self.lblTypeYourYourself.isHidden = false
        }else{
            self.lblTypeYourYourself.isHidden = true
        }
        
        if  let mobile = obj.mobile_number{
            self.txtMobileNumber.text = (mobile).toPhoneNumber()
        }
        
        self.txtLicenseNumber.text = obj.licenseNumber
        
        
        if let barber = obj.barbers{
            if barber.count > 0{
                
                let firstBarber = barber[0]
                
                if firstBarber.licenseNumber != nil{
                    self.txtLicenseNumber.text = firstBarber.licenseNumber!
                }
            }
        }
        
        if obj.licensed_since != nil{
            
            if let licensedSince = obj.licensed_since {
                self.txtLicensedSince.text = Date.convert(licensedSince, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMM_YYYY)
            }
        }
        
        
        if obj.subscription_plan_name != nil && obj.subscription_price != nil{
            let strPlan = obj.subscription_plan_name! + " ($" + String(format: "%.02f", obj.subscription_price!) + ")"
            self.lblSubscriptionPlan.text = strPlan
        }else{
            self.lblSubscriptionPlan.text = "Free Plan ($0.00)"
        }
        
        
        if obj.subscription_end_date != nil{
        
            self.lblExpiryDate.text = "Expiry: " + Date.convert(obj.subscription_end_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MM_dd_yyYY)
        }
    
        
    }
    
}


class BRD_Barber_ProfileViewController: BRD_BaseViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextViewDelegate{
    

    @IBOutlet weak var tableViewProfile: UITableView!
    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var isActiveField: Bool = false
    var userName     : String = ""
    
    var objUserInfo: BRD_UserInfoBO = BRD_UserInfoBO.init()
    var objUserProfile : BRD_UserProfileBO = BRD_UserProfileBO.init()
    var isEditingMode: Bool = false
    var isBtnChangePasswordTapped: Bool = false
    var image: UIImage? = nil
    
    var objUserProfileCell: BarberProfileCell!
    
    var strLicensedSince: String? = ""
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var viewDatePicker: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if BRDSingleton.sharedInstane.objBRD_UserInfoBO != nil{
            self.objUserInfo = BRDSingleton.sharedInstane.objBRD_UserInfoBO!
        }
        
        self.tableViewProfile.tableFooterView = UIView()
        self.saveButton.isHidden = true
        
        self.datePicker.addTarget(self, action: #selector(datePickerChangeMethod(_:)), for: .valueChanged)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            self.objUserInfo.image = BRDSingleton.resizingCapturedImage(CapturedImage: image)
            self.tableViewProfile.reloadData()
        }
        dismiss(animated: true, completion: nil)
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
            self.saveDetails()
        }
    }
    
    
    func saveDetails(){
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableViewProfile.cellForRow(at: indexPath) as? BarberCell
        
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
            
            
            let mobile: String = (cell?.txtMobileNumber.text)!
            self.objUserInfo.mobile_number = mobile.getMobileNumber(mobile)
            
            if mobile.characters.count == 0{
                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Please fill in mobile number", onViewController: self, returnBlock: { (clickedIN) in
                })
                return
            }
        }
        
        
        
        self.objUserProfile.first_name = cell?.txtFirstName.text
        self.objUserProfile.last_name  = cell?.txtLastName.text
        let mobile: String = (cell?.txtMobileNumber.text)!
        self.objUserProfile.mobile_number = BRDSingleton.getMobileNumber(mobile)
        self.objUserProfile.bio = cell?.txtBio.text!
        self.objUserProfile.licensed_since = Date.convert((cell?.txtLicensedSince.text!)!, Date.DateFormat.DD_MM_YYYY, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
        
        var inputParameter: [String: Any] =
            [KFirstName: self.objUserProfile.first_name!,
             KLastName: self.objUserProfile.last_name!,
             KMobileNumber:self.objUserProfile.mobile_number!,
             "bio": self.objUserProfile.bio!,
            "licensed_since" : self.objUserProfile.licensed_since!
             ]
        
        if cell != nil{
            
            if (cell?.txtPassword.text?.characters.count)! > 0{
                inputParameter[KPassword] = self.objUserInfo.password
                inputParameter[KConfirm] = self.objUserInfo.confirmPassword
            }
        }
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
        
        BRDAPI.updateAccount("PUT", imageData: imageDictionary, imageType: ImageType.jpeg, dictionary: inputParameter, header: header!, url: urlString) { (response, user, userProfile, status, error) in
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
    @IBAction func photoButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name:customerStoryboard , bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_GalleryVC_StoryboardID) as! BRD_Customer_GalleryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnCutsAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_CompletedVC_StoryboardID) as! BRD_Customer_CompletedVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  
    //MARK: Textfield Delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        
       
    }
    
    func checkMaxLength(_ textField: UITextField!, maxLength: Int) {
        if (textField.text!.characters.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if string.characters.count == 0 {
            return true
        }
        
        // SPECIAL CHARACTERS VALIDATION
        if string.rangeOfCharacter(from: KCharacterset.inverted) != nil{
            return false
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableViewProfile.cellForRow(at: indexPath) as? BarberCell
        
        if cell != nil{
            if textField == cell?.txtFirstName{
                self.checkMaxLength(textField, maxLength: 14)
            }
            if textField == cell?.txtLastName{
                self.checkMaxLength(textField, maxLength: 14)
            }
            if textField == cell?.txtMobileNumber{
                //self.checkMaxLength(textField, maxLength: 9)
                
                
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
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableViewProfile.cellForRow(at: indexPath) as? BarberCell
        
        if cell != nil{
            if textView == cell?.txtBio{
            let strText = (cell?.txtBio.text)! + text
                
                if strText.characters.count == 0{
                    cell?.lblTypeYourYourself.isHidden = false
                }else{
                    cell?.lblTypeYourYourself.isHidden = true
                }
            }
        }
        return true
    }
    //MARK:- UITextView Delegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.endEditing(true)
    }

    
    
    //MARK:- UITableView DataSource and Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var defaultHeight:CGFloat = 500.0
        if self.objUserProfile.bio != nil{

            let btnFont: UIFont = UIFont(name: "Berlin Sans FB", size: 15.0)!
            let msgHeight: CGFloat = self.heightWithConstrainedWidth(width: tableView.bounds.size.width - 20, font: btnFont, msg: self.objUserProfile.bio!)
            
            if msgHeight < 88.0 {
                defaultHeight += 88.0
            }
            else{
                defaultHeight += msgHeight
            }
        }else{
            defaultHeight += 88.0
        }

        print("Returned height is \(defaultHeight)")
        return defaultHeight
        
        
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont, msg strTitle: String ) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = strTitle.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarberCell", for: indexPath as IndexPath) as! BarberCell
        cell.initWithData(obj: self.objUserProfile)
        
        cell.btnUpgrade.addTarget(self, action: #selector(goToSubscription), for: .touchUpInside)
        cell.imageViewPassword.isHidden = true
        cell.lblPassword.isHidden = true
        cell.txtPassword.isHidden = true
        
        cell.imageViewConfirmPassword.isHidden = true
        cell.lblConfirmPassword.isHidden = true
        cell.txtConfirmPassword.isHidden = true
        
        cell.btnLicenseSince.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
        
        if self.isEditingMode == true && (BRDSingleton.sharedInstane.objBRD_UserInfoBO?.facebook == nil || BRDSingleton.sharedInstane.objBRD_UserInfoBO?.facebook == ""){
            cell.txtFirstName.isUserInteractionEnabled = true
            cell.txtLastName.isUserInteractionEnabled = true
            cell.txtMobileNumber.isUserInteractionEnabled = true
            
            cell.imageViewPassword.isHidden = false
            cell.lblPassword.isHidden = false
            cell.txtPassword.isHidden = false
            
            cell.imageViewConfirmPassword.isHidden = false
            cell.lblConfirmPassword.isHidden = false
            cell.txtConfirmPassword.isHidden = false
            cell.txtBio.isEditable = true
            
        }else{
            cell.txtFirstName.isUserInteractionEnabled = false
            cell.txtLastName.isUserInteractionEnabled = false
            cell.txtMobileNumber.isUserInteractionEnabled = false
            cell.txtBio.isEditable = false
        }
        
        cell.txtEmailAddress.isUserInteractionEnabled = false
        cell.txtLicenseNumber.isUserInteractionEnabled = false
        cell.txtLicensedSince.isUserInteractionEnabled = false
        
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
    
    func showPicker(){
        
        if self.isEditingMode == true{
            self.viewDatePicker.isHidden = false
        }
    }
    
    
    
    func goToSubscription(){
       /* let storyboard = UIStoryboard(name: barberStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InAppPurchaseVC")
        self.present(controller, animated: true, completion: nil)*/
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            self.objUserProfileCell = tableView.dequeueReusableCell(withIdentifier: "BarberProfileCell") as! BarberProfileCell
            
            self.objUserProfileCell.initWithData(obj: self.objUserInfo)
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
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_GalleryVC_StoryboardID) as! BRD_Customer_GalleryVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 103:
            let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BarberCutsVC") as! BarberCutsVC
            
            if let arrayCuts = self.objUserProfile.ratings{
                vc.arrayTableView = arrayCuts
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
        
    }
    
    func openPicker(){
        if editbutton.isHidden == false{return}
        
        let optionMenu = UIAlertController(title: nil, message: KChooseOption, preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: KPhotoLibrary, style: .default, handler:
        {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnDatePickerCancelDone(_ sender: UIBarButtonItem) {
        
        self.viewDatePicker.isHidden = true
        
        switch sender.tag {
        case 401:
            // cancel
            
            break
        case 402:
            //Done
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = self.tableViewProfile.cellForRow(at: indexPath) as? BarberCell
            if self.strLicensedSince != ""{
            
                cell?.txtLicensedSince.text = self.strLicensedSince
                self.objUserInfo.licensed_since = Date.convert(self.strLicensedSince!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMM_YYYY)
            }
            break
        default:
            break
        }
    }
    

    func datePickerChangeMethod(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = Date.DateFormat.DD_MM_YYYY
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        self.strLicensedSince = selectedDate
        print("Selected value \(selectedDate)")
    }
    
  
   
}

