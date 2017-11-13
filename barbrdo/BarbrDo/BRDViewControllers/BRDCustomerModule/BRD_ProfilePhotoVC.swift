//
//  BRD_ProfilePhotoVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 28/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_ProfilePhotoVC_StoryboardID = "BRD_ProfilePhotoVC_StoryboardID"

class BRD_ProfilePhotoVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var shopDashboardFlag : Bool? = false
    var arrayCollectionView = [BRD_GalleyBO]()
    var objBarberInfo: BRD_UserInfoBO? = nil
    
    var objSelectedBarber: BRD_BarberInfoBO? = nil
    var objSelectedShopData: BRD_ShopDataBO? = nil
    var objUserProfile : BRD_UserProfileBO = BRD_UserProfileBO.init()


    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "BRD_Gallery_CollectionViewCell", bundle:nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: KBRD_Gallery_CollectionViewCell_CellIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnRequestBarberAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: BRDBookAppointmentVC.identifier()) as? BRDBookAppointmentVC {
            vc.barberDetails = self.objSelectedBarber
            vc.shopDetail = self.objSelectedShopData

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension BRD_ProfilePhotoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayCollectionView.count
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:BRD_Gallery_CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: KBRD_Gallery_CollectionViewCell_CellIdentifier, for: indexPath) as! BRD_Gallery_CollectionViewCell
        
        cell.initWithData(obj: self.arrayCollectionView[indexPath.row])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // your code here
        let width = (self.view.frame.size.width - 18 * 3) / 3
        let height = width
        return CGSize(width: width, height: height);
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_GalleryViewVC_StoryboardID) as! BRD_Customer_GalleryViewVC
        let obj = self.arrayCollectionView[indexPath.row]
        vc.strImagePath = obj.name
        vc.hideDeleteButton = true
        vc.currentIndex = indexPath.row
        vc.arrayCollectionView = self.arrayCollectionView
        vc.index = indexPath.row
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
