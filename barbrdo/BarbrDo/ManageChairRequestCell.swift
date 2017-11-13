//
//  ManageChairRequestCell.swift
//  BarbrDo
//
//  Created by Shami Kumar on 16/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class ManageChairRequestCell: UITableViewCell {

    @IBOutlet weak var pendingBtn: UIButton!
    @IBOutlet weak var barberLblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var chairLblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var chairSplitLbl: UILabel!
    @IBOutlet weak var barberLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 5.0
        self.acceptBtn.layer.cornerRadius = 5.0
        self.rejectBtn.layer.cornerRadius = 5.0
           // Initialization code
    }
    func initWithData(obj: BarberInfo?){
        
                

        if let obj1 =  obj?.picture
        {
            
            let imagePath = KImagePathForServer + obj1
            if imagePath.characters.count > 0{
                               self.profileImage.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                    
                    DispatchQueue.main.async(execute: {
                        if image != nil{
                      self.profileImage.image =  self.imageWithImage(image: image!, scaledToSize: CGSize(width: self.profileImage.frame.size.width/2, height: self.profileImage.frame.size.height/2)).withRenderingMode(UIImageRenderingMode.automatic)
                            self.profileImage.layer.masksToBounds = false
                            //        self.profileImage.layer.borderColor = UIColor.white.cgColor
                            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2
                            self.profileImage.clipsToBounds = true
                        }
                        
                    })
                }) }
            
                    }

        if let firstName = obj?.first_name
        {
            self.barberLbl.text = firstName + " " + (obj?.last_name!)!
            
        }

        
        else{
    self.profileImage.image = UIImage(named: "ICON_PROFILEIMAGE")

          }
        
        
    }
    
   
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
