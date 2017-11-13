//
//  BRD_LocationManager.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 05/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import CoreLocation


protocol BRD_LocationManagerProtocol {
    
    func didUpdateLocation(location:CLLocation)
    func denyUpdateLocation()
    
//    func didDenyLocationAuthorization()
//    func didFailToGetLocation()
}

class BRD_LocationManager: NSObject {
    
    static let sharedLocationManger = BRD_LocationManager()
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var delegate : BRD_LocationManagerProtocol?
    var autorizationStatus:CLAuthorizationStatus = .denied
    
    private override init() {
        super.init()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.delegate = self
    }
  
}

extension BRD_LocationManager : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
        BRDSingleton.sharedInstane.location = locations
        
        BRDSingleton.sharedInstane.latitude = String(format:"%f", (currentLocation?.coordinate.latitude)!)
        BRDSingleton.sharedInstane.longitude = String(format:"%f", (currentLocation?.coordinate.longitude)!)
        
        let userLocation: [Double] = [(locations.last?.coordinate.latitude)!,
                                      (locations.last?.coordinate.longitude)!]
        
        UserDefaults.standard.set(userLocation, forKey: "CurrentLocation")
        UserDefaults.standard.synchronize()
        
        self.delegate?.didUpdateLocation(location:locations.last!)
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.autorizationStatus = status
//        switch status.rawValue {
//            
//        case .notDetermined || .restricted || .denied:
//            
//            self.delegate?.denyUpdateLocation()
//            
//            break
//        default:
//            break
//        }

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //self.delegate?.didFailToGetLocation()
     }
    
}
