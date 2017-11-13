//
//  BRD_Barber_ShopListVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 26/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftLoader

let KBRD_Barber_ShopListVC_StoryboardID = "BRD_Barber_ShopListVC_StoryboardID"


class ShopInfoTableViewCell: UITableViewCell{
    
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblNumberofChairs: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "ShopInfoTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(obj: ShopChairsBO){
        
        // Set Profile Image
        self.activityIndicator.hidesWhenStopped = true
//        self.lblShopName.text = obj.name
//        
//        if obj.chairs != nil{
//            if let chairCount = obj.chairs.count as? Int{
//                self.lblNumberofChairs.text = String(describing: chairCount)
//            }
//        }
        
        
        if let objShop = obj.shopDetail{
            
            if objShop.name != nil{
                self.lblShopName.text = objShop.name
            }
            if objShop.distance != nil{
                self.lblDistance.text = String(format:"%.2f", objShop.distance!) + " Miles"
                   // String(describing: objShop.distance!)
            }
        }
        
//        if let chairs = obj.chairbarber{
//            self.lblNumberofChairs.text = String(describing: chairs.count)
//        }
        if let arrayChair = obj.chairbarber{
            var theArray = [Any]()
            for obj in arrayChair{
                if let chairObj = obj.chair{
                    if chairObj.availability != "closed" && chairObj.isActive == true{
                        theArray.append(obj)
                    }
                }
            }
            self.lblNumberofChairs.text = String(describing: theArray.count)
        }
    }
}

class BRD_Barber_ShopListVC: BRD_BaseViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtFieldSearch: UITextField!
    @IBOutlet weak var btnMapShop: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    
    var isMaplist:Bool = false
    var arrayTableView = [ShopChairsBO]()
    var duplicateArray = [ShopChairsBO]()
    
    var calendarSelectedDate: String? = nil
    
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var profileImageView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.isHidden = true
        //self.addTopNavigationBar()
        // Do any additional setup after loading the view.
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        tableView.addSubview(refreshControl)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getListofShops()
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        
        self.getListofShops()
        refreshControl.endRefreshing()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func MapButtonAction(_ sender: Any) {
        
        self.userInfoView.isHidden = true
        if isMaplist{
            isMaplist = false
            self.btnMapShop.setImage( UIImage.init(named: "ICON_MAP"), for: .normal)
            self.mapView.isHidden = true
            self.tableView.isHidden = false
            
        }
        else{
            
            isMaplist = true
            self.btnMapShop.setImage( UIImage.init(named: "ICON_LIST"), for: .normal)
            self.mapView.isHidden = false
            self.tableView.isHidden = true
        }
        
        
        for (index, obj) in self.arrayTableView.enumerated(){
            
            var latitude: Double = 0.0
            var longitude: Double = 0.0
            
            if let shopDetail = obj.shopDetail{
                if shopDetail.latitude == nil || shopDetail.longitude == nil{
                    return
                }
                
                latitude = shopDetail.latitude!
                longitude = shopDetail.longitude!
            }
            
            
            let marker1: ATGoogleMapsSelectiveMarker = ATGoogleMapsSelectiveMarker()
            marker1.position = CLLocationCoordinate2DMake(latitude, longitude)
            let image: UIImage = UIImage(named: "ICON_MAPPIN")!
            marker1.icon = image
            marker1.userData = obj.shopDetail
            marker1.index = index
            marker1.map = self.mapView
            
            let objCLLocation = CLLocationCoordinate2DMake(latitude, longitude)
            self.mapView.camera = GMSCameraPosition.camera(withTarget: objCLLocation, zoom: 10.0)
            self.mapView.delegate = self
        }
    }
    
    
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool{
        
        if let barberObj =  marker.userData as? BRD_ShopDataBO{
            marker.icon = UIImage(named: "ICON_MAPPIN_BLUE")
            
            var index: Int = 0
            
            if (marker is ATGoogleMapsSelectiveMarker) {
                let parsedMarker: ATGoogleMapsSelectiveMarker? = (marker as? ATGoogleMapsSelectiveMarker)
                //parsedMarker?.index = globalDetailTag!
                index = (parsedMarker?.index)!
            }
            self.initWithData(obj: barberObj, index: index)        }
        return true
    }
    
    
    func initWithData(obj: BRD_ShopDataBO , index: Int)
    {
        self.userInfoView.isHidden = false
        
        self.userInfoView.bringSubview(toFront: self.view)
        self.lblName.text = obj.name
        var address = ""
        
        if let shopDetails = obj.address {
            address = address + shopDetails + ", \n"
        }
        if let city = obj.city {
            address = address + city + ", "
        }
        if let state = obj.state {
            address = address + state
        }
        self.lblAddress.text =  address
    }
    
    
    @objc private func getListofShops(){
        
        let headers = BRDSingleton.sharedInstane.getLatitudeLongitude()
        if headers == nil{return}
        
        SwiftLoader.show(KLoading, animated: true)
        
        let urlString = KBaseURLString + kNewWebService
        
        BRDAPI.getListofShops("GET", inputParameters: nil, header: headers!, urlString: urlString) { (response, arrayServices, status, error) in
            print(response ?? "No Response")
            
            SwiftLoader.hide()
            if arrayServices != nil{
                if (arrayServices?.count)! > 0{
                    BRDSingleton.removeEmptyMessage(self.view)
                    self.arrayTableView = arrayServices!
                    self.duplicateArray = arrayServices!
                    self.tableView.reloadData()
                }else{
                    BRDSingleton.removeEmptyMessage(self.view)
                    self.arrayTableView = arrayServices!
                    self.duplicateArray = arrayServices!
                    self.tableView.reloadData()
                }
            }
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                })
                return
            }
        }
    }
    
    
    
    
}


extension BRD_Barber_ShopListVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ShopInfoTableViewCell.identifier()) as? ShopInfoTableViewCell
        if cell == nil {
            cell = ShopInfoTableViewCell(style: .value1, reuseIdentifier: ShopInfoTableViewCell.identifier())
        }
        
        cell?.initWithData(obj: self.arrayTableView[indexPath.row])
        cell?.btnDetails.tag = indexPath.row
        cell?.btnDetails.addTarget(self, action: #selector(BRD_Barber_ShopListVC.detailButtonClicked), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.arrayTableView[indexPath.row]
        
        print(obj.shopDetail?._id)
        print(obj.shopDetail?.name)
    }
    
    // MARK: - TableViewCell Button Action Method.
    
    func detailButtonClicked(sender:UIButton) {
        
        let indexPath = BRDUtility.indexPath(self.tableView, sender)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: KBRD_Barber_RequestDetailVC_StoryboardID) as! BRD_Barber_RequestDetailVC
        vc.objBarberShops = self.arrayTableView[indexPath.row].shopDetail
       /* let objShopChair = self.arrayTableView[indexPath.row]
        var theArray = [ChairBarberBO]()
        
        if objShopChair.chairbarber != nil{
            if let arrayChair = objShopChair.chairbarber{
                
                for obj in arrayChair{
                    if let chairObj = obj.chair{
                        if chairObj.availability != "closed" && chairObj.isActive == true{
                            theArray.append(obj)
                        }
                    }
                }
                vc.arrayTableView = theArray
            }
        }
        vc.objBarberShops = objShopChair.shopDetail*/
        if self.calendarSelectedDate != nil{
            vc.calendarSelectedDate = self.calendarSelectedDate!
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension BRD_Barber_ShopListVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == BRDRawStaticStrings.KEmptyString{
            textField.resignFirstResponder()
        }
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            print("searchText \(string)")
            
            if textField.text?.characters.count == 1{
                self.arrayTableView.removeAll()
                self.arrayTableView = self.duplicateArray
                self.tableView.reloadData()
                return true
            }
            
            let name: String = textField.text!
            let truncated = name.substring(to: name.index(before: name.endIndex))
            let filterArray = self.duplicateArray.filter { (t) -> Bool in
                return (t.shopDetail?.name?.lowercased().contains(truncated.lowercased()))!
            }
            
            self.arrayTableView.removeAll()
            self.arrayTableView = filterArray
            self.tableView.reloadData()
            return true
        }
        
        if string == BRDRawStaticStrings.KEmptyString{
            
            if self.txtFieldSearch.text == ""{
                print("Empty String")
                self.txtFieldSearch.resignFirstResponder()
                self.arrayTableView.removeAll()
                self.arrayTableView = self.duplicateArray
                self.tableView.reloadData()
            }
            
        }else{
            
            let str = textField.text! + string
            let filterArray = self.duplicateArray.filter { (t) -> Bool in
                return (t.shopDetail?.name?.lowercased().contains(str.lowercased()))!
            }
            
            self.arrayTableView.removeAll()
            self.arrayTableView = filterArray
            self.tableView.reloadData()
        }
        
        
        
        return true
    }
    
}
