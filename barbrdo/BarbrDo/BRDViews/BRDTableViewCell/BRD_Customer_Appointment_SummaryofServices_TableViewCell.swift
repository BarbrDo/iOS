//
//  BRD_Customer_Appointment_SummaryofServices_TableViewCell.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 09/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_Customer_Appointment_SummaryofServices_TableViewCell_CellIdentifier = "BRD_Customer_Appointment_SummaryofServices_TableViewCell_CellIdentifier"

class BRD_Customer_Appointment_SummaryofServices_TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var viewSummary: BRDView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       // self.viewSummary.round(corners: [.topLeft, .topRight], radius: 3.0, borderColor: UIColor.clear, borderWidth: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
