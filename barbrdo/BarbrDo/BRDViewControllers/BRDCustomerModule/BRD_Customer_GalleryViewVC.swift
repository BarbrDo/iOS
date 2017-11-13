//
//  BRD_Customer_GalleryViewVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 22/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

let KBRD_Customer_GalleryViewVC_StoryboardID = "BRD_Customer_GalleryViewVC_StoryboardID"

class CollectionViewFullScreen: UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!
    
    
}


class BRD_Customer_GalleryViewVC: UIViewController {
    
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var viewNavigationBar: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrayCollectionView = [BRD_GalleyBO]()
    var isFirstorLastIndex : Bool = false
    var currentIndex : Int  = 0

    @IBOutlet weak var scrollView: UIScrollView!

    
    var strImagePath : String? = nil
    var imageID: String? = nil
    var hideDeleteButton: Bool = false
    
    var arrayImages = [BRD_GalleyBO]()
    var index: Int = 0
    
    var onlyOnce : Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        
        if hideDeleteButton == true{
            self.btnDelete.isHidden = true
            self.btnDelete.isUserInteractionEnabled = false
            self.btnShare.isHidden = true
            self.btnShare.isUserInteractionEnabled = false
        }else{
            self.btnDelete.isHidden = false
            self.btnDelete.isUserInteractionEnabled = true
            self.btnShare.isHidden = false
            self.btnShare.isUserInteractionEnabled = true
        }
        
        // add swipe Gesture
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(BRD_Customer_GalleryViewVC.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(BRD_Customer_GalleryViewVC.handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
       
    }
    
    
    
    
    func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        print(currentIndex)
        
        if (sender.direction == .left) {
            // Swipe Left
            if self.arrayCollectionView.count - 1 > currentIndex {
                currentIndex += 1
                self.isFirstorLastIndex = false
            }
        }
        
        if (sender.direction == .right) {
            // Swipe Right
            if currentIndex > 0 {
                currentIndex -= 1
                self.isFirstorLastIndex = false
            }
        }
        
        if (self.isFirstorLastIndex) {
            return
        }
        
        let indexPath : IndexPath = IndexPath.init(row: currentIndex, section: 0)
        
        if sender.direction == .left {
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        }
        else{
            self.collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
        }
        
        if (currentIndex == 0) || (currentIndex == self.arrayCollectionView.count - 1){
            self.isFirstorLastIndex = true
        }
        
    }
    
    
    func displayTopImage(_ indexPath : IndexPath)  {
        let cell : ViewDocsCollectionViewCell?
        
        do {
            cell  = self.collectionView.cellForItem(at: indexPath) as? ViewDocsCollectionViewCell
            
            if cell != nil {
                if self.scrollView.isHidden == true {
                    self.imageView.image = cell!.imageView.image
                }
                else{
                    //self.fullScreenImageView.image = cell!.imageView.image
                }
            }
            else{
                self.imageView.image = UIImage()
            }
        }
    }
    
    
    @IBAction func galleryDetailAction(sender: UIButton){
    
        switch sender.tag {
        case 101:
            // Back
            self.navigationController?.popViewController(animated: true)
            break
        case 102:
            
            self.deleteImage()
            // delete
            break
        case 103:
            self.shareImage ()
            // Share Image
            break
        default:
            break
        }
        
    }
    
    func shareImage (){
        
        let indexPath : IndexPath = IndexPath.init(row: currentIndex, section: 0)
        let cell  = self.collectionView.cellForItem(at: indexPath) as? CollectionViewFullScreen
        
        if  let image = cell?.imageView.image
        {
            // set up activity view controller
            let imageToShare = [ image]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivityType.postToTwitter ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    private func deleteImage(){
        
        
        _ =  BRDAlertManager.showAlertWithSimilarButtonsType(.default, withTitle: KAlertTitle, withMessage: "Are you sure you want to delete this image?", buttonTitles: ["Cancel", "Ok"], onViewController: self, animated: true, presentationCompletionHandler: {
        }, returnBlock: { response in
            let value: Int = response
            if value == 0{
                // Cancel
                
            }else{
                // Delete
                
                if self.imageID == nil{return}

                SwiftLoader.show("Deleting...", animated: true)
                
                let lat = BRDSingleton.sharedInstane.latitude
                let long = BRDSingleton.sharedInstane.longitude
                let user = BRDSingleton.sharedInstane.objBRD_UserInfoBO
                let userID = user?._id
                let header: [String: String] =
                    [KLatitude : lat!,
                     KLongitude : long!,
                     KUserID : userID!,
                     KImageID: self.imageID!]
                
                let urlString = KBaseURLString + KDeleteImage + self.imageID!
                BRDAPI.deleteImage("Delete", inputParameters: nil, header: header, urlString: urlString) { (response, userData, status, error) in
                    
                    SwiftLoader.hide()
                    
                    if userData != nil{
                        BRDSingleton.sharedInstane.objBRD_UserInfoBO = userData
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                    }
                }
            }
            
        })
        
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension BRD_Customer_GalleryViewVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    // MARK: UICOLLECTIONVIEW DELEGATE AND DATASOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.arrayCollectionView)
        return self.arrayCollectionView.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:CollectionViewFullScreen = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewFullScreen", for: indexPath) as! CollectionViewFullScreen
        //cell.imageView.tag = indexPath.row
        
        if let obj = self.arrayCollectionView[indexPath.row] as? BRD_GalleyBO{
            
            if obj.name == nil || obj.name == ""
            {
                self.imageView.image = UIImage(named: "ICON_PROFILEIMAGE")
            }
            else{
                let imagePath = KImagePathForServer + obj.name!
                SwiftLoader.show(KLoading, animated: true)
                if imagePath.characters.count > 0{
                    
                    cell.imageView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                        
                        DispatchQueue.main.async(execute: {
                            if image != nil{
                                cell.imageView.image = image
                            }else{
                                self.imageView.image = UIImage.init(named: "ICON_PROFILEIMAGE")
                            }
                            
                            SwiftLoader.hide()
                        })
                    })
                }
            }
            return cell
        }
        
       
    }
   
    
    func updateHomeScreenImage(_ image: UIImage) {
        // self.imageArray.addObject(image)
        self.imageView.image = image
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: collectionView.frame.size.height - 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    //MARK:- Scrollview delegate method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in self.collectionView.visibleCells  as [UICollectionViewCell]    {
            let indexPath = self.collectionView.indexPath(for: cell as UICollectionViewCell)
            //print("scrolled index path is \(indexPath?.row)")
            self.currentIndex = (indexPath?.row)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if onlyOnce == true{
        
            onlyOnce = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
                // Put your code which should be executed with a delay here
                let indexPath = IndexPath.init(row: self.currentIndex, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            })
        }
        
        
    }
}





