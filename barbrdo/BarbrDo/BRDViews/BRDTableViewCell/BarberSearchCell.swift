//
//  BarberSearchCell.swift
//  BarbrDo
//
//  Created by Shami Kumar on 14/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
class BarberSearchCell: UITableViewCell {

    @IBOutlet weak var starView: SwiftyStarRatingView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var requestBtn: UIButton!
    @IBOutlet weak var sinceLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        requestBtn.layer.cornerRadius = 5.0
        self.starView.isUserInteractionEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
