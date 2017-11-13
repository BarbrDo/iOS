//
//  BRD_BookAnAppointment_TableViewCell.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 15/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_BookAnAppointment_TableViewCell_CellIdentifier = "BRD_BookAnAppointment_TableViewCell_CellIdentifier"

class BRD_BookAnAppointment_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewMain: BRDView!
    @IBOutlet weak var lblHairCut: UILabel!
    @IBOutlet weak var lblHairCutPrice: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.viewMain.round(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 3.0, borderColor: UIColor.clear, borderWidth: 1.0)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
