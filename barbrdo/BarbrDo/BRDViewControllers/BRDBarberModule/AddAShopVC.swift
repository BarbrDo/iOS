//
//  AddAShopVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 17/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

class SearchResultShop: UITableViewCell{
    
    @IBOutlet weak var imageViewShop: UIImageView!
    @IBOutlet weak var lblShopName: UILabel!
    
    @IBOutlet weak var btnAddanAssociatedSHop: UIButton!
    
    
    func initWithData(objShopData: SearchShopsBO){
        
        var address = ""
        if let shopName = objShopData.name{
            address = shopName + "\n"
        }
        if let shopDetails = objShopData.address {
            address = address + shopDetails + ", \n"
        }
        if let city = objShopData.city {
            address = address + city + ", "
        }
        if let state = objShopData.state {
            address = address + state
        }
        self.lblShopName.text = address
        
    }
    
}

class AddAShopCell: UITableViewCell{
    
    @IBOutlet weak var txtShopName: UITextField!
    @IBOutlet weak var txtStreetAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZipCode: UITextField!
    
    @IBOutlet weak var btnSearch: UIButton!
  
    
    
    override func awakeFromNib() {
        
        self.txtShopName.layer.borderWidth = 1.0
        self.txtShopName.layer.borderColor = kNavigationBarColor.cgColor
        
        self.txtCity.layer.borderWidth = 1.0
        self.txtCity.layer.borderColor = kNavigationBarColor.cgColor

//        self.txtState.layer.borderWidth = 1.0
//        self.txtState.layer.borderColor = kNavigationBarColor.cgColor

        self.txtZipCode.layer.borderWidth = 1.0
        self.txtZipCode.layer.borderColor = kNavigationBarColor.cgColor
        
        self.txtStreetAddress.layer.borderWidth = 1.0
        self.txtStreetAddress.layer.borderColor = kNavigationBarColor.cgColor
        
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 10))
//        self.txtState.leftViewMode = .always
//        self.txtState.leftView = paddingView
        
//        let paddingView  = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 20))
//        //Change your required space instaed of 5.
//        self.txtState.leftView = paddingView
//        self.txtState.leftViewMode = UITextFieldViewMode.always

    }
}

class AddAShopVC: BRD_BaseViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddAShop: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var barButtonDone: UIBarButtonItem!
    @IBOutlet weak var barButtonCance: UIBarButtonItem!
    
    @IBOutlet weak var tableViewTopConstaint: NSLayoutConstraint!
    var arrayTableView = [SearchShopsBO]()
    var firstCell: AddAShopCell!
    var arrayPickerView = [StatesBO]()
    
    var latitude: Float?
    var longitude: Float?
    var streetAddress: String?
    var address: String?
    var selectedState: StatesBO? = nil
    
    var googlePlacePredictionArray = [GooglePlacesBO]()
    
    var strTextField: String = ""
    
    @IBOutlet weak var tableViewPlaces: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //self.addTopNavigationBar(title: "Add a Shop")
        
        self.arrayTableView.insert(SearchShopsBO.init(), at: 0)
        self.btnAddAShop.isHidden = true
        
        let header : NavigationBarWithTitleAndBack = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitleAndBack.self), owner: self, options: nil)![0] as! NavigationBarWithTitleAndBack
        header.btnBack.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        header.btnProfile.addTarget(self, action: #selector(btnProfileMenu), for: .touchUpInside)
        header.initWithTitle(title: "Add a Shop")
        header.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        self.view.addSubview(header)
        
    }
    func btnBackAction(){
        
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func btnProfileMenu(){
        
        let storyboard = UIStoryboard(name:"Barber", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_Profile_StoryboardID) as! BRD_Barber_ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getAllState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let txtFieldState = firstCell.txtState
        
        if textField == txtFieldState{
            textField.resignFirstResponder()
//            self.showPicker()
//            self.pickerView.reloadAllComponents()
            self.strTextField = "State"
            
            self.tableViewTopConstaint.constant = 240.0
            self.tableViewPlaces.isHidden = false
            self.tableViewPlaces.reloadData()
        }else if textField == firstCell.txtStreetAddress{
            
            self.strTextField = "Address"
            self.tableViewTopConstaint.constant = 169.0
            self.tableViewPlaces.reloadData()
            
        }
    }


}

extension AddAShopVC: UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewPlaces{
            
            if self.strTextField == "Address"{
                return self.googlePlacePredictionArray.count
            }else if self.strTextField == "State"{
                return self.arrayPickerView.count
            }
        }
        return  self.arrayTableView.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableViewPlaces{
            
            if self.strTextField == "Address"{
            
                let obj: GooglePlacesBO = self.googlePlacePredictionArray[indexPath.row]
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
                
                if !(cell != nil) {
                    cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
                }
                
                cell!.textLabel?.text = obj.placeName
                cell?.textLabel?.textAlignment = NSTextAlignment.center
                cell?.textLabel?.font = UIFont.init(name: "Berlin Sans FB", size: 12.0)
                return cell!
            }else if self.strTextField == "State"{
              
                let objState = self.arrayPickerView[indexPath.row]
                var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
                
                if !(cell != nil) {
                    cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
                }
                cell!.textLabel?.text = objState.name!
                cell?.textLabel?.textAlignment = NSTextAlignment.center
                cell?.textLabel?.font = UIFont.init(name: "Berlin Sans FB", size: 12.0)
                return cell!
            }
            
            
        }else{
            
            if indexPath.row == 0 {
            
                firstCell = tableView.dequeueReusableCell(withIdentifier: "AddAShopCell", for: indexPath) as? AddAShopCell
                
                //        cell?.initWithData(objShopData: self.arrayTableView[indexPath.row])
                firstCell?.btnSearch.addTarget(self, action: #selector
                 (searchForShop(_:)), for: .touchUpInside)
                return firstCell!
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultShop", for: indexPath) as? SearchResultShop
                 cell?.initWithData(objShopData: self.arrayTableView[indexPath.row])
                cell?.btnAddanAssociatedSHop.addTarget(self, action: #selector(btnAddanAssociatedShopAction(_ :)), for: .touchUpInside)
                return cell!
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewPlaces{
            
             self.tableViewPlaces.isHidden = true
            
            if self.strTextField == "Address"{
            
                let obj: GooglePlacesBO = self.googlePlacePredictionArray[indexPath.row]
                self.streetAddress = obj.placeName
                self.callGoogleAPIforLatLong(placeId: obj.placeID!)
                
                firstCell.txtCity.text = obj.placeName
            }else if self.strTextField == "State"{
                
                let objState = self.arrayPickerView[indexPath.row]
                selectedState = objState
                firstCell.txtState.text = "  " + objState.name!
                
            }
        }
    }
    
    
    func btnAddanAssociatedShopAction(_ sender: UIButton){
        //KAddAssociatedSHop
        
//        {
//            "shops": [
//            {
//            "shop_id": "598197fd8217767453518644"
//            },
//            {
//            "shop_id": "59885a5b0aba2408d1d9ef40"
//            }
//            ]
//        }
        
        let indexPath = BRDUtility.indexPath(self.tableView, sender)
        let obj = self.arrayTableView[indexPath.row]
        
        
        SwiftLoader.show(KLoading, animated: true)
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()!
        if header ==  nil{return}
        
        let inputParameters = ["shop_id": obj._id] as [String: Any]
        print(inputParameters)
        var tempArray = [Any]()
        tempArray.append(inputParameters)
        
        let finalDict = ["shops": tempArray]
        
        print(finalDict)
        let urlString = KBaseURLString + KAddAssociatedSHop
        
        print(urlString)
        
        BRDAPI.makeChairAsDefault("POST", inputParameters: finalDict, header: header!, urlString: urlString) { (response, responseMessage, statusCode, error) in
            
            SwiftLoader.hide()
            
            if statusCode == 200 {
                
                // SUCCESS CASE
                self.navigationController?.popViewController(animated: true)
                
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
            }
            
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                    
                })
                return
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if tableView == tableViewPlaces{
            return 25
        }
        else{
            if indexPath.row == 0{
                return 218.0
            }else{
                return 80.5
            }
            
        }
        return 0
    }
    
    
    
    // Request Barber
    @IBAction func btnRequestBarberAction(_ sender: UIButton) {
        
        
    }
    
    @IBAction func addAShop(_ sender: UIButton){
        
        
        let shopName = firstCell.txtShopName.text
        let city = firstCell.txtCity.text
        let state = firstCell.txtState.text
        let zipCode = firstCell.txtZipCode.text
        
        if selectedState != nil{
            let state = selectedState?.abbreviation
        }
        
        if (shopName?.isEmpty)!{
            
            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Please enter shop name", onViewController: self, returnBlock: { (clickedIN) in})
            return
        }
        if (city?.isEmpty)!{
            
            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Please enter city", onViewController: self, returnBlock: { (clickedIN) in})
            return
        }
        if (state?.isEmpty)!{
            
            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Please enter state", onViewController: self, returnBlock: { (clickedIN) in})
            return
        }
        if (zipCode?.isEmpty)!{
            
            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Please enter zip code", onViewController: self, returnBlock: { (clickedIN) in})
            return
        }
        
        //KShopRequest
        
        SwiftLoader.show(KLoading, animated: true)
        let header = BRDSingleton.sharedInstane.getHeaders()
        let userObj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        
        
        let inputParameters : [String: Any] =
            ["name": shopName,
             "city": city,
             "state": state,
             "zip": zipCode,
             "latitude": self.latitude,
             "longitude": self.longitude,
             "address":self.streetAddress,
             "street_address": self.streetAddress]
        
        print(inputParameters)
        let urlString = KBaseURLString + KShopRequest
    
        
        
        BRDAPI.addANewShop("POST", inputParameter: inputParameters, header: header!, urlString: urlString, completionHandler: { (response, responsString, status, error) in
            
            SwiftLoader.hide()
            
            if status == 200{
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Shop sent for approval", onViewController: self, returnBlock: { (clickedIN) in
                    
                    self.firstCell.txtShopName.text = ""
                    self.firstCell.txtState.text = ""
                    self.firstCell.txtZipCode.text = ""
                    self.firstCell.txtCity.text = ""
                    
                    self.btnAddAShop.isHidden = true
                    
                    self.navigationController?.popViewController(animated: true)
                })
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: responsString, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
            }
        })
    }






    func searchForShop(_ sender: UIButton){
       
         //let cell = self.tableView.dequeueReusableCell(withIdentifier: "AddAShopCell", for: indexPath) as? AddAShopCell
        
        let shopName = firstCell.txtShopName.text!
        let city = firstCell.txtCity.text!
        let state = firstCell.txtState.text!
        let zip = firstCell.txtZipCode.text!
        /*
        if shopName.isEmpty == true{
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Please enter shop name", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        if city.isEmpty == true{
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Please enter city", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        if state.isEmpty == true{
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Please enter shop name", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        if zip.isEmpty == true{
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Please enter zip code", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }*/
        
        if ((city.isEmpty || state.isEmpty) && zip.isEmpty) {
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Please enter required fields", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        
        var urlString = KBaseURLString
        urlString = KBaseURLString + kGetAllShop + "?name=" + shopName + "&state=" + state + "&zip=" + zip + "&city=" + city
        
        print(urlString)
       
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
            
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        
        SwiftLoader.show("Fetching data...", animated: true)
        
        BRDAPI.searchAllShop("GET", inputParameters: nil, header: header, urlString: urlString.removingPercentEncoding!) { (arrayShops, error) in
            
            
            SwiftLoader.hide()
            if arrayShops?.count == 0{
                self.btnAddAShop.isHidden = false
                self.arrayTableView.removeAll()
                self.arrayTableView.insert(SearchShopsBO.init(), at: 0)
                self.tableView.reloadData()
                
            }else if arrayShops != nil{
                self.arrayTableView.removeAll()
                self.arrayTableView = arrayShops!
                self.arrayTableView.insert(SearchShopsBO.init(), at: 0)
                self.tableView.reloadData()
            }
            
        }
    }
    
    
    func getAllState(){
       
        let urlString = KBaseURLString + KGetAllStates
         let header = BRDSingleton.sharedInstane.getHeaders()
        SwiftLoader.show(KLoading, animated: true)
        
        BRDAPI.getAllState("GET", inputParameters: nil, header: header, urlString: urlString) { (arrayStates, error) in
            
            SwiftLoader.hide()
            if arrayStates != nil{
            
                if (arrayStates?.count)! > 0 {
                    self.arrayPickerView.removeAll()
                    self.arrayPickerView = arrayStates!
                }
            }
            else{
                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: error.debugDescription, onViewController: self, returnBlock: { (clickedIN) in
                })
                return
            }
            
        }
        
    }
    
    // UIPickerView
    
    @IBAction func btnToolBarAction(_ sender: UIBarButtonItem) {
        
        self.toolBar.isHidden = true
        self.pickerView.isHidden = true
        
        switch sender.tag {
        case 101:
            break
        case 102:
            break
        default:
            break
        }
        
    }
    
    
    func showPicker(){
        
        self.view.resignFirstResponder()
        self.tableViewPlaces.isHidden = true
        
        self.pickerView.isHidden = false
        self.toolBar.isHidden = false
        self.pickerView.reloadAllComponents()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrayPickerView.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let objState = self.arrayPickerView[row]
        let title: String = objState.name!
        return title
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let objState = self.arrayPickerView[row]
        selectedState = objState
        firstCell.txtState.text = objState.name!
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
//        if textField == firstCell.txtState{
//            self.pickerView.isHidden = false
//            self.toolBar.isHidden = false
//        }else{
//            self.pickerView.isHidden = true
//            self.toolBar.isHidden = true
//        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField ==  firstCell.txtStreetAddress{
            
            let txt = textField.text! + string
            if txt.characters.count == 0{
                self.tableViewPlaces.isHidden = true
            }else if txt.characters.count > 2{
                DispatchQueue.main.async {
                    self.callGoogleAPIForAddress()
                    
                }
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField ==  firstCell.txtCity{
            self.tableViewPlaces.isHidden = true
        }

    }
    
    //Mark -
    func callGoogleAPIforLatLong(placeId : String){
        SwiftLoader.show("Loading", animated: true)
        
        BRDAPI.latLongFromGooglAPI(googleAPIKey: KGooglePlaceAPIKey, placeId: placeId){ (sucess, response) in
            
            if sucess == false{
                DispatchQueue.main.async(){
                    SwiftLoader.hide()
                    if let data = response.data(using: .utf8){
                        print(data)
                        /*if (bizObject.getResponseDictionary(data) as? [String: AnyObject]) != nil{
                            let alert = UIAlertController(title: APPDETAILS.appName, message:"Please try again", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }*/
                    }
                }
                
            }else{
                DispatchQueue.main.async(){
                    SwiftLoader.hide()
                    if let data = response.data(using: .utf8){
                        
                        print(data)
                       if let result = BRDAPI.getResponseDictionary(data) as? [String: AnyObject]{
                            //Mark - Saving in models
                            if(result.count>0){
                                print(result["formatted_address"])
                               
                                if let resultDict = result["result"] as? NSDictionary{
                                    
                                    
                                    if let arrayComp = resultDict["address_components"] as? [Any]{
                                        
//                                        if arrayComp != nil && arrayComp[0] != nil{
//                                            if let stateDIct = arrayComp[0] as? [String: Any]{
//                                                self.firstCell.txtCity.text = stateDIct["long_name"] as! String
//                                                self.firstCell.txtState.text = stateDIct["short_name"] as! String
//                                            }
//                                            
//                                        }
                                        
                                        var strStreetAddress: String = ""
                                        for dict in arrayComp{
                                            if let theDict = dict as? [String: Any]{
                                                if let arrayVal = theDict["types"] as? [Any]{
                                                    
                                                    
                                                    if String(describing: arrayVal[0]) == "street_number"{
                                                        strStreetAddress = (theDict["long_name"] as? String)! + " "
                                                    }else
                                                    if String(describing: arrayVal[0]) == "route"{
                                                        strStreetAddress = strStreetAddress + " " + (theDict["long_name"] as? String)! + " "
                                                    }else
                                                    if String(describing: arrayVal[0]) == "neighborhood"{
                                                        strStreetAddress = strStreetAddress + " " + (theDict["long_name"] as? String)!
                                                    }else
                                                    if String(describing: arrayVal[0]) == "locality" ||
                                                    String(describing: arrayVal[0]) == "administrative_area_level_3" && strStreetAddress == ""{
                                                    self.firstCell.txtStreetAddress.text = theDict["long_name"] as? String
                                                    }else
                                                    if String(describing: arrayVal[0]) == "administrative_area_level_2"{
                                                        self.firstCell.txtCity.text = theDict["long_name"] as? String
                                                    }else
                                                    if String(describing: arrayVal[0]) == "administrative_area_level_1"{
                                                        self.searchForLongName(stateName: (theDict["long_name"] as? String)!)
                                                    }else 
                                                    if String(describing: arrayVal[0]) == "postal_code"{
                                                        if let numberZip = theDict["long_name"] as? String{
                                                            self.firstCell.txtZipCode.text = numberZip
                                                        }else if let numberZip1 = theDict["long_name"] as? Int{
                                                            self.firstCell.txtZipCode.text = String(describing: numberZip1)
                                                        }
                                                    }
                                                    
                                                    self.firstCell.txtStreetAddress.text = strStreetAddress
                                                    
                                            }
                                           
                                        }
                                        
                                        
                                    }
                                    
                                     self.streetAddress = resultDict["formatted_address"] as? String
                                    if(resultDict.count>0){
                                        if let geometryDict = resultDict["geometry"] as? NSDictionary{
                                            if(geometryDict.count>0){
                                                if let locationDict = geometryDict["location"] as? NSDictionary{
                                                    
                                                    self.latitude = locationDict.value(forKey: "lat") as? Float ?? 0.0
                                                    self.longitude = locationDict.value(forKey: "lng") as? Float ?? 0.0
                                                    
                                                }
                                                
                                            }
                                        }
                                    }
                                        
                                        self.dynamicSearching()
                                        
                                        
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    }
    
    //Mark - Google API for address featching
    func callGoogleAPIForAddress(){
        //Mark -
        
        BRDAPI.googleAddressFromAPI(googleAPIKey: KGooglePlaceAPIKey, inputText: firstCell.txtStreetAddress.text!){ (sucess, response) in
            
            if sucess == false{
                DispatchQueue.main.async(){
                    //self.appDelegate.inActivateView(self.view)
                    SwiftLoader.hide()
                    if let data = response.data(using: .utf8){
                        print(data)
                        if (BRDAPI.getResponseDictionary(data) as? [String: AnyObject]) != nil{
                        }
                    }
                }
                
            }else{
                DispatchQueue.main.async(){
                    SwiftLoader.hide()
                    if let data = response.data(using: .utf8){
                        
                        print(data)
                        if let result = BRDAPI.getResponseDictionary(data) as? [String: AnyObject]{
                            
                            //Mark - Saving in models
                            if(result.count>0){
                                if let predictionaryArray = result["predictions"] as? NSArray{
                                    
                                    self.googlePlacePredictionArray.removeAll()
                                    
                                    if(predictionaryArray.count>0){
                                        //self.googlePlacePredictionArray.removeAllObjects()
                                        
                                        for dict in predictionaryArray{
                                            let dictionary: [String:AnyObject] = (dict as? [String:AnyObject])!
                                            
                                            var description = ""
                                            var placeid = ""
                                            print( dictionary["description"])
                                            if let descrip = dictionary["description"] as? String{
                                                description = descrip
                                                if let id = dictionary["place_id"] as? String{
                                                    placeid = id
                                                }
                                                let SaveDataDict = ["description":description,"placeId":placeid]
                                                
                                                print(SaveDataDict)
                                                let obj = GooglePlacesBO.init(dictionary: SaveDataDict as NSDictionary)
                                                self.googlePlacePredictionArray.append(obj!)
                                            }
                                        }
                                        self.tableViewPlaces.isHidden = false
                                        self.tableViewPlaces.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func dynamicSearching(){
        
        let shopName = firstCell.txtShopName.text!
        let city = firstCell.txtCity.text!
        let state = firstCell.txtState.text!
        let zip = firstCell.txtZipCode.text!
        
        var urlString = KBaseURLString
        urlString = KBaseURLString + kGetAllShop + "?name=" + shopName + "&state=" + state + "&zip=" + zip + "&city=" + city
        
        print(urlString)
        
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
            
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        
        SwiftLoader.show("Fetching data...", animated: true)
        
        BRDAPI.searchAllShop("GET", inputParameters: nil, header: header, urlString: urlString.removingPercentEncoding!) { (arrayShops, error) in
            
            
            SwiftLoader.hide()
            if arrayShops?.count == 0{
                self.btnAddAShop.isHidden = false
                self.arrayTableView.removeAll()
                self.arrayTableView.insert(SearchShopsBO.init(), at: 0)
                self.tableView.reloadData()
                
            }else if arrayShops != nil{
                self.arrayTableView.removeAll()
                self.arrayTableView = arrayShops!
                self.arrayTableView.insert(SearchShopsBO.init(), at: 0)
                self.tableView.reloadData()
            }
            
        }
    }
    
    
    func searchForLongName(stateName: String){
        
        for obj in self.arrayPickerView{
            if obj.name == stateName{
                selectedState = obj
                print(obj._id)
                firstCell.txtState.text = obj.name
                return
            }
        }
    }
}
