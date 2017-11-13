//
//  BRD_Customer_ViewBarbers_TableViewCell.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 09/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

let KBRD_Customer_ViewBarbers_TableViewCell_CellIdentifier = "BRD_Customer_ViewBarbers_TableViewCell_CellIdentifier"

class BRD_Customer_ViewBarbers_TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblBarberName: UILabel!
    @IBOutlet weak var lblBarberDistance: UILabel!
    @IBOutlet weak var lblBarberLocation: UILabel!
   
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initWithData(obj: BRD_BarberInfoBO){
        
        
        self.lblBarberName.text = obj.first_name! + " " + obj.last_name!
        self.lblBarberDistance.text = String(describing: obj.distance!) + " Miles"
        self.lblBarberLocation.text = obj.location
        
       self.starRatingView.value = CGFloat(self.getRatingMean(ratingObj: obj.ratings))
    }
    
    func getRatingMean(ratingObj: [BRD_RatingsBO]?) -> Float {
        if let ratings = ratingObj {
            var avg: Float = 0.0
            if ratings.count > 0 {
                for obj in ratings {
                    if let value: Float = obj.score{
                        avg = avg + value
                    }
                }
                let fMean: Float = Float((ratingObj?.count)!)
                return avg/fMean
            }
            return avg
            
        }
        return 0.0
    }
    
}
