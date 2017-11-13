//
//  BRD_Barber_GalleryVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/18/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
let KBRD_Barber_GalleryVC_StoryboardID = "BRD_Barber_GalleryVC_StoryboardID"

class BRD_Barber_GalleryVC: BRD_BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrayCollectionView = [BRD_GalleyBO]()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.addTopNavigationBar(title: KGallery)
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "BRD_Gallery_CollectionViewCell", bundle:nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: KBRD_Gallery_CollectionViewCell_CellIdentifier)
        let header : NavigationBarWithTitleAndBack = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitleAndBack.self), owner: self, options: nil)![0] as! NavigationBarWithTitleAndBack
        header.btnBack.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        header.btnProfile.addTarget(self, action: #selector(btnProfileMenu), for: .touchUpInside)
        header.initWithTitle(title: "Gallery")
        header.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        self.view.addSubview(header)
        
    }
    func btnBackAction(){
        
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func btnProfileMenu(){
        
        let storyboard = UIStoryboard(name:"Barber", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_Profile_StoryboardID) as! BRD_Barber_ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let obj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        
        if let array = obj?.gallery{
            self.arrayCollectionView = array
        }
        self.collectionView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnAddAction(_ sender: UIButton) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Photo Library", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: { imageP in
                
            })
            
        })
        
        
        let deleteAction = UIAlertAction(title: "Camera", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .camera
                imagePickerController.allowsEditing = true
                self.present(imagePickerController, animated: true, completion: { imageP in
                    
                })
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: KCameraAlert, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
                return
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
            
            
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            let compressedImage: UIImage = BRDSingleton.resizingCapturedImage(CapturedImage: image)
            self.uploadImage(image: compressedImage)

        }
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(image: UIImage){
        
        self.showLoader(message: "Uploading Image...")
        
        let imageData: Data = UIImageJPEGRepresentation(image, 1.0)!
        
        let urlString: String = KBaseURLString + "barber/gallery"
        let data = ["type": imageData]
        
        ConnectionManager.shared.sendRequestWithMultipart("POST",urlString, nil, data) { (response, status, error, statusCode) in
            
            if let userData = response?["user"] as? [String: Any]{
                if let obj = BRD_UserInfoBO.init(dictionary: userData){
                    BRDSingleton.sharedInstane.objBRD_UserInfoBO?.gallery = obj.gallery
                    UserDefaults.standard.removeObject(forKey: BRDRawStaticStrings.kUserData)
                    let data = NSKeyedArchiver.archivedData(withRootObject: BRDSingleton.sharedInstane.objBRD_UserInfoBO)
                    UserDefaults.standard.set(data, forKey: BRDRawStaticStrings.kUserData)
                    
                    
                    self.arrayCollectionView = obj.gallery!
                    self.collectionView.reloadData()
                    self.hideLoader()
                }
                self.hideLoader()
            }
            self.hideLoader()
        }
        
    }

}

extension BRD_Barber_GalleryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayCollectionView.count
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:BRD_Gallery_CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: KBRD_Gallery_CollectionViewCell_CellIdentifier, for: indexPath) as! BRD_Gallery_CollectionViewCell
        
        cell.initWithData(obj: self.arrayCollectionView[indexPath.row])
        //cell.activityIndicator.startAnimating()
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // your code here
        let width = (self.view.frame.size.width - 8 * 3) / 3 //some width
        // let height = width * 1.5 //ratio
        let height = width
        return CGSize(width: width, height: height);
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_GalleryViewVC_StoryboardID) as! BRD_Customer_GalleryViewVC
        
        vc.arrayImages = self.arrayCollectionView
        vc.arrayCollectionView = self.arrayCollectionView
        vc.currentIndex = indexPath.row
        
        vc.arrayImages = self.arrayCollectionView
        let obj = self.arrayCollectionView[indexPath.row]
        vc.index = indexPath.row
        
        vc.strImagePath = obj.name
        vc.imageID = obj._id
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
}
