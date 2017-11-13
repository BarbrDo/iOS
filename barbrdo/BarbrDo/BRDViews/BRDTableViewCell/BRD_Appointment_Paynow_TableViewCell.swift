//
//  BRD_Appointment_Paynow_TableViewCell.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 09/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_Appointment_Paynow_TableViewCell_CellIdentifier = "BRD_Appointment_Paynow_TableViewCell_CellIdentifier"

class BRD_Appointment_Paynow_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func iniWithData(obj: BRD_AppointmentsInfoBO) {
        
        
        if (obj.services?.count)! > 0{
            var value: Double = 0
            
            for userServices in obj.services!{
                if userServices.price != nil{
                    value = value + userServices.price!
                }
            }
            
            self.lblTotalAmount.text = "$ " + String(format: "%.2f", value)

                
                //String(describing: value)
        }
    }
    
}
