//
//  BRD_Customer_Dashboard_TableViewCell.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 08/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_Customer_Dashboard_TableViewCell_CellIdentifier = "BRD_Customer_Dashboard_TableViewCell_CellIdentifier"

class BRD_Customer_Dashboard_TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var shopImageView: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var btnDetail: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.shopImageView.layer.borderWidth = 1.0
        self.shopImageView.layer.masksToBounds = false
        self.shopImageView.layer.borderColor = UIColor.white.cgColor
        self.shopImageView.layer.cornerRadius = self.shopImageView.frame.size.width/2
        self.shopImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func initWithData(obj: BRD_AppointmentsInfoBO){
        
        self.activityIndicator.startAnimating()
        
        if obj.barber_id?.picture != nil || obj.barber_id?.picture == ""{
            let imagePath = KImagePathForServer + (obj.barber_id?.picture)!
            self.shopImageView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                
                DispatchQueue.main.async(execute: {
                    if image != nil{
                        self.shopImageView.image = image
                    }else{
                        self.shopImageView.image = UIImage.init(named: "ICON_PROFILEIMAGE")
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                })
            })
        }else{
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
        }
       
        

        if(obj.barber_id  != nil){
            self.lblName.text = (obj.barber_id?.first_name)! +  " " + (obj.barber_id?.last_name)!
        }
               
        let month = Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMMM_dd)
        
        let time = Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.TimeFormat.hh_mm_a)
        
        self.lblDateTime.text = month + " @ " + time
        self.lblLocation.text = obj.shop_name
        
        
        
    }
}
