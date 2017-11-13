//
//  BarberIncomingRequestVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 11/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import CircleProgressView
import AVFoundation
import GoogleMaps

class BarberIncomingRequestCell: UITableViewCell{
    
    @IBOutlet weak var lblTitle: UILabel!
    
    func initWithData(obj: BRD_ServicesBO){
        
        self.lblTitle.text = obj.name! + " .. $" + String(format: "%.02f", obj.price!)
    }
}


class BarberIncomingRequestVC: BRD_BaseViewController {
    
    @IBOutlet var circleProgressView: CircleProgressView!
    @IBOutlet var imageViewMap: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblBeThere: UILabel!
    @IBOutlet var btnDecline: UIButton!
    @IBOutlet var btnAccept: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    
    var player: AVAudioPlayer?
    var notificationDictionary: [String: Any]? = nil
    var objCustomerNotification : CustomerRequestToBarberBO? = nil
    // For Circular timer
    var sdValue: Float = 0.01
    var timer = Timer()
    var timerPlayer = Timer()
    var arrayTableView = [BRD_ServicesBO]()
    
    var source: CLLocationCoordinate2D?
    var destination: CLLocationCoordinate2D?

    
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        
        let currentValue = Int(sender.value)
        let btn = UIButton.init()
        
        if currentValue <= 10{
            // decline
            btn.tag = 402
            self.btnAcceptRejectAction(sender: btn)
        }
        else if currentValue >= 90{
            // Accept
            btn.tag = 401
            self.btnAcceptRejectAction(sender: btn)
        }else{
            self.slider.value = 50
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // slider.setThumbImage(yourImageThatHasBeenResized), forState: state)
//        let thumbImage = UIImage(named: "ICON_SHOPLOGO")
//        slider.setThumbImage(thumbImage, for: .normal)

        self.imageViewMap.layer.borderWidth = 2.0
        self.imageViewMap.layer.masksToBounds = false
        self.imageViewMap.layer.borderColor = KBlueShade.cgColor
        self.imageViewMap.layer.cornerRadius = self.imageViewMap.frame.size.width/2
        self.imageViewMap.clipsToBounds = true
        self.imageViewMap.alpha = 0.5
        
        
        if self.objCustomerNotification != nil{
            self.arrayTableView = (self.objCustomerNotification?.services)!
            
            
            let appointmentTime = Date.dateFromString((objCustomerNotification?.appointment_date)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
            
           let appointmentDte =  Date.dateFromString((objCustomerNotification?.appointment_date)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
            
            let calendar = Calendar.current
            let finalArrivalDate
            = calendar.date(byAdding: .minute, value: Int((self.objCustomerNotification?.reach_in)!)!, to: appointmentDte!)
            
            let gDateStr = Date.stringFromDate(finalArrivalDate!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
            
            let time = Date.convert(gDateStr, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.TimeFormat.hh_mm_a)
            
            
            
            self.lblBeThere.text = "Customer will be there at " + time
        }
        let appointmentDate = Date.dateFromString((self.objCustomerNotification?.appointment_date)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
        let reachIN = Int((self.objCustomerNotification?.reach_in)!)
        
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: reachIN!, to: appointmentDate!)
        print(date)

        self.timer = Timer.scheduledTimer(timeInterval:1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        //timer.fire()
        
        
        // Appointment Cancel by Customer
        NotificationCenter.default.addObserver(self, selector: #selector(BarberIncomingRequestVC.appointmentCancelByCustomer), name: NSNotification.Name(rawValue: KCustomerCancelAppointmentNot), object: nil)
        
        self.source = CLLocationCoordinate2D.init(latitude: (self.objCustomerNotification?.customer_lat_long?[1])!, longitude: (self.objCustomerNotification?.customer_lat_long?[0])!)
        self.destination = CLLocationCoordinate2D.init(latitude: (self.objCustomerNotification?.shop_lat_long?[1])!, longitude: (self.objCustomerNotification?.shop_lat_long?[0])!)
        
        self.getPolylineRoute(from: self.source!, to: self.destination!)

    }
    
    
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
                        if (routes?.count)! > 0{
                            let overview_polyline = routes?[0] as?[String:Any]
                            let overview_polyline1 = overview_polyline?["overview_polyline"] as?[String:Any]
                            let polyString = overview_polyline1?["points"] as?String
                            
                            //Call this method to draw path on map
                            self.getStaticMapImage(polyString: polyString!)
                        }
                        
                    }
                }catch{
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    
    func getStaticMapImage(polyString: String){
        
        let urlString = String(format:"https://maps.googleapis.com/maps/api/staticmap?size=200x200&&path=enc:"
        + polyString + "&key=" + KGooglePlaceAPIKey)
        
        let escapedString = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        if let url = NSURL(string: escapedString!){
            
            let task = session.dataTask(with: url as URL, completionHandler: {data, response, error in
                
                if let err = error {
                    print("Error: \(err)")
                    return
                }
                
                if let http = response as? HTTPURLResponse {
                    if http.statusCode == 200 {
                        let downloadedImage = UIImage(data: data!)
                        DispatchQueue.main.async(execute: {
                            self.imageViewMap.image = downloadedImage
                        })
                    }
                }
            })
            task.resume()
        }
    }
    
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        //contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.imageViewMap.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    
    func appointmentCancelByCustomer(notification: NSNotification){
        
        
       // self.timerPlayer.invalidate()
        player?.stop()
        self.timer.invalidate()
        
        
        _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Customer Cancel the Appointment", onViewController: self, returnBlock: { (clickedIN) in
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    func timerAction(){
        
        sdValue += 0.0166
        print(sdValue)
        //        let ttValue = Double(sdValue/100)
        
        self.circleProgressView.progress = Double(sdValue)
        
        if sdValue > 0.90{
            self.circleProgressView.trackFillColor = UIColor.red
            self.circleProgressView.tintColor = UIColor.red
        }
        
        if sdValue >= 1.00{
            
            self.timer.invalidate()
            self.pushView()
        }
    }
    
    func pushView(){
        //self.timerPlayer.invalidate()
        player?.stop()
        self.timer.invalidate()

        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        playSound()
       //self.timerPlayer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.playSound), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        //self.timerPlayer.invalidate()
        player?.stop()
        self.timer.invalidate()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Request", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.numberOfLoops = 12
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func btnAcceptRejectAction(sender: UIButton){
        
        //self.timerPlayer.invalidate()
        
        player?.stop()
        self.timer.invalidate()
    
        switch(sender.tag)
        {
            case 401:
                // Accept
                let appointmentID = self.objCustomerNotification?._id
                let urlString = KBaseURLString + KAcceptCustomerRequest + appointmentID!
                let header = BRDSingleton.sharedInstane.getHeaders()
                
                if header == nil{return}
                
                let appointmentDate = Date.dateFromString((self.objCustomerNotification?.appointment_date)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                let reachIN = Int((self.objCustomerNotification?.reach_in)!)
                
                let calendar = Calendar.current
                let date = calendar.date(byAdding: .minute, value: reachIN!, to: appointmentDate!)
                let dateStr = Date.stringFromDate(date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
                
                let inputParameter: [String: Any] = ["appointment_date": dateStr]
                
                
                BRDAPI.barberAcceptRequest("PUT", inputParameter: inputParameter, header: header!, urlString: urlString, completionHandler: { (reponse, responseString, status, error) in
                    
                    
                    if status == 200{
                        self.navigationController?.popViewController(animated: true)
                        
                    }else{
                        _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: responseString, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                    }
                    
                    return
                })
                break
            case 402:
                // Decline
                let appointmentID = self.objCustomerNotification?._id
                let urlString = KBaseURLString + KDeclineCustomerRequest + appointmentID!
                let header = BRDSingleton.sharedInstane.getHeaders()
                if header == nil{return}
                
                let inputParameters: [String: Any] =
                    ["request_cancel_on": Date.stringFromDate(Date(), Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_)]
                
                BRDAPI.barberAcceptRequest("PUT", inputParameter: inputParameters, header: header!, urlString: urlString, completionHandler: { (reponse, responseString, status, error) in
                    
                    if status == 200{
                       _ = self.navigationController?.popToRootViewController(animated: true)
                        
                    }else{
                    
                        _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: responseString, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                    }
                })
                
                break
            default:
                break
        }
    
    
    }

}

extension BarberIncomingRequestVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTableView.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //mark
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarberIncomingRequestCell", for: indexPath) as? BarberIncomingRequestCell
        cell?.initWithData(obj: self.arrayTableView[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return nil
    }
    
}
