//
//  ViewDocsCollectionViewCell.swift
//  TNP
//
//  Created by Sumit Sharma on 31/05/16.
//  Copyright © 2016 Sumit Sharma. All rights reserved.
//

import UIKit


let kViewDocsCollectionViewCellIdentifier = "ViewDocsCollectionViewCellIdentifier"

protocol ViewDocsCollectionViewCellDelegate {
    func updateHomeScreenImage(_ image : UIImage)
}

class ViewDocsCollectionViewCell: UICollectionViewCell {
    
    // IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // Instance Variables
    
    var delegate : ViewDocsCollectionViewCellDelegate?
    
//        func initWithData(_ documentID : String, andIndexPath index : IndexPath) -> Void {
//        
//        TNPAppData.sharedInstane.showProgressHUD(ControllerView: self.imageView, andHudTitle: kEmptyString)
//        let obj : TNPUserData = TNPAppData.sharedInstane.objTNPUserData!
//        let requestParameters : [String : String] = [kAccessToken: (obj.bodyAccessToken)!, kipAddress : TNPAppData.sharedInstane.ipAddress, "DocumentId": documentID]
//        self.imageView.downloadedFrom(URLRequest: requestParameters as NSDictionary, urlComponent: kGetRequestDocument, requestType: kPOSTRequest) { (image, error) in
//            self.imageView.image = image
//            if self.imageView.tag == 0 {
//                 self.delegate?.updateHomeScreenImage(image!)
//            }
//            TNPAppData.sharedInstane.dismissProgressHUD(self.imageView)
//        }
//    }
}
