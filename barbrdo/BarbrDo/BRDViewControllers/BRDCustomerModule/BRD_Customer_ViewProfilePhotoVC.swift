//
//  BRD_Customer_ViewProfilePhotoVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 26/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_Customer_ViewProfilePhotoVC_StoryboardID = "BRD_Customer_ViewProfilePhotoVC_StoryboardID"

class BRD_Customer_ViewProfilePhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var viewNavigationBar: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = Bundle.main.loadNibNamed(String(describing: BRD_TopBar.self), owner: self, options: nil)![0] as? BRD_TopBar
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:75)
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        header?.btnProfile.addTarget(self, action: #selector(btnProfileAction), for: .touchUpInside)
        self.viewNavigationBar.addSubview(header!)
    }
    
    @IBAction func btnChangeProfileImageAction(_ sender: UIButton) {
        
        let optionMenu = UIAlertController(title: nil, message: KChooseOption, preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: KPhotoLibrary, style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: { imageP in
                
            })
            
        })
        
        let deleteAction = UIAlertAction(title: KCamera, style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
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
        
        let cancelAction = UIAlertAction(title: KCancel, style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        /*if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
           // self.uploadImage(image: image)
            //            let path = self.fileInDocumentsDirectory("Customer")
            //            _ = self.saveImage(image, path: path)
        }*/
        dismiss(animated: true, completion: nil)
    }
    
    func btnProfileAction() {
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_ProfileAndCutsVC_StoryboardID) as! BRD_ProfileAndCutsVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
