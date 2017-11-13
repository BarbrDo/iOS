//
//  BRD_SideMenu_TableViewCell.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 03/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_SideMenu_TableViewCell_CellIdentifier = "BRD_SideMenu_TableViewCell_CellIdentifier"

class BRD_SideMenu_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
