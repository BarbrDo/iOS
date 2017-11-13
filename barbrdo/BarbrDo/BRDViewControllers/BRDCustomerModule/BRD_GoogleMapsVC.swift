//
//  BRD_GoogleMapsVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 16/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftLoader


let KBRD_GoogleMapsVC_StoryboardID = "BRD_GoogleMapsVC_StoryboardID"
class ATGoogleMapsSelectiveMarker: GMSMarker {
    var index: Int = 0
    
}


class BRD_GoogleMapsVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewSearch: UIView!
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var lblBarberCount: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var shopImageView: UIImageView!
    
    @IBOutlet weak var viewNavigationBar: UIView!
    @IBOutlet weak var mapsView: GMSMapView!
    @IBOutlet weak var btnGoBackToShops: UIButton!
    var hiddenFlag : Bool?
    @IBOutlet weak var lblDistance: UILabel!
    var arrayViewShop :[BRD_ShopDataBO]  = [BRD_ShopDataBO]()
    var currentLocation  : CLLocation?
    var marker: GMSMarker = GMSMarker()
    var globalDetailTag : Int?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    
    var shouldHideButton: Bool? = false
    var shopName: String? = nil
    var shopLocation: String? = nil
    
    
    // This flag is used to check whether reqest has come from 
    // customer or barber
    var isRequestFromBarber: Bool? = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        let header = Bundle.main.loadNibNamed(String(describing: BRD_TopBar.self), owner: self, options: nil)![0] as? BRD_TopBar
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:75)
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        header?.btnProfile.addTarget(self, action: #selector(btnProfileAction), for: .touchUpInside)
        self.viewNavigationBar.addSubview(header!)
        
        var latitude1: Double = 0.0
        var longitude1: Double = 0.0
        
        if self.latitude == 0.0 && self.longitude == 0.0{
            for obj in self.arrayViewShop{
                
                if let latlongArray = obj.latLong {
                    if latlongArray.count > 1 {
                        latitude1 = (obj.latLong?[1])!
                    }
                    if latlongArray.count > 0 {
                        longitude1 = (obj.latLong?[0])!
                    }
                }
                break
            }
        }else{
            latitude1 = self.latitude
            longitude1 = self.longitude
        }
        
        
        for (index, obj) in self.arrayViewShop.enumerated(){
            var latitude: Double = 0.0
            var longitude: Double = 0.0
            
            if let latlongArray = obj.latLong {
                if latlongArray.count > 1 {
                    latitude = (obj.latLong?[1])!
                }
                if latlongArray.count > 0 {
                    longitude = (obj.latLong?[0])!
                }
                
                let marker1: ATGoogleMapsSelectiveMarker = ATGoogleMapsSelectiveMarker()
                marker1.position = CLLocationCoordinate2DMake(latitude, longitude)
                let image: UIImage = UIImage(named: "ICON_MAPPIN")!
                marker1.icon = image
                marker1.userData = obj
                marker1.index = index
                marker1.map = self.mapsView
            }
        }
        
        let objCLLocation = CLLocationCoordinate2DMake(latitude1, longitude1)
        self.mapsView.camera = GMSCameraPosition.camera(withTarget: objCLLocation, zoom: 10.0)
        self.mapsView.delegate = self
        self.btnGoBackToShops.isHidden = shouldHideButton!
    }
    
    func showPinsOnMap(arrayShops: [BRD_ShopDataBO]){
        
        self.mapsView.clear()
        
        if arrayShops.count == 0 {return}
        
        self.arrayViewShop.removeAll()
        self.arrayViewShop = arrayShops
        
        var latitude1: Double = 0.0
        var longitude1: Double = 0.0
        
        if self.latitude == 0.0 && self.longitude == 0.0{
            for obj in self.arrayViewShop{
                
                if let latlongArray = obj.latLong {
                    if latlongArray.count > 1 {
                        latitude1 = (obj.latLong?[1])!
                    }
                    if latlongArray.count > 0 {
                        longitude1 = (obj.latLong?[0])!
                    }
                }
                break
            }
        }else{
            latitude1 = self.latitude
            longitude1 = self.longitude
        }
        
        for (index, obj) in self.arrayViewShop.enumerated(){
            var latitude: Double = 0.0
            var longitude: Double = 0.0
            
            if let latlongArray = obj.latLong {
                if latlongArray.count > 1 {
                    latitude = (obj.latLong?[1])!
                }
                if latlongArray.count > 0 {
                    longitude = (obj.latLong?[0])!
                }
                
                let marker1: ATGoogleMapsSelectiveMarker = ATGoogleMapsSelectiveMarker()
                marker1.position = CLLocationCoordinate2DMake(latitude, longitude)
                let image: UIImage = UIImage(named: "ICON_MAPPIN")!
                marker1.icon = image
                marker1.userData = obj
                marker1.index = index
                marker1.map = self.mapsView
            }
        }
        
        let objCLLocation = CLLocationCoordinate2DMake(latitude1, longitude1)
        self.mapsView.camera = GMSCameraPosition.camera(withTarget: objCLLocation, zoom: 11.0)
        self.mapsView.delegate = self
    }
    
    func btnProfileAction() {
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_Profile_StoryboardID) as! BRD_Customer_ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnGoBackToShopsAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackToListAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDetailAction(_ sender: UIButton) {
        
        if let users = self.arrayViewShop[sender.tag] as? BRD_ShopDataBO
        {
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: BRDBarbrDetailVC.identifier()) as? BRDBarbrDetailVC {
                vc.shopDetail = users
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    @IBAction func showCurrentLocation(sender: UIButton){
        
        SwiftLoader.show(KLoading, animated: true)
        BRD_LocationManager.sharedLocationManger.delegate = self
        BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.searchUser(searchString: textField.text!)
        textField.resignFirstResponder()
        print("Should Return", textField.text ?? "Should return called")
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.searchUser(searchString: textField.text!)
        textField.resignFirstResponder()
        print("End Editing", textField.text ?? "Should End Editing Called \n")
        return true
    }
    
    
    func searchUser(searchString: String){
        
        SwiftLoader.show("Searching", animated: true)
        
        let urlString = KBaseURLString + KShopSearch + searchString
        let header = BRDSingleton.sharedInstane.getLatitudeLongitude()
        
        BRDAPI.searchShops("GET", inputParameter: nil, header: header!, urlString: urlString) { (response, array, status, error) in
            
            SwiftLoader.hide()
            self.mapsView.clear()
            self.userInfoView.isHidden = true
            
            if array != nil{
                self.showPinsOnMap(arrayShops: array!)
            }else{
                self.view.addSubview(BRDSingleton.showEmptyMessage("No Shop Found", view: self.view))
            }
        }
    }
}

extension BRD_GoogleMapsVC: BRD_LocationManagerProtocol{
    func denyUpdateLocation() {
        
    }

    
    //MARK: ASLocation Manager Delegate Methods
    
    func didUpdateLocation(location:CLLocation) {
        
        SwiftLoader.hide()
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        marker.title = "Your Location"
        marker.icon = UIImage(named: "ICON_MAPPIN_BLUE")
        marker.map = self.mapsView
        self.mapsView.animate(toLocation: location.coordinate)
        
    }
}

extension BRD_GoogleMapsVC: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        
    }
    
    
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
    {
        
        if let barberObj =  marker.userData as? BRD_ShopDataBO{
            marker.icon = UIImage(named: "ICON_MAPPIN_BLUE")
            
            var index: Int = 0
            
            if (marker is ATGoogleMapsSelectiveMarker) {
                let parsedMarker: ATGoogleMapsSelectiveMarker? = (marker as? ATGoogleMapsSelectiveMarker)
                //parsedMarker?.index = globalDetailTag!
                index = (parsedMarker?.index)!
            }
            
            self.initWithData(obj: barberObj, flag: self.hiddenFlag, index: index)
            
        }
        return true
    }
    
    func initWithData(obj: BRD_ShopDataBO , flag : Bool?, index: Int)
    {
        
        self.btnDetails.tag = index
        if(flag == false)
        {
            self.userInfoView.isHidden = true
            hiddenFlag = true
            self.view.bringSubview(toFront: self.btnGoBackToShops)
        }else{
            
            if self.isRequestFromBarber == true{
                self.btnDetails.isHidden = true
                
            }
            
            self.userInfoView.isHidden = false
            hiddenFlag = false
            self.view.sendSubview(toBack: self.btnGoBackToShops)
        }
        
        self.userInfoView.bringSubview(toFront: self.view)
        
        
        self.lblName.text = obj.name
        
        if obj.barbers != nil{
            self.lblBarberCount.text = String(describing: (obj.barbers!))
        }else{
            let bCount = obj.barberArray.count
            self.lblBarberCount.text = String(describing: bCount)
        }
        
        if obj.distance != nil{
            self.lblDistance.text =  String(format:"%.2f", obj.distance!) + " Miles"
            
        }else{
            self.lblDistance.text = "0 Miles"
        }
        
        if self.shouldHideButton == true{
            self.btnDetails.isHidden = true
        }
        
        
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        if marker.userData == nil{
            return
        }
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: BRDBarbrDetailVC.identifier()) as? BRDBarbrDetailVC {
            vc.shopDetail = marker.userData as? BRD_ShopDataBO
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        
        
    }
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
    }
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        
        print(mapView)
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print(mapView)
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        // To get lat longitude
        /*
         let latitude: Double = mapView.camera.target.latitude
         let longitude: Double = mapView.camera.target.longitude
         let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude);
         marker.position = center
         
         let cllocation: CLLocation =  CLLocation(latitude: latitude, longitude: longitude)
         self.reverseGeocodeCoordinate(coordinate: cllocation.coordinate)
         */
    }
    
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        //        let geocoder = GMSGeocoder()
        //        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
        //            if let address = response?.firstResult() {
        //
        //                print(address)
        //                let lines = address.lines
        //                if let completeAddress = lines?.joined(separator: "\n"){
        //                    print(completeAddress)
        //                }
        //            }
        //        }
    }
    
    func didDenyLocationAuthorization() {
    }
    
    func updateValue(address: String?){
        
    }
    
    func didFailToGetLocation() {
        
    }
    
}
