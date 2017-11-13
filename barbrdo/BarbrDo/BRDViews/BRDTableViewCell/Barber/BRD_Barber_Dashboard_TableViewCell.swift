//
//  BRD_Barber_Dashboard_TableViewCell.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/19/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_Barber_Dashboard_TableViewCell_CellIdentifier = "BRD_Barber_Dashboard_TableViewCell_CellIdentifier"

class BRD_Barber_Dashboard_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCutSchdeule: UILabel!
    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet weak var lblEventValue: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var btnDetail: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
