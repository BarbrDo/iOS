//
//  BRD_Customer_AppointmentDetail_YourBarber_TableViewCell.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 09/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

let KBRD_Customer_AppointmentDetail_YourBarber_TableViewCell_CellIdentifier = "BRD_Customer_AppointmentDetail_YourBarber_TableViewCell_CellIdentifier"

class BRD_Customer_AppointmentDetail_YourBarber_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var ViewYourBarber: UIView!
    @IBOutlet weak var viewContactBarber: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLastHairCut: UILabel!
    
    @IBOutlet weak var starRatingVIew: SwiftyStarRatingView!
    
    
    @IBOutlet weak var btnContactBarber: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.starRatingVIew.value = 4.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initWithData(obj: BRD_AppointmentsInfoBO){
        
        self.lblName.text = obj.barber_name
        self.lblLastHairCut.text = Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MM_d_yyyy)
        if (obj.barber_id?.ratings?.count)! > 0{
    
            var totalVal: Float = 0
            for ratingObj in (obj.barber_id?.ratings)!{
                totalVal = totalVal + ratingObj.score!
            }
            let totalCount = Float((obj.barber_id?.ratings?.count)!)
            totalVal = totalVal/totalCount
            self.starRatingVIew.value = CGFloat(totalVal)
        }
        
    
        
    }
    
}
