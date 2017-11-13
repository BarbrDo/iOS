//
//  BRD_Customer_ProfileViewController.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/12/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader
import IQKeyboardManagerSwift

let KBRD_Customer_Profile_StoryboardID = "BRD_Customer_ProfileViewController"

class UserProfileCell: UITableViewCell{
    
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
                self.activityIndicator.hidesWhenStopped = true
                self.imageViewProfileImage.image = UIImage(named: "ICON_PROFILEIMAGE")
            }
        }
        
        if obj.gallery != nil{
            if let imageCount = obj.gallery?.count{
                let btnTitle = String(describing: imageCount) + " Photos"
                self.btnPhoto.setTitle(btnTitle, for: .normal)
            }
        }
        
        let cuts: String = String(describing: BRDSingleton.sharedInstane.totalCuts!)
        self.btnCuts.setTitle(cuts + " Cuts", for: .normal)
    }
}

class ProfileCell:UITableViewCell
{
    @IBOutlet weak var txtViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtMemberSince: UITextField!
    
    @IBOutlet weak var btnSearchRadius: UIButton!
    
    
    @IBOutlet weak var imageViewPassword: UIImageView!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imageViewConfirmPassword: UIImageView!
    
    @IBOutlet weak var lblConfirmPassword: UILabel!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    
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
        
        if obj.radius_search != nil{
            let radius = obj.radius_search! + " mi"
            self.btnSearchRadius.setTitle(radius, for: .normal)
        }

        
        
        if obj.created_date != nil{
            
            if let createdDate = obj.created_date {
                self.txtMemberSince.text = Date.convert(createdDate, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMM_YYYY)
            }
        }
    }
    
}


class BRD_Customer_ProfileViewController: BRD_BaseViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
   
    var placeholderArray = NSMutableArray()
    var isActiveField: Bool = false
    var searchRadius : String = ""

   
    @IBOutlet weak var radiusBackgroundView : UIView!
    @IBOutlet weak var sliderRadius: UISlider!
    
    @IBOutlet weak var sliderRadiusLbl: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imagePicker = UIImagePickerController()
    
    
    var objUserInfo: BRD_UserInfoBO = BRD_UserInfoBO.init()
    var isEditingMode: Bool = false
    var isBtnChangePasswordTapped: Bool = false
    var image: UIImage? = nil
    
    var objUserProfileCell: UserProfileCell!
    var objCustomerProfile: BRD_UserProfileBO? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if BRDSingleton.sharedInstane.objBRD_UserInfoBO != nil{
            self.objUserInfo = BRDSingleton.sharedInstane.objBRD_UserInfoBO!
        }
        
        self.tableView.tableFooterView = UIView()
        self.saveButton.isHidden = true
        
        // For Hiding search radius background View
        self.radiusBackgroundView.isHidden = true
        getUserProfile()
    }
    
    
    func getUserProfile(){
        
        let userID = BRDSingleton.sharedInstane.objBRD_UserInfoBO?._id
        if userID == nil{return}
        let urlString = KBaseURLString + KUserProfile + userID!
        
        SwiftLoader.show(KLoading, animated: true)
        
        BRDAPI.getUserProfile("GET", inputParameter: nil, header: nil, urlString: urlString) { (response, userInfo, status, error) in
            
            SwiftLoader.hide()
            if userInfo != nil{
                self.objCustomerProfile = userInfo!
                self.tableView.reloadData()
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: error.debugDescription, onViewController: self, returnBlock: { (clickedIN) in
                })
            }
        }
    }

    
    @IBAction func btnChangeProfilePictureAction(_ sender: UIButton) {
        
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
        
        let deleteAction = UIAlertAction(title: KCamera, style: .default, handler:
        {
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
            
            self.objUserInfo.image = BRDSingleton.resizingCapturedImage(CapturedImage: image)
            self.tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnEditSaveAction(sender: UIButton){
        
        if sender.tag == 201{
            
            // Edit Button Action
            self.isEditingMode = true
            
            isActiveField = true
            self.tableView.reloadData()
            self.saveButton.isHidden = false
            self.editbutton.isHidden = true
        }
        
        if sender.tag == 202{
            // Save Button Action
//            isEditingMode = false
//            self.saveButton.isHidden = true
//            self.editbutton.isHidden = false
            self.saveDetails()
        }
    }
    
    
    func saveDetails(){
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath) as? ProfileCell
        
        if cell != nil{
            
            self.objUserInfo.password = cell?.txtPassword.text
            self.objUserInfo.confirmPassword = cell?.txtConfirmPassword.text
            let result = self.validatePassword(password: self.objUserInfo.password!, confirmPassword: self.objUserInfo.confirmPassword!)
            self.objUserInfo.first_name = cell?.txtFirstName.text
            self.objUserInfo.last_name = cell?.txtLastName.text
            
            let radius = cell?.btnSearchRadius.titleLabel?.text
            
            if (radius?.contains(" "))!{
                if let radiusComponents = radius?.components(separatedBy: " "){
                    if radiusComponents.count > 0{
                        self.objUserInfo.radius_search = radiusComponents[0]
                    }
                }
            }else{
                self.objUserInfo.radius_search = "10"
            }
            
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
        
        let mobile: String = (cell?.txtMobileNumber.text)!
        self.objUserInfo.mobile_number = mobile.getMobileNumber(mobile)
        
        if mobile.characters.count == 0{
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Please fill in mobile number", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        
        var inputParameter: [String: Any] =
            [KFirstName: self.objUserInfo.first_name!,
             KLastName: self.objUserInfo.last_name!,
             KMobileNumber:self.objUserInfo.mobile_number!,
             KRadiusSearch: self.objUserInfo.radius_search!,
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
        
        
        BRDAPI.updateAccount("PUT", imageData: imageDictionary, imageType: ImageType.jpeg, dictionary: inputParameter, header: header!, url: urlString) { (response, user ,userProfile, status, error) in
            SwiftLoader.hide()
            if user != nil{
                self.isActiveField = false
                self.isEditingMode = false
                self.saveButton.isHidden = true
                self.editbutton.isHidden = false
                self.objCustomerProfile = userProfile
                
                BRDSingleton.sharedInstane.objBRD_UserInfoBO = user
                let data = NSKeyedArchiver.archivedData(withRootObject: user!)
                UserDefaults.standard.set(data, forKey: BRDRawStaticStrings.kUserData)
                self.objUserInfo.image = nil
                self.objUserInfo = user!
                
                self.tableView.reloadData()
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
    
    @IBAction func OkRadiusAction(_ sender: Any) {
        print(self.searchRadius)
        self.objUserInfo.radius_search = self.sliderRadiusLbl.text
        self.objCustomerProfile?.radius_search = self.sliderRadiusLbl.text
        self.radiusBackgroundView.isHidden = true
        self.tableView.reloadData()
    }
    
    @IBAction func sliderRadiusChanged(_ sender: UISlider) {
        
        
        print(sender.value)
        String(format: "%.0f", sender.value)
        DispatchQueue.main.async(execute: {
            self.sliderRadiusLbl.text = String(format: "%.0f", sender.value)
            self.searchRadius = self.sliderRadiusLbl.text!
        })
        
        print(self.sliderRadiusLbl.text)
        self.searchRadius  = self.sliderRadiusLbl.text!
        self.objCustomerProfile?.radius_search = self.sliderRadiusLbl.text
    }
    
    @IBAction func CancelRadiusAction(_ sender: Any) {
        self.radiusBackgroundView.isHidden = true
        
    }
    //MARK: Textfield Delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        
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
        let cell = self.tableView.cellForRow(at: indexPath) as? ProfileCell
        
        if cell != nil{
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
    //MARK:- UITableView DataSource and Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 475.0
    }
    
    func btnAction(sender: UIButton){
        let indexPath = BRDUtility.indexPath(self.tableView, sender)

        switch sender.tag {
        case 105:
            if indexPath.section == 0{
                if isActiveField == true{
                    
                    if indexPath.row == 4{
                        if self.searchRadius != ""{
                            
                            if self.searchRadius.contains(" "){
                                let array = self.searchRadius.components(separatedBy: " ")
                                let firstIndex = array[0]
                                let sliderVal : Float = Float(firstIndex)!
                                self.sliderRadius.setValue(sliderVal, animated: true)
                                
                                let cell = self.tableView.cellForRow(at: indexPath) as? ProfileCell
                                let radius = String(describing: self.sliderRadius.value) + " mi"
                                self.objCustomerProfile?.radius_search = String(describing: self.sliderRadius.value)
                                cell?.btnSearchRadius.setTitle(radius, for: .normal)
                                
                            }else{
                                let sliderVal : Float = Float(self.searchRadius)!
                                self.sliderRadius.setValue(sliderVal, animated: true)
                                let cell = self.tableView.cellForRow(at: indexPath) as? ProfileCell
                                let radius = String(describing: self.sliderRadius.value) + " mi"
                                
                                self.objCustomerProfile?.radius_search = String(describing: self.sliderRadius.value) 
                                cell?.btnSearchRadius.setTitle(radius, for: .normal)
                            }
                            
                        }
                    }
                }
            }
            
            break
            
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath as IndexPath) as! ProfileCell
        
        
        if self.searchRadius != ""{
            let radius = self.searchRadius + " mi"
            cell.btnSearchRadius.setTitle(radius, for: .normal)
        }
        
        if self.objCustomerProfile != nil{
            cell.initWithData(obj: self.objCustomerProfile!)
        }
        cell.btnSearchRadius.addTarget(self, action: #selector(btnSearchRadiusAction), for: .touchUpInside)
        
        if self.isEditingMode == true{
            cell.txtFirstName.isUserInteractionEnabled = true
        }else{
            cell.txtFirstName.isUserInteractionEnabled = false
        }
        
        if self.isEditingMode == true{
            cell.txtLastName.isUserInteractionEnabled = true
        }else{
            cell.txtLastName.isUserInteractionEnabled = false
        }
        
        cell.txtEmailAddress.isUserInteractionEnabled = false
        
        if self.isEditingMode == true{
            cell.txtMobileNumber.isUserInteractionEnabled = true
        }else{
            cell.txtMobileNumber.isUserInteractionEnabled = false
        }
        
        cell.txtMemberSince.isUserInteractionEnabled = false
        
        cell.imageViewPassword.isHidden = true
        cell.lblPassword.isHidden = true
        cell.txtPassword.isHidden = true
        
        cell.imageViewConfirmPassword.isHidden = true
        cell.lblConfirmPassword.isHidden = true
        cell.txtConfirmPassword.isHidden = true
        
        if isEditingMode == true{
            cell.imageViewPassword.isHidden = false
            cell.lblPassword.isHidden = false
            cell.txtPassword.isHidden = false
            
            cell.imageViewConfirmPassword.isHidden = false
            cell.lblConfirmPassword.isHidden = false
            cell.txtConfirmPassword.isHidden = false
        }
        return cell
    }
    
    
    func btnSearchRadiusAction(){
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath) as? ProfileCell
        
        print(cell?.btnSearchRadius.titleLabel?.text)
        
        
        if self.isEditingMode == true{
            self.view.endEditing(true)
            
                if let radius = cell?.btnSearchRadius.titleLabel?.text{
                    if (radius.contains(" ")){
                        let radius = cell?.btnSearchRadius.titleLabel?.text?.components(separatedBy: " ")
                        if ((radius?.count) != nil){
                            let value = radius?[0]
                            let sliderVal : Float = Float(value!)!
//                            self.sliderRadiusLbl.text = String(describing: value!)
                            self.sliderRadiusLbl.text = String(format: "%.0f", sliderVal)

                            self.sliderRadius.setValue(sliderVal, animated: true)
                        }
                    }else{
                        self.sliderRadiusLbl.text = String(describing: radius)
                        let sliderVal : Float = Float(radius)!
                        self.sliderRadius.setValue(sliderVal, animated: true)
                    }
                }
            
//            else{
//                var sliderVal: Float = 0
//                if self.isNumber(stringToTest: self.objUserInfo.radius_search!){
//                    sliderVal = Float(self.objUserInfo.radius_search!)!
//                }
//                self.sliderRadiusLbl.text = String(describing: sliderVal)
//                self.sliderRadius.setValue(sliderVal, animated: true)
//            }
            self.radiusBackgroundView.isHidden = false
        }
    }
    
    func isNumber(stringToTest : String) -> Bool {
        let numberCharacters = CharacterSet.decimalDigits.inverted
        return !stringToTest.isEmpty && stringToTest.rangeOfCharacter(from:numberCharacters) == nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var sectionHeight: CGFloat = 0.0
        if section == 0{
            sectionHeight = 180.0
        }else{
            sectionHeight = 10.0
        }
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
             self.objUserProfileCell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell") as! UserProfileCell
            
            self.objUserProfileCell.initWithData(obj: self.objUserInfo)
            self.objUserProfileCell.btnChangeProfileImage.addTarget(self, action: #selector(btnActionForHeader(sender:)), for: .touchUpInside)
            self.objUserProfileCell.btnPhoto.addTarget(self, action: #selector(btnActionForHeader(sender:)), for: .touchUpInside)
//            self.objUserProfileCell.btnCuts.addTarget(self, action: #selector(btnActionForHeader(sender:)), for: .touchUpInside)
            return self.objUserProfileCell
            
        }else{
            let view = UIView()
            view.frame = CGRect.init(x: 0, y: 0, width: 320, height: 10)
            view.backgroundColor = UIColor(red: 199.0/255.0, green: 200.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            return view
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_DashboardVC_StoryboardID) as! BRD_Customer_DashboardVC
            vc.showCompleted = true
            self.navigationController?.pushViewController(vc, animated: true)
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
        
        let deleteAction = UIAlertAction(title: KCamera, style: .default, handler:
        {
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
    
}
extension BRD_Customer_ProfileViewController: UITextViewDelegate {
    // MARK:  UITextViewDelegate
    
//    func textViewDidChange(_ textView: UITextView) {
//        let size = textView.bounds.size
//        let newSize = textView.sizeThatFits(CGSize(width: size.width,
//                                                   height: CGFloat.greatestFiniteMagnitude))
//        
//        // Resize the cell only when cell's size is changed
//        if size.height != newSize.height {
//            UIView.setAnimationsEnabled(false)
//            self.tableView.reloadData()
//        }
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        self.objCustomerProfile?.bio = textView.text
//    }
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            return false
//        }
//        
//        return true
//    }
    
}
