//
//  BRD_Customer_ProfileGalleryVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/12/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_Customer_ProfileGallery_StoryboardID = "BRD_Customer_ProfileGalleryViewController"
class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var galleryImageView: UIImageView!
}

class BRD_Customer_ProfileGalleryVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.layer.cornerRadius = 4.0
        self.backgroundView.clipsToBounds = true
        self.profileImageView.layer.cornerRadius = 40.0
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        self.profileImageView.layer.borderWidth = 2.0

        // Do any additional setup after loading the view.
        
        
        if let serverPath = BRDSingleton.sharedInstane.imagePath{
            if let imageName = BRDSingleton.sharedInstane.objBRD_UserInfoBO?.picture{
                let imagePath = serverPath + imageName
                self.profileImageView.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage(named: "ICON_PROFILEIMAGE"))
            }
        }
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    
    // MARK:- UICollectionViewDelegateFlowLayout Delegate
    func createCollectionViewLayout(){
        self.galleryCollectionView!.register(GalleryCell.self, forCellWithReuseIdentifier: "gallerycollectioncell")
        self.galleryCollectionView!.backgroundColor = UIColor.clear
        //        self.view.addSubview(self.workoutcollectionView!)
    }
    // MARK:- UICollectionViewDataSource Delegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.frame.size.width - 30
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        return CGSize(width:size/3, height: size/3)
        //let size = CGSize(width: 20, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.galleryCollectionView.dequeueReusableCell(withReuseIdentifier: "gallerycollectioncell", for: indexPath as IndexPath) as! GalleryCell
        cell.backgroundColor = UIColor.clear
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.white.cgColor
        // cell.workoutimageView?.image = self.workoutArray[indexPath.row].valueForKey("image_name") as? String
        
        return cell
    }
    
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
