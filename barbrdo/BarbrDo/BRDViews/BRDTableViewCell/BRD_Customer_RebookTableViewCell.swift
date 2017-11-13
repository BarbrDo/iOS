//
//  BRD_Customer_RebookTableViewCell.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 19/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

let KBRD_Customer_RebookTableViewCell_CellIdentifier = "BRD_Customer_RebookTableViewCell_CellIdentifier"

class BRD_Customer_RebookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
 
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    
    @IBOutlet weak var btnReBook: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.profileImageView.layer.borderWidth = 1.0
        self.profileImageView.layer.masksToBounds = false
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        self.profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initWithData(obj: BRD_AppointmentsInfoBO){
        
        self.activityIndicator.startAnimating()
        
        if obj.barber_id?.picture != nil || obj.barber_id?.picture == ""{
            let imagePath = KImagePathForServer + (obj.barber_id?.picture)!
            self.profileImageView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                
                DispatchQueue.main.async(execute: {
                    if image != nil{
                        self.profileImageView.image = image
                    }else{
                        self.profileImageView.image = UIImage.init(named: "ICON_PROFILEIMAGE")
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                })
            })
        }else{
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
        }
        
        
        self.lblName.text = (obj.barber_id?.first_name)! + " " + (obj.barber_id?.last_name)!
        
        let month = Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.DD_MM_YYYY)
        
        let time = Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.TimeFormat.hh_mm_a)
        
        self.lblDateTime.text = month + ", " + time
        
        
        
        // Rating Code
        
        if let arrayRating = obj.barber_id?.ratings{
            
            var avgRate: Float = 0.0
            for objRate in arrayRating{
                if objRate.score != nil{
                    avgRate = avgRate + objRate.score!
                }
            }
            let totalRating: Float = Float(arrayRating.count)
            avgRate = avgRate/totalRating
            
            self.starRatingView.value = CGFloat(avgRate)
        }
    }
    
}
