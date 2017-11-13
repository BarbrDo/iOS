//
//  MapItVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 19/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader
import GoogleMaps

class MapItVC: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var gmsMapView: GMSMapView!
    
    var objAppointment: BarberConfirmAppointmentBO?
    
    var shopLatLong = [Double]()
    var customerLatLong = [Double]()
    
    var source: CLLocationCoordinate2D?
    var destination: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let header : NavigationBarWithTitle = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitle.self), owner: self, options: nil)![0] as! NavigationBarWithTitle
        header.btnBack.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        header.initWithTitle(title: "Map View")
        header.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        self.view.addSubview(header)
        
        self.gmsMapView.isMyLocationEnabled = true

        // Do any additional setup after loading the view.
        
        self.source = CLLocationCoordinate2D.init(latitude: customerLatLong[1], longitude: customerLatLong[0])
        self.destination = CLLocationCoordinate2D.init(latitude: BRDSingleton.sharedInstane.barberShopLatLong[1], longitude: BRDSingleton.sharedInstane.barberShopLatLong[0])
        
//        self.source = CLLocationCoordinate2D.init(latitude: 40.695067, longitude: -73.916545)
//        
//        self.destination = CLLocationCoordinate2D.init(latitude: 40.728378, longitude:  -73.882213)

        self.getPolylineRoute(from: self.source!, to: self.destination!)
        
        var yourArrayOfMarkers = [Any]()
        
        let marker1: ATGoogleMapsSelectiveMarker = ATGoogleMapsSelectiveMarker()
        marker1.position = self.source!
        let image: UIImage = UIImage(named: "ICON_MAPPIN")!
        marker1.icon = image
        marker1.map = self.gmsMapView
        
        yourArrayOfMarkers.append(marker1)
        
        let marker2: ATGoogleMapsSelectiveMarker = ATGoogleMapsSelectiveMarker()
        marker2.position = self.destination!
        marker2.icon = image
        marker2.map = self.gmsMapView
        yourArrayOfMarkers.append(marker2)
        
        let objCLLocation = self.source!
        self.gmsMapView.camera = GMSCameraPosition.camera(withTarget: objCLLocation, zoom: 10.0)
        self.gmsMapView.delegate = self as! GMSMapViewDelegate
        
        
        
        var bounds = GMSCoordinateBounds()
        for marker in yourArrayOfMarkers
        {
            bounds = bounds.includingCoordinate((marker as AnyObject).position)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
        self.gmsMapView.animate(with: update)
        
    }
    
    func btnBackAction(){
        self.navigationController?.popViewController(animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    
    // Pass your source and destination coordinates in this method.
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        let routes = json["routes"] as? [Any]
                        let overview_polyline = routes?[0] as?[String:Any]
                         let overview_polyline1 = overview_polyline?["overview_polyline"] as?[String:Any]
                        let polyString = overview_polyline1?["points"] as?String
                        
                        //Call this method to draw path on map
                        self.showPath(polyStr: polyString!)
                    }
                    
                }catch{
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = self.gmsMapView // Your map view
    }

    func fetchRoutes(){
        
        let urlString = String(format: "%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@", "https://maps.googleapis.com/maps/api/directions/json", customerLatLong[0], customerLatLong[1], BRDSingleton.sharedInstane.barberShopLatLong[0], BRDSingleton.sharedInstane.barberShopLatLong[1], KGoogleMaps)
        
        print(urlString)
        
        BRDAPI.fetchGoogleDirection("POST", inputParameter: nil, header: nil, urlString: urlString) { (response, responseMessage, statusCode, error) in
            
            
        }
    }
}
    


