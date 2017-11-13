//
//  CustomerMapViewVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 26/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftLoader
import GoogleMaps

class CustomerMapViewCell: UITableViewCell{
    
    @IBOutlet weak var viewBarberInfo: UIView!
    @IBOutlet weak var imageViewBarber: UIImageView!
    @IBOutlet weak var imageViewStar: UIImageView!
    @IBOutlet weak var lblBarberName: UILabel!
    @IBOutlet weak var lblBarberShopName: UILabel!
    @IBOutlet weak var lblBarberServices: UILabel!
    @IBOutlet weak var lblRatingValue: UILabel!
    @IBOutlet weak var btnRequest: UIButton!
    @IBOutlet weak var btnOffline: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnViewProfile: UIButton!
    
    
    override func awakeFromNib() {
        
        self.imageViewBarber.layer.borderWidth = 1.0
        self.imageViewBarber.layer.masksToBounds = false
        self.imageViewBarber.layer.borderColor = UIColor.white.cgColor
        self.imageViewBarber.layer.cornerRadius = self.imageViewBarber.frame.size.width/2
        self.imageViewBarber.clipsToBounds = true
    }
    
    
    func initWithData(obj: BarberListBO){
        
        
        if obj.picture != nil{
            let imagePath = KImagePathForServer + obj.picture!
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
            self.imageViewBarber.image = UIImage(named: "ICON_PROFILEIMAGE")
            self.activityIndicator.hidesWhenStopped = true
        }
        
        self.lblBarberName.text = obj.first_name!.capitalized + " " + String(obj.last_name!.characters.prefix(1)).capitalized
        
        var shopName = obj.barber_shops?.name
        shopName = shopName! + " (" + String(format: "%.0f", obj.distance!) + " mi" + ")"
        self.lblBarberShopName.text = shopName
        
        var services: String = ""
        
        for temp in obj.barber_services{
            services += temp.name! + ": $" + String(format: "%.02f", temp.price!)
            services += ", "
        }
        
        let endIndex = services.index(services.endIndex, offsetBy: -2)
        let truncated = services.substring(to: endIndex)
        
        self.lblBarberServices.text = truncated
        
        if obj.is_favourite == true{
            self.imageViewStar.isHidden = true
        }else{
            self.imageViewStar.isHidden = false
        }
        
        // Rating Value
        var ratingValue: String = "0"
        
        if obj.ratings?.count == 0{
            ratingValue = "0.0"
        }else{
            var countVal: Float = 0.0
            for temp in obj.ratings!{
                let ratObj = temp as BRD_RatingsBO
                countVal = countVal + ratObj.score!
            }
            let meanVal: Float = countVal / Float((obj.ratings?.count)!)
            ratingValue = String(format: "%.01f", meanVal)
            
            
        }
        self.lblRatingValue.text = ratingValue
        
        // Add condition for offine or o
        if obj.is_online == true{
            
            self.btnOffline.isHidden = true
            self.btnRequest.isHidden = false
            self.lblBarberShopName.isHidden = false
            self.lblBarberServices.isHidden = false
        }else{
            self.btnOffline.isHidden = false
            self.btnRequest.isHidden = true
            self.lblBarberShopName.isHidden = true
            self.lblBarberServices.isHidden = true
        }
        
        if obj.is_favourite == true{
            
            self.imageViewStar.isHidden = false
        }else{
            self.imageViewStar.isHidden = true
        }
    }
}


class CustomerMapViewVC: UIViewController {
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var tableviewBottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var mapsView: GMSMapView!
    var arrayTableView = [BarberListBO]()
    var arrayBarbers = [BarberListBO]()
    
     var currentLocationMarker = GMSMarker()

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.tableView.isHidden = true
        self.btnCurrentLocation.bringSubview(toFront: self.mapsView)
        self.view.addSubview(self.btnCurrentLocation)
        
        
        SwiftLoader.show(KLoading, animated: true)
        BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
         BRD_LocationManager.sharedLocationManger.delegate = self
        
        

        getAppointmentDetails()
        
        // Define identifier
        let notificationIdentifier: String = KNotificationReloadMaps
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(viewAllBarbers), name: NSNotification.Name(rawValue: notificationIdentifier), object: nil)
       
    }
    
    @IBAction func btnCurrentLocationAction(_ sender: UIButton){
        
        var myLocation: CLLocation!

        if UserDefaults.standard.object(forKey: "CurrentLocation") != nil{
            
            if let arr = UserDefaults.standard.object(forKey: "CurrentLocation") as? [Any]{
                
                if arr.count == 2{
//                    self.latitude = String(describing: arr[0])
//                    self.latitude = String(describing: arr[1])
                    
                   myLocation  = CLLocation(latitude: arr[0] as! CLLocationDegrees, longitude: arr[1] as! CLLocationDegrees)
                    currentLocationMarker.position = CLLocationCoordinate2DMake(arr[0] as! CLLocationDegrees, arr[1] as! CLLocationDegrees)
                    
                    currentLocationMarker.title = "Your Location"
                    currentLocationMarker.icon = UIImage(named: "UserLocation")
                    currentLocationMarker.map = self.mapsView
                    
                    //  let objCLLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                    self.mapsView.camera = GMSCameraPosition.camera(withTarget: currentLocationMarker.position, zoom: 14.0)
                    self.mapsView.animate(toLocation: myLocation.coordinate)
                    
                }
            }
            
        }else{
            SwiftLoader.show(KLoading, animated: true)
            BRD_LocationManager.sharedLocationManger.delegate = self
            BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       // map.showsUserLocation = true;
        
        
      viewAllBarbers()
        
    }
    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if self.mapsView != nil{
            self.mapsView.setNeedsDisplay()
            self.mapsView.setNeedsLayout()
        }
        
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
        
        self.view.updateConstraintsIfNeeded()

    }
    
    func callAgain(){
        self.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tableView.isHidden = true
        
    }
    
    
    private func showBarbersOnMap(arrayBarbers: [BarberListBO]){
        
        if self.mapsView != nil{
            self.mapsView.clear()
        }
        
        var atLeastOneUser: Bool? = false
        var yourArrayOfMarkers = [Any]()
        
        var arrayFav = [BarberListBO]()
        
        for (index, obj) in arrayBarbers.enumerated(){
            
            if obj.is_favourite == true && obj.is_online == false{
                continue
            }
            if let latlongArray = obj.barber_shops?.latLong {
                
                atLeastOneUser = true
                
                let marker1: ATGoogleMapsSelectiveMarker = ATGoogleMapsSelectiveMarker()
                marker1.position = CLLocationCoordinate2DMake(latlongArray[1], latlongArray[0])
                
                if obj.is_favourite == true{
                    arrayFav.append(obj)
                    continue
                }
                marker1.icon = UIImage(named: "ICON_MAPPIN_BLUE")!
                marker1.userData = obj
                marker1.index = index
                marker1.map = self.mapsView
                marker1.zIndex = 1
                yourArrayOfMarkers.append(marker1)
            }
        }
        
        for (index, theObj) in arrayFav.enumerated(){
            
            if let latlongArray = theObj.barber_shops?.latLong {
                
                let marker1: ATGoogleMapsSelectiveMarker = ATGoogleMapsSelectiveMarker()
                marker1.position = CLLocationCoordinate2DMake(latlongArray[1], latlongArray[0])
                
                marker1.icon = UIImage(named: "ICON_STAR")
                marker1.userData = theObj
                marker1.index = index
                marker1.map = self.mapsView
                marker1.zIndex = 9
                yourArrayOfMarkers.append(marker1)
            }
            
        }
        
//        let markerCurrentLocation: ATGoogleMapsSelectiveMarker = ATGoogleMapsSelectiveMarker()
//        markerCurrentLocation.position = CLLocationCoordinate2DMake(Double(BRDSingleton.sharedInstane.latitude!)!, Double(BRDSingleton.sharedInstane.longitude!)!)
//        
//        markerCurrentLocation.icon = UIImage(named: "UserLocation")
//        markerCurrentLocation.userData = nil
//        markerCurrentLocation.map = self.mapsView
//        markerCurrentLocation.zIndex = 1
//        yourArrayOfMarkers.append(markerCurrentLocation)
        
        
        
        
        // Current Location marker
        //creating a marker view
        currentLocationMarker.icon = UIImage(named: "UserLocation")
        currentLocationMarker.position = CLLocationCoordinate2D(latitude: Double(BRDSingleton.sharedInstane.latitude!)!, longitude: Double(BRDSingleton.sharedInstane.longitude!)!)
        currentLocationMarker.userData = nil
        currentLocationMarker.zIndex = 1
        currentLocationMarker.map = self.mapsView
        
        yourArrayOfMarkers.append(currentLocationMarker)
        
         self.mapsView.delegate = self
        
        if atLeastOneUser == false{
            SwiftLoader.show(KLoading, animated: true)
            let btn = UIButton.init()
            self.btnCurrentLocationAction(btn)
        }
        
        var bounds = GMSCoordinateBounds()
        for marker in yourArrayOfMarkers
        {
            bounds = bounds.includingCoordinate((marker as AnyObject).position)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
        self.mapsView.setMinZoom(0.0, maxZoom: 16.0)
        self.mapsView.animate(with: update)
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
            
            if arrayCompleted != nil && arrayCompleted?.count == 0 && arrayConfirm == nil{
                self.viewAllBarbers()
                return
            }
            
            if arrayConfirm != nil{
                
                    let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "BarberAcceptedRequestVC") as! BarberAcceptedRequestVC
                    vc.objBarberConfirmAppointment = arrayConfirm
                    self.navigationController?.pushViewController(vc, animated: false)
            }
            
            
            if arrayCompleted != nil{
               
                if (arrayCompleted?.count)! > 0{
                    let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "RateYourExperienceVC") as! RateYourExperienceVC
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
        
    }
    
    //MARK: API FOR SHOPS
    
    func viewAllBarbers(){
        
        if self.mapsView != nil{
            self.mapsView.clear()
        }
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
            
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        
        
        SwiftLoader.show("Fetching data...", animated: true)
        let urlString: String = KBaseURLString + KFetchAllBarbers
        BRDAPI.getAllBarber("GET", inputParameters: nil, header: header, urlString: urlString) { (arrayBarber, error) in
            
            SwiftLoader.hide()

                self.arrayBarbers.removeAll()
            
                if arrayBarber != nil{
                    self.arrayBarbers = arrayBarber!
                    self.showBarbersOnMap(arrayBarbers: self.arrayBarbers)
                }else{
                    SwiftLoader.show(KLoading, animated: true)
                    BRD_LocationManager.sharedLocationManger.delegate = self
                    BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
                }
        }
    }
    
    
    
    func iterateBarberLocation(array: [BarberListBO]){
        
        var finalArray = [BarberListBO]()
        for temp in array{
            
            var theLatLong = temp.barber_shops?.latLong
            
            for obj in finalArray{
                if (obj.barber_shops?.latLong)! == theLatLong!{
                    var tempLatlong: Double = theLatLong![0]
                    tempLatlong += 0.01
                    theLatLong?[0] = tempLatlong
                    temp.barber_shops?.latLong = theLatLong
                    finalArray.append(temp)
                }else{
                    finalArray.append(temp)
                }
            }

        }
        
        
    }
}

extension CustomerMapViewVC: GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
//    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
//        
//    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        self.tableView.isHidden = true
    }
    
    
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
    {
        
        if let barberObj =  marker.userData as? BarberListBO{
            
            // Calculating similar objects
            
            var tempArray = [BarberListBO]()
            
            for line in 0 ..< (self.arrayBarbers.count) {
                
                let obj = self.arrayBarbers[line] as! BarberListBO
                
                if (obj.barber_shops?.latLong)! == (barberObj.barber_shops?.latLong)! && obj.is_online == true{
                    tempArray.append(obj)
                }
            }
            
            self.arrayTableView.removeAll()
            self.arrayTableView = tempArray
            
            var index: Int = 0
            
            if (marker is ATGoogleMapsSelectiveMarker) {
                let parsedMarker: ATGoogleMapsSelectiveMarker? = (marker as? ATGoogleMapsSelectiveMarker)
                index = (parsedMarker?.index)!
            }
            
            var tableViewHeight: CGFloat = 0.0
            if self.arrayTableView.count <= 3{
                let vale: Double = Double(self.arrayTableView.count * 80)
                tableViewHeight = CGFloat(vale)
            }else{
                tableViewHeight = 240.0
            }
            
            self.tableviewBottomConstraint.constant = 0.0
            var frame = self.view.frame
            frame.size.height = UIScreen.main.bounds.size.height - 115.0
            self.view.frame = frame
            
            self.tableViewHeightConstraint.constant = tableViewHeight
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
        
        
        return true
    }
    
    func initWithData(obj: BarberListBO , flag : Bool?, index: Int)
    {
        /*
        self.viewBarberInfo.bringSubview(toFront: self.mapsView)
        self.viewBarberInfo.isHidden = false
        self.bottomConstraint.constant = 55.0
        self.view.addSubview(self.viewBarberInfo)
        
        if obj.picture != nil{
            let imagePath = KImagePathForServer + obj.picture!
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
            self.imageViewBarber.image = UIImage(named: "ICON_PROFILEIMAGE")
            self.activityIndicator.hidesWhenStopped = true
        }
        
        self.lblBarberName.text = obj.first_name! + " " + String(obj.last_name!.characters.prefix(1))

        
        var shopName = obj.barber_shops?.name
        shopName = shopName! + " (" + String(format: "%.02f", obj.distance!) + " mi" + ")"
        self.lblBarberShopName.text = shopName
        
        var services: String = ""
        for temp in obj.barber_services{
            services = temp.name! + ": $" + String(describing: temp.price!)
        }
        
        self.lblBarberServices.text = services
        
        if obj.is_favourite == true{
            self.imageViewStar.isHidden = true
        }else{
            self.imageViewStar.isHidden = false
        }
        
        // Rating Value
        var ratingValue: String = "0"
        
        if obj.ratings?.count == 0{
            ratingValue = "0"
        }else{
            var countVal: Float = 0.0
            for temp in obj.ratings!{
                let ratObj = temp as BRD_RatingsBO
                countVal = countVal + ratObj.score!
            }
            let meanVal: Float = countVal / Float((obj.ratings?.count)!)
            ratingValue = String(format: "%.01f", meanVal)
            
            
        }
        self.lblRatingValue.text = ratingValue

        // Add condition for offine or o
        if obj.is_online == true{
            
            self.btnOffline.isHidden = true
            self.btnRequest.isHidden = false
            self.lblBarberShopName.isHidden = false
            self.lblBarberServices.isHidden = false
        }else{
            self.btnOffline.isHidden = false
            self.btnRequest.isHidden = true
            self.lblBarberShopName.isHidden = true
            self.lblBarberServices.isHidden = true
        }
        
        if obj.is_favourite == true{
            
            self.imageViewStar.isHidden = false
        }else{
            self.imageViewStar.isHidden = true
        }*/

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
        
    }
    
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
       
    }
    
    func didDenyLocationAuthorization() {
    }
    
    func updateValue(address: String?){
        
    }
    
    func didFailToGetLocation() {
        
    }
    
    
//    @IBAction func btnRequestAction(sender: UIButton){
//        
//        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "RequestBarberVC") as! RequestBarberVC
//        vc.objBarberDetail = self.arrayBarbers[0]
//        self.navigationController?.pushViewController(vc, animated: false)
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTableView.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //mark
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerMapViewCell", for: indexPath) as? CustomerMapViewCell
        cell?.initWithData(obj: self.arrayTableView[indexPath.row])
        cell?.btnRequest.addTarget(self, action: #selector
            (btnRequestBarberAction(_:)), for: .touchUpInside)
        cell?.btnViewProfile.addTarget(self, action: #selector(btnViewProfileAction(_:)), for: .touchUpInside)
        return cell!
    }
    
    
    // Request Barber
    @IBAction func btnRequestBarberAction(_ sender: UIButton) {
        
        let indexPath = BRDUtility.indexPath(self.tableView, sender)
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RequestBarberVC") as! RequestBarberVC
        vc.objBarberDetail = self.arrayTableView[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    @IBAction func btnViewProfileAction(_ sender: UIButton){
        
        let indexPath = BRDUtility.indexPath(self.tableView, sender);
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "BRD_ViewProfileVC") as? BRD_ViewProfileVC {
            
            vc.objBarberInfo = self.arrayTableView[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.5
    }
    
}


extension CustomerMapViewVC: BRD_LocationManagerProtocol{
    func denyUpdateLocation() {
        
        
        switch BRD_LocationManager.sharedLocationManger.autorizationStatus {
            
        case .notDetermined, .restricted, .denied, .restricted:
            
            let alertController = UIAlertController(
                title: KAlertTitle,
                message: "BarbrDo want to access your location, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            alertController.addAction(openAction)
            
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        default:
            break
        }
    }

    
    //MARK: ASLocation Manager Delegate Methods
    
    func didUpdateLocation(location:CLLocation) {
        
        
        self.tableView.isHidden = true
        
        SwiftLoader.hide()
        
        currentLocationMarker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        currentLocationMarker.title = "Your Location"
        currentLocationMarker.icon = UIImage(named: "UserLocation")
        currentLocationMarker.map = self.mapsView
        
      //  let objCLLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        self.mapsView.camera = GMSCameraPosition.camera(withTarget: currentLocationMarker.position, zoom: 14.0)
        self.mapsView.animate(toLocation: location.coordinate)
        
        //viewAllBarbers()
        
        BRD_LocationManager.sharedLocationManger.locationManager.stopUpdatingLocation()
        
    }
}





