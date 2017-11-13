//
//  ContactingBarberScreenVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 02/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import CircleProgressView
import AVFoundation



class ContactingBarberTableViewCell: UITableViewCell{
    
    @IBOutlet weak var lblServiceName: UILabel!
    
}

class ContactingBarberScreenVC: UIViewController {
    
    @IBOutlet weak var circleProgressView: CircleProgressView!
    @IBOutlet weak var imageViewBarber: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    
    
    var objBarberInfo: BarberListBO? = nil
    
    
    var strTime: String? = nil
    var arrayTableView = [BRD_ServicesBO]()
    var objAppointment: AppointmentInfoBO?
    // For Circular timer
    var sdValue: Float = 0.01
    var timer: Timer!
    
    var player: AVAudioPlayer?
    var timerPlayer = Timer()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.imageViewBarber.layer.borderWidth = 2.0
        self.imageViewBarber.layer.masksToBounds = false
        self.imageViewBarber.layer.borderColor = KBlueShade.cgColor
        self.imageViewBarber.layer.cornerRadius = self.imageViewBarber.frame.size.width/2
        self.imageViewBarber.clipsToBounds = true
        self.imageViewBarber.alpha = 0.5
        
        // Barber Image
        
        if self.objBarberInfo?.picture != nil{

            let imagePath = KImagePathForServer + (self.objBarberInfo?.picture)!
            self.imageViewBarber.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                
                DispatchQueue.main.async(execute: {
                    if image != nil{
                        self.imageViewBarber.image = image
                    }else{
                        self.imageViewBarber.image = UIImage(named: "ICON_PROFILEIMAGE")
                    }
                })
            })
        }else{
            self.imageViewBarber.image = UIImage(named: "ICON_PROFILEIMAGE")
        }
        
        if self.strTime != nil{
           self.lblTime.text = "Be there in " + self.strTime! + " minutes"
        }
        
        timer = Timer.scheduledTimer(timeInterval:1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        timer.fire()
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ContactingBarberScreenVC.stopTimer), name: Notification.Name(KStopCustomerTimer), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContactingBarberScreenVC.barberDeclineRequest), name: Notification.Name(KBarberDeclineRequest), object: nil)
        
        
        if self.objAppointment != nil{
            
            self.arrayTableView = (self.objAppointment?.services)!
            self.tableView.reloadData()
            
//            self.lblTime.text = "Be there in " +  Date.convert((self.objAppointment?.appointment_date)!, Date.DateFormat.yyyy_MM_dd_HH_mm_ss, Date.TimeFormat.HH_mm) + " minutes"
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.playSound()
        //self.timerPlayer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.playSound), userInfo: nil, repeats: true)
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
    
    func timerAction(){
        
        sdValue += 0.0166
        
        self.circleProgressView.progress = Double(sdValue)
        
        if sdValue > 0.90{
            self.circleProgressView.trackFillColor = UIColor.red
            self.circleProgressView.tintColor = UIColor.red
            
        }
        
        if sdValue >= 1.0{
           player?.stop()
            timer.invalidate()
            //self.timerPlayer.invalidate()
            self.pushView()
        }
    }
    
    func pushView(){
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BarberNotAcceptedVC") as! BarberNotAcceptedVC
        self.navigationController?.pushViewController(vc, animated: false)
       
    }
    
    func stopTimer(){
        player?.stop()
        //self.timerPlayer.invalidate()
        timer.invalidate()
    }
    
    func barberDeclineRequest(notification: NSNotification){
        var declineMessage = ""
        if let notificationObj = notification.object as? NSDictionary{
            
            if let aps = notificationObj["aps"] as? NSDictionary {
                if let alert = aps["alert"] as? NSString {
                    //Do stuff
                    declineMessage = alert as String
                }
            }
        }
        player?.stop()
        timer.invalidate()
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BarberNotAcceptedVC") as! BarberNotAcceptedVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnCancelAction(sender: UIButton){
    
        
        _ =  BRDAlertManager.showAlertWithSimilarButtonsType(.default, withTitle: KCancelAlertTitle, withMessage: KCancelAlertText, buttonTitles: ["OK", "Cancel"], onViewController: self, animated: true, presentationCompletionHandler: {
        }, returnBlock: { response in
            let value: Int = response
            if value == 0{
                
                //customer/appointment/cancel/
                let appointmentID = self.objAppointment?._id
                let urlString = KBaseURLString + KCustomerCancelAppointment + appointmentID!
                let header = BRDSingleton.sharedInstane.getHeaders()
                if header == nil{return}
                
                //request_check_in
                let inputParameters: [String: Any] =
                    ["request_cancel_on": Date.stringFromDate(Date(), Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_)]
                
                BRDAPI.barberAcceptRequest("PUT", inputParameter: inputParameters, header: header!, urlString: urlString, completionHandler: { (reponse, responseString, status, error) in
                    
                    if status == 200{
                        self.player?.stop()
                        self.timer.invalidate()
                        self.navigationController?.popViewController(animated: true)

                    }else{
                        
                        _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: responseString, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                        return
                    }
                })
                
            }else{
                // Do not logout
            }
        })
        
       
    }
}


extension ContactingBarberScreenVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTableView.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //mark
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactingBarberTableViewCell", for: indexPath) as? ContactingBarberTableViewCell
        cell?.backgroundColor = UIColor.clear
        
        let obj = self.arrayTableView[indexPath.row]
        cell?.lblServiceName.text = obj.name! + " .. $" +
        String(format: "%.02f", obj.price!)
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
   
}
