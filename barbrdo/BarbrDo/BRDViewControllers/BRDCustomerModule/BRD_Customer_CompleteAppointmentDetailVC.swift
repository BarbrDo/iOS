//
//  BRD_Customer_CompleteAppointmentDetailVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 02/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

let KBRD_Customer_CompleteAppointmentDetailVC_StoryboardID = "BRD_Customer_CompleteAppointmentDetailVC_StoryboardID"


class LastAppointmentBookedTableViewCell : UITableViewCell{
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var btnAddToCalender: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "LastAppointmentBookedTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(obj: BRD_AppointmentsInfoBO){
        
        self.lblDate.text = Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.EEEE_MMMM_dd)
        self.lblTime.text = Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.TimeFormat.hh_mm_a)
    }
    
}
//
class LastAppointmentLastRatingTableViewCell: UITableViewCell{
    
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "LastAppointmentLastRatingTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(obj: BRD_AppointmentsInfoBO){
          self.starRatingView.value = CGFloat(obj.rating_score!)
    }
}

class LastAppointmentSummaryTableViewCell: UITableViewCell{
    
    @IBOutlet weak var lblBarberAddress: UILabel!
    @IBOutlet weak var btnViewOnMap: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "LastAppointmentSummaryTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


class LastAppointmentBarberServices: UITableViewCell{
    
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblServiceCost: UILabel!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "LastAppointmentBarberServices"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(obj: BRD_ServicesBO) {
        let serviceName = obj.name
        self.lblServiceName.text = serviceName?.capitalized
        
        if obj.price != nil{
            if let price = obj.price{
                self.lblServiceCost.text = "$ " + String(price)
            }
        }
    }
}
//
class LastAppointmentTotalDue: UITableViewCell{
    
    @IBOutlet weak var lblTotalAmountDue: UILabel!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "LastAppointmentTotalDue"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func iniWithData(obj: BRD_AppointmentsInfoBO) {
        
        if (obj.services?.count)! > 0{
            var value: Double = 0
            
            for userServices in obj.services!{
                if userServices.price != nil{
                    value = value + userServices.price!
                }
            }
            self.lblTotalAmountDue.text = "$ " + String(format: "%.2f", value)

                //String(describing: value)
        }
    }
}

class LastAppointmentBarberProfile: UITableViewCell{
    
    @IBOutlet weak var barberImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblBarberName: UILabel!
    @IBOutlet weak var lblLastCut: UILabel!
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    @IBOutlet weak var btnContactBarber: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "LastAppointmentBarberProfile"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.barberImageView?.layer.masksToBounds = false
        self.barberImageView?.layer.cornerRadius = (self.barberImageView?.frame.height)!/2
        self.barberImageView?.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func iniWithData(obj: BRD_AppointmentsInfoBO) {
        
        if let barberDetail = obj.barber_id{
            self.lblBarberName.text = barberDetail.first_name! + " " + barberDetail.last_name!
            
            if let rating = barberDetail.ratings{
                var rateValue: Float = 0
                for item in rating{
                    
                    rateValue = rateValue + item.score!
                }
                
                let avg: Float = rateValue / Float(rating.count)
                self.starRatingView.value = CGFloat(avg)
            }else{
                self.starRatingView.value = 0
            }
            
            self.activityIndicator.startAnimating()
            
            if obj.barber_id?.picture != nil || obj.barber_id?.picture == ""{
                let imagePath = KImagePathForServer + (obj.barber_id?.picture)!
                self.barberImageView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                    
                    DispatchQueue.main.async(execute: {
                        if image != nil{
                            self.barberImageView.image = image
                        }else{
                            self.barberImageView.image = UIImage.init(named: "ICON_PROFILEIMAGE")
                        }
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidesWhenStopped = true
                    })
                })
            }else{
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            }
            
            self.lblLastCut.text = Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMMM_YYYY)

        }
    }
}

class BRD_Customer_CompleteAppointmentDetailVC: UIViewController {
    
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var arrayTableView = [BRD_ServicesBO]()
    var objAppointment: BRD_AppointmentsInfoBO? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let header = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitle.self), owner: self, options: nil)![0] as? NavigationBarWithTitle
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        header?.lblScreenTitle.text = KCompleteAppointmentDetails
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(header!)
        
        if let arrayServices = self.objAppointment?.services{
            self.arrayTableView = arrayServices
            self.tableView.reloadData()
        }
    }
    
  
    
    func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension BRD_Customer_CompleteAppointmentDetailVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var noOfRows: Int = 0
        switch section {
        case 3:
            noOfRows = self.arrayTableView.count
        default:
            noOfRows = 0
            break
        }
        return noOfRows
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:LastAppointmentBarberServices = tableView.dequeueReusableCell(withIdentifier: LastAppointmentBarberServices.identifier()) as! LastAppointmentBarberServices
        cell.initWithData(obj: self.arrayTableView[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            return nil
        case 1:
            
            let header = tableView.dequeueReusableCell(withIdentifier: LastAppointmentBookedTableViewCell.identifier()) as? LastAppointmentBookedTableViewCell
            header?.initWithData(obj: self.objAppointment!)
            return header
        case 2:
            
            let header = tableView.dequeueReusableCell(withIdentifier: LastAppointmentLastRatingTableViewCell.identifier()) as? LastAppointmentLastRatingTableViewCell
            header?.initWithData(obj: self.objAppointment!)
            return header
        case 3:
            let header = tableView.dequeueReusableCell(withIdentifier: LastAppointmentSummaryTableViewCell.identifier()) as? LastAppointmentSummaryTableViewCell
            return header
        case 4:
            let header = tableView.dequeueReusableCell(withIdentifier: LastAppointmentBarberProfile.identifier()) as? LastAppointmentBarberProfile
            header?.iniWithData(obj: self.objAppointment!)
            header?.btnContactBarber.addTarget(self, action: #selector(_bookButtonAction(_:)), for: .touchUpInside)
            return header
            
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 3{
            
            let header = tableView.dequeueReusableCell(withIdentifier: LastAppointmentTotalDue.identifier()) as? LastAppointmentTotalDue
            header?.iniWithData(obj: self.objAppointment!)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3{
            return 29
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var sectionHeight: CGFloat = 0.0
        
        switch section {
        case 0: sectionHeight = 5.0
            break
        case 1:
            sectionHeight = 102.0
            break
        case 2:
            sectionHeight = 104.0
            break
        case 3:
            sectionHeight = 32.5
            break
        case 4:
            sectionHeight = 141.5
            break
        default:
            sectionHeight = 0.0
            break
        }
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 22.0
    }
    
    @objc private func _bookButtonAction(_ button: UIButton){
       // let indexPath = BRDUtility.indexPath(self.tableView, button)
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: BRDBookAppointmentVC.identifier()) as? BRDBookAppointmentVC {
            vc.objBarberAppointments = self.objAppointment
            vc.shopDetail = self.objAppointment?.shop_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
