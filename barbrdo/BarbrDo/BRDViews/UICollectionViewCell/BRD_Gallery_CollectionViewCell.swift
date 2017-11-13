//
//  BRD_Gallery_CollectionViewCell.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 16/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_Gallery_CollectionViewCell_CellIdentifier = "BRD_Gallery_CollectionViewCell_CellIdentifier"

class BRD_Gallery_CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.borderWidth = 3.0
        self.imageView.layer.borderColor = UIColor.white.cgColor
        // Initialization code
        
        
    }
    
    func initWithData(obj: BRD_GalleyBO){
        
        if obj.name! == ""
        {
              self.imageView.image = UIImage(named: "ICON_PROFILEIMAGE")
        }
        else{
        let imagePath = KImagePathForServer + obj.name!
        self.activityIndicator.startAnimating()
        if imagePath.characters.count > 0{
            
            self.imageView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                
                DispatchQueue.main.async(execute: {
                    if image != nil{
                        self.imageView.image = image
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                })
            }) }
        }
        
    /*
        if !obj.name!.isEmpty {
            
           // let url_Pic:NSURL = NSURL(string: (self.exerciseTypeArray[indexPath.row].valueForKey("exercise_image") as! String))!
            
            let serverPath = BRDSingleton.sharedInstane.objBRD_UserInfoBO?.imagesPath
            let imagePath = serverPath! + obj.name!

            print(imagePath)
            self.activityIndicator.startAnimating()
            
            self.imageView.sd_setImage(with: NSURL .fileURL(withPath: imagePath), placeholderImage: UIImage(named: "ICON_PROFILEIMAGE"), options: .cacheMemoryOnly, completed: { (image, error, SDImageCacheType, url_Pic) -> Void in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
                self.imageView.image = image
                
            })
    }
 */
 }
}
