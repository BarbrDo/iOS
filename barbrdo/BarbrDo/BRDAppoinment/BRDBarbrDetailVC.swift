//
//  BRDBarbrDetailVC.swift
//  BarbrDo
//
//  Created by Vishwajeet Kumar on 5/12/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

class BRDCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "BRDCollectionViewCell"
    }
}

fileprivate let cellHeight: CGFloat      =      80.5

class BRDBarbrDetailVC: BRD_BaseViewController {
    
    @IBOutlet weak var viewNavigationBar: UIView!
    @IBOutlet weak var lblShopName: UILabel!
    
    // collection view
    @IBOutlet weak var collectionView: UICollectionView!
    
    // page control
    @IBOutlet weak var pageControl: UIPageControl!
    
    // tableView
    @IBOutlet weak var tableView: UITableView!
    private var layout = UICollectionViewFlowLayout()
    
    var shopDetail: BRD_ShopDataBO?
    var viewOnMapShopDetal: BRD_ShopDataBO?
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "BRDBarbrDetailVC"
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.viewOnMapShopDetal = self.shopDetail
        _initialization()
        
        let header = Bundle.main.loadNibNamed(String(describing: BRD_TopBar.self), owner: self, options: nil)![0] as? BRD_TopBar
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:75)
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        header?.btnProfile.addTarget(self, action: #selector(btnProfileAction), for: .touchUpInside)
        self.viewNavigationBar.addSubview(header!)
        
        
        
        if self.shopDetail?.name != nil{
            self.lblShopName.text = self.shopDetail?.name
        }
        self.tableView.register(UINib(nibName: String(describing: BRD_Customer_AppointmentDetail_BarberShopAddress_TableViewCell.self), bundle: nil), forCellReuseIdentifier: KBRD_Customer_AppointmentDetail_BarberShopAddress_TableViewCell_CellIdenfier)
        
        self.tableView.register(UINib(nibName: String(describing: BRD_Customer_AppointmentDetail_TableViewCell.self), bundle: nil), forCellReuseIdentifier: KBRD_Customer_AppointmentDetail_TableViewCell_CellIdentifier)
    }
    func btnProfileAction() {
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_Profile_StoryboardID) as! BRD_Customer_ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func backButtonAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Memory Management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - API Method
    private func _getShopDetails() {
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{return}
        
        SwiftLoader.show(KLoading, animated: true)
        if let shopId = self.shopDetail?._id {
            let urlString = KBaseURLString + KShopDetailsURL + shopId
            
            BRDAPI.getShopDetail("GET", inputParameter: nil, header: header!, urlString: urlString, completionHandler: { (response, shops, status, error) in
                
                SwiftLoader.hide()
                switch status {
                case .success:
                    self.shopDetail = shops
                    self.hideLoader()
                    self._reloadCollectionView()
                    self.tableView.reloadData()
                default:
                    self.errorHandling(response, status, error)
                }
            })
        }
    }
   
    
    
    // MARK: - Other Method
    private func _initialization() {
        self.navigationController?.isNavigationBarHidden = true
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.bounces = false
        self.collectionView.clipsToBounds = true
        self.collectionView.isPagingEnabled = true
        self.collectionView.backgroundColor  = .clear
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        
        self.layout.sectionInset = UIEdgeInsets.zero
        self.layout.minimumInteritemSpacing = 0.0
        self.layout.minimumLineSpacing = 0.0
        self.layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        
        _reloadCollectionView()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = .clear
        
        _getShopDetails()
    }
    
    func _reloadCollectionView() {
        self.pageControl.currentPage = 0
        if let barberImages = self.shopDetail?.gallery {
            self.pageControl.numberOfPages = barberImages.count
        }
        self.pageControl.isUserInteractionEnabled = false
        _updateDots(self.pageControl)
        self.collectionView.reloadData()
    }
    
    fileprivate func _updateDots(_ pageControl: UIPageControl) {
        DispatchQueue.main.async {
            for i in 0 ..< pageControl.subviews.count {
                let dot: UIView = pageControl.subviews[i]
                if i == pageControl.currentPage {
                    dot.backgroundColor = .red
                    dot.layer.cornerRadius = dot.frame.size.height / 2
                }
                else {
                    dot.backgroundColor = .clear
                    dot.layer.cornerRadius = dot.frame.size.height / 2
                    dot.layer.borderColor = UIColor.red.cgColor
                    dot.layer.borderWidth = 1
                }
            }
        }
    }
    
    // MARK:  UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.height
        self.pageControl.currentPage = Int(scrollView.contentOffset.y / pageWidth)
        _updateDots(self.pageControl)
    }
}

extension BRDBarbrDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let barbers = self.shopDetail?.barberArray {
            return barbers.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BRD_Customer_AppointmentDetail_TableViewCell = tableView.dequeueReusableCell(withIdentifier: KBRD_Customer_AppointmentDetail_TableViewCell_CellIdentifier) as! BRD_Customer_AppointmentDetail_TableViewCell
        if let barbers: [BRD_BarberInfoBO] = self.shopDetail?.barberArray { //if
            if barbers.count > indexPath.row {
                let barber = barbers[indexPath.row]
                
                
                if let rating = barber.ratings{
                    var rateValue: Float = 0
                    for item in rating{
                        rateValue = rateValue + item.score!
                    }
                    
                    let avg: Float = rateValue / Float(rating.count)
                    cell.starRaringView.value = CGFloat(avg)
                    
                }else{
                    cell.starRaringView.value = 0
                }
                
                if let firstname = barber.first_name {
                    cell.lblName.text = firstname
                    if let lastname = barber.last_name {
                        cell.lblName.text = "\(firstname) \(lastname)"
                    }
                }
                if let createDate = barber.created_date {
                    let dateString = Date.convert(createDate, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMMM_dd)
                    cell.lblMemberSince.text = dateString
                }
                
                if barber.picture != nil{
                    let imagePath = KImagePathForServer + barber.picture!
                    cell.profileImageView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                        
                        DispatchQueue.main.async(execute: {
                            if image != nil{
                                cell.profileImageView.image = image
                            }else{
                                cell.profileImageView.image = UIImage.init(named: "ICON_PROFILEIMAGE")
                            }
                            cell.activityIndicator.stopAnimating()
                            cell.activityIndicator.hidesWhenStopped = true
                        })
                    })
                }else{
                    cell.activityIndicator.stopAnimating()
                    cell.activityIndicator.hidesWhenStopped = true
                }
            }
        }
        cell.btnBook.addTarget(self, action: #selector(_bookButtonAction(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header:BRD_Customer_AppointmentDetail_BarberShopAddress_TableViewCell = tableView.dequeueReusableCell(withIdentifier: KBRD_Customer_AppointmentDetail_BarberShopAddress_TableViewCell_CellIdenfier) as! BRD_Customer_AppointmentDetail_BarberShopAddress_TableViewCell
        var address = ""
        
        if let shopName = self.shopDetail?.name{
            address = shopName + "\n"
        }else{
            address = "Pop's Barber Shop" + "\n"
        }
        if let shopDetails = self.shopDetail?.address {
            address = address + shopDetails + ", \n"
        }
        if let city = self.shopDetail?.city {
            address = address + city + ", "
        }
        if let state = self.shopDetail?.state {
            address = address + state
        }
        header.lblAddress.text = address
        
        
        header.btnShowOnMap.addTarget(self, action: #selector(btnShowOnMapAction), for: .touchUpInside)
        return header
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let barbers: [BRD_BarberInfoBO] = self.shopDetail?.barberArray{
            
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "BRD_ViewProfileVC") as? BRD_ViewProfileVC {
                vc.objBarber = barbers[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 109.5
    }
    
    @objc private func btnShowOnMapAction(){
        
        if self.viewOnMapShopDetal?.latitude != nil && self.viewOnMapShopDetal?.longitude != nil{
            
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_GoogleMapsVC_StoryboardID) as! BRD_GoogleMapsVC
            vc.arrayViewShop =  [self.viewOnMapShopDetal!]
            vc.shouldHideButton = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Could not get of the Shop", onViewController: self, returnBlock: { (clickedIN) in
                
            })
        }
    }
    @objc fileprivate func _bookButtonAction(_ button: UIButton) {
        let indexPath = BRDUtility.indexPath(self.tableView, button)
        if let barbers = self.shopDetail?.barberArray {
            if barbers.count > indexPath.row {
                let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: BRDBookAppointmentVC.identifier()) as? BRDBookAppointmentVC {
                    vc.barberDetails = barbers[indexPath.row]
                    vc.shopDetail = self.shopDetail!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

extension BRDBarbrDetailVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    // MARK:  UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let barberImages = self.shopDetail?.gallery, barberImages.count > 0 {
            return barberImages.count
        }
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BRDCollectionViewCell.identifier(), for: indexPath) as? BRDCollectionViewCell {
            cell.backgroundColor = .clear
            cell.imageView.image = #imageLiteral(resourceName: "ICON_SALOON")
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    // MARK:  UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.bounds.width, height:200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK:  UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}
