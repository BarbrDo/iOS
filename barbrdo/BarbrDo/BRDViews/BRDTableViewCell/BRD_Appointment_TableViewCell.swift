//
//  BRD_Appointment_TableViewCell.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 09/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_Appointment_TableViewCell_CellIdentifier = "BRD_Appointment_TableViewCell_CellIdentifier"

class BRD_Appointment_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblServiceName: BRD_UILabel!
    
    @IBOutlet weak var lblServiceCost: BRD_UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initWithData(obj: BRD_ServicesBO) {
        let serviceName = obj.name
        self.lblServiceName.text = serviceName?.capitalized
        if let price = obj.price{
            self.lblServiceCost.text = "$ " + String(price)
        }
    }
}
