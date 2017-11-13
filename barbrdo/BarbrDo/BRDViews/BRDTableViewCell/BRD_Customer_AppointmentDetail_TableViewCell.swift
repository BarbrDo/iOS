//
//  BRD_Customer_AppointmentDetail_TableViewCell.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 15/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

let KBRD_Customer_AppointmentDetail_TableViewCell_CellIdentifier = "BRD_Customer_AppointmentDetail_TableViewCell_CellIdentifier"

class BRD_Customer_AppointmentDetail_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMemberSince: UILabel!
    
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var starRaringView: SwiftyStarRatingView!
    
    

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
    
}
