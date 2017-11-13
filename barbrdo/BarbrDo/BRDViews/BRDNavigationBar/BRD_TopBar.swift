//
//  BRD_TopBar.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 14/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_TopBar_CellIdentifier = "BRD_TopBar_CellIdentifier"

class BRD_TopBar: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnProfile: UIButton!

    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.profileImage?.layer.borderWidth = 1
        self.profileImage?.layer.masksToBounds = false
        self.profileImage?.layer.cornerRadius = (self.profileImage?.frame.height)!/2
        self.profileImage?.clipsToBounds = true
        self.profileImage?.layer.borderColor = UIColor.white.cgColor
        
        if let objUser = BRDSingleton.sharedInstane.objBRD_UserInfoBO{
            // Set Profile Image
            
            self.activityIndicator.startAnimating()
            if objUser.picture != nil && objUser.picture != ""{
                let imagePath = KImagePathForServer +  objUser.picture!
                self.profileImage.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                    
                    DispatchQueue.main.async(execute: {
                        if image != nil{
                            self.profileImage.image = image
                        }else{
                           self.profileImage.image = UIImage(named: "ICON_PROFILEIMAGE.PNG")
                        }
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidesWhenStopped = true
                    })
                })
            }else{
                self.profileImage.image = UIImage(named: "ICON_PROFILEIMAGE")
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
