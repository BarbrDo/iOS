//
//  BRD_ProfileCutsVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 28/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

let KBRD_ProfileCutsVC_StoryboardID = "BRD_ProfileCutsVC_StoryboardID"

class BarberCutsTableViewCell: UITableViewCell{
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
     
    
    static func identifier() -> String {
        return "BarberCutsTableViewCell"
    }
    
    func initWithData(obj: BRD_RatingsBO){
        
        self.lblName.text = obj.rated_by_name
        if obj.appointment_date != nil{
            self.lblDate.text = "Cut: " + Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MM_dd_yyYY)
        }
        
        self.starRatingView.value = CGFloat(obj.score!)
        
        if obj.picture != nil{
            let imagePath = KImagePathForServer + obj.picture!
            self.imageViewProfile.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                
                DispatchQueue.main.async(execute: {
                    if image != nil{
                        self.imageViewProfile.image = image
                    }else{
                        self.imageViewProfile.image = UIImage(named: "ICON_PROFILEIMAGE")
                    }
                })
            })
        }else{
            self.imageViewProfile.image = UIImage(named: "ICON_PROFILEIMAGE")
        }

    }
    
    
    override func awakeFromNib() {
        
        self.imageViewProfile.layer.borderWidth = 1.0
        self.imageViewProfile.layer.masksToBounds = false
        self.imageViewProfile.layer.borderColor = UIColor.white.cgColor
        self.imageViewProfile.layer.cornerRadius = self.imageViewProfile.frame.size.width/2
        self.imageViewProfile.clipsToBounds = true
    }
}


class BRD_ProfileCutsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var arrayTableView = [BRD_RatingsBO]()
    
    var objSelectedBarber: BRD_BarberInfoBO? = nil
    var objSelectedShopData: BRD_ShopDataBO? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnRequestBarberAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: BRDBookAppointmentVC.identifier()) as? BRDBookAppointmentVC {
            vc.barberDetails = self.objSelectedBarber
            vc.shopDetail = self.objSelectedShopData
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension BRD_ProfileCutsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BarberCutsTableViewCell = tableView.dequeueReusableCell(withIdentifier: BarberCutsTableViewCell.identifier()) as! BarberCutsTableViewCell
        cell.initWithData(obj: self.arrayTableView[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }

}
