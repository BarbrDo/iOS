		//
//  BRDProfileVC.swift
//  BarbrDo
//
//  Created by Vishwajeet Kumar on 5/10/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

class BRDBookAppointmentCell: UICollectionViewCell {
    
    // label
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "BRDBookAppointmentCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.timeLabel.layer.cornerRadius = 5.0
        self.timeLabel.clipsToBounds = true
    }
}

fileprivate enum ButtonType: Int {
    case previousDate = 1
    case nextDate
    case morning
    case afternoon
    case evening
    case next
}

enum SelectionType {
    case morning
    case afternoon
    case evening
}

fileprivate let spacBetweenCell: CGFloat    =    5.0
fileprivate let cellHeight: CGFloat         =    44.0
fileprivate let noOfRowInCell: CGFloat      =    4.0
fileprivate let customRedColor              =    UIColor.color(204, 33, 42)
fileprivate let lightBlueColor              =    UIColor.color(117, 146, 252)

class BRDBookAppointmentVC: BRD_BaseViewController {
    
    // imageView
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // view
    @IBOutlet weak var ratingView: SwiftyStarRatingView!
    @IBOutlet weak var viewNavigationBar: UIView!
    // label
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calenderDateLabel: UILabel!
    
    // imageView
    @IBOutlet weak var morningImageView: UIImageView!
    @IBOutlet weak var afternoonImageView: UIImageView!
    @IBOutlet weak var eveningImageView: UIImageView!
    
    // collectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    // button
    @IBOutlet weak var nextButton: UIButton!
    
    private var layout = UICollectionViewFlowLayout()
    fileprivate var seletedType: SelectionType?
    fileprivate var timeSlots: BRDTimeSlot?
    fileprivate var times: [Any] = [Any]()
    fileprivate var selectedTime: String = String()
    fileprivate var selectedDate: String = String()
    
    fileprivate var dateByAdding: Int = Int()
    
    var shopDetail: BRD_ShopDataBO? = nil
    var barberDetails: BRD_BarberInfoBO? = nil
    
    
    var objBarberAppointments: BRD_AppointmentsInfoBO? = nil
    var apiDateFormat: String? = nil
    fileprivate var strDateTime: String? = nil
    fileprivate var strCalendarSelectedDate: String? = nil
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "BRDBookAppointmentVC"
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = Bundle.main.loadNibNamed(String(describing: BRD_TopBar.self), owner: self, options: nil)![0] as? BRD_TopBar
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:75)
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        header?.btnProfile.addTarget(self, action: #selector(btnProfileAction), for: .touchUpInside)
        
        
        self.profileImageView?.layer.borderWidth = 1
        self.profileImageView?.layer.masksToBounds = false
        self.profileImageView?.layer.cornerRadius = (self.profileImageView?.frame.height)!/2
        self.profileImageView?.clipsToBounds = true
        self.profileImageView?.layer.borderColor = UIColor.white.cgColor

        self.viewNavigationBar.addSubview(header!)
        
        if self.barberDetails == nil{
            // Call Barber Detail API
            
            let dictionary = [KLatitude: "30.538994",
                              KLongitude:"75.955033",
                              KUserID:(self.objBarberAppointments?.barber_id?._id)!]
            
            self.getBarberDetails(inputParameter: dictionary)
            
        }else{
            _initialization()
        }
        
    }
    
    func getBarberDetails(inputParameter: [String: Any]){
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
            
            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: KLocationServices, onViewController: self, returnBlock: { (clickedIN) in
            })
            
            return
        }
        
        BRD_BarberDataBOBL.initWithParameters("GET", inputParameters: nil, header: header!, urlComponent: KViewAllBarbersURL) { (obj, error) in
            //self.hideLoader()
            
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
                return
            }
            
            if (obj?.count)! > 0{
//                self.arrayTableView.removeAll()
//                self.arrayTableView = obj!
//                self.duplicateArray = obj!
//                self.tableView.reloadData()
                for dataObj in obj!{
                    
                    if dataObj._id == self.objBarberAppointments?.barber_id?._id{
                        self.barberDetails = dataObj
                        self._initialization()
                        break
                    }else if dataObj._id == self.barberDetails?._id{
                        self.barberDetails = dataObj
                        self._initialization()
                    }
                }
            }
        }

    }
    
    func backButtonAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    func btnProfileAction() {
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_Profile_StoryboardID) as! BRD_Customer_ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Memory Management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Button Action
    @IBAction func buttonsAction(_ sender: Any) {
        if let button = ButtonType(rawValue: (sender as AnyObject).tag) {
            switch button {
            case .previousDate:
                _previousDateButton()
            case .nextDate:
                _nextDateButton()
            case .morning:
                _morningButton()
            case .afternoon:
                _afternoonButton()
            case .evening:
                _eveningButton()
            case .next:
                _nextButton()
            }
        }
    }
    
    // MARK: - Private Method
    private func _previousDateButton() {
        
        var currentDate: String = self.calenderDateLabel.text!
        if (self.calenderDateLabel.text?.contains(","))!{
            if let array = self.calenderDateLabel.text?.components(separatedBy: ",")
            {
                currentDate = array[1]
            }
        }
        
        let date1 = Date()
        let calendar = Calendar.current
        let yearr = calendar.component(.year, from: date1)
        
        let combinedString = currentDate + " " + String(describing: yearr)
        
        currentDate = Date.convert(combinedString, Date.DateFormat.MMM_dd_yyyy, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        let currentDD = Date.dateFromString(currentDate, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        
        if currentDD?.compare(date1) == ComparisonResult.orderedAscending{
            return
        }
        
        self.dateByAdding = self.dateByAdding - 1
        _calculateDate()
    }
    private func _nextDateButton() {
        self.dateByAdding = self.dateByAdding + 1
        _calculateDate()
    }
    private func _morningButton() {
        if self.seletedType != .morning {
            _typeSelection(.morning)
        }
    }
    private func _afternoonButton() {
        if self.seletedType != .afternoon {
            _typeSelection(.afternoon)
        }
    }
    private func _eveningButton() {
        if self.seletedType != .evening {
            _typeSelection(.evening)
        }
    }
    
    private func _nextButton() {
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: BRDAppointmentVC.identifier()) as? BRDAppointmentVC {
            if let shopOwner = self.objBarberAppointments?.shop_id{
                if let shopID = shopOwner._id{
                    vc.shopID = shopID
                }
            }
            vc.barberDetails = barberDetails
            vc.shopDetails = self.shopDetail
            vc.timeString = self.selectedTime + " " + self.strDateTime!
            vc.dateString = self.selectedDate
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    // MARK: - API Method
    private func _getTimeSlots() {
                
        if self.apiDateFormat == nil{
            _calculateDate()
        }

        
        var header = BRDSingleton.sharedInstane.getHeaders()
        
        if barberDetails == nil{return}
        
        header?["barber_id"] = barberDetails?._id
        header?["date"] = self.apiDateFormat!
        
        let urlString = KBaseURLString + "barber/timeavailability/" + (barberDetails?._id)!
        let newURl = urlString + "?date=" + self.apiDateFormat! //actualDate
        self.showLoader()
        
        BRDAPI.getAppointmentTimeSlot(headers: header!, urlString: newURl) { (response, timeSlots, status, error) in
            switch status {
            case .success:
                self.timeSlots = nil
                self.timeSlots = timeSlots
                self._typeSelection(.morning)
                self.hideLoader()
            default:
                self.errorHandling(response, status, error)
            }
        }
        
    }
    
    // MARK: - Other Methods
    private func _initialization() {
        self.navigationController?.isNavigationBarHidden = true
        
        if let firstname = barberDetails?.first_name {
            self.nameLabel.text = firstname
            if let lastname = barberDetails?.last_name {
                self.nameLabel.text = "\(firstname) \(lastname)"
            }
        }
        if let createDate = barberDetails?.created_date {
            let dateString = Date.convert(createDate, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMMM_dd)
            self.dateLabel.text = KMemberSince +  dateString
        }
        

        
        if let rating = barberDetails?.ratings{
            var rateValue: Float = 0
            for item in rating{
                rateValue = rateValue + item.score!
            }
            
            let avg: Float = rateValue / Float(rating.count)
            self.ratingView.value = CGFloat(avg)
        }else{
            self.ratingView.value = 0
        }
        
        
        if barberDetails?.picture != nil{
            let imagePath = KImagePathForServer + (barberDetails?.picture)!
            self.profileImageView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                
                DispatchQueue.main.async(execute: {
                    if image != nil{
                        self.profileImageView.image = image
                    }else{
                        self.profileImageView.image = UIImage(named: "ICON_PROFILEIMAGE.PNG")
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                })
            })
        }else{
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
        }
        
        // profile imageView
        self.profileImageView = self.profileImageView.circularImageView()
        self.morningImageView = self.morningImageView.circularImageView()
        self.afternoonImageView = self.afternoonImageView.circularImageView()
        self.eveningImageView = self.eveningImageView.circularImageView()
//        _getTimeSlots()
        _typeSelection(.morning)
        self.nextButton.layer.cornerRadius = 5.0
        
        _calculateDate()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
        self.layout.sectionInset = UIEdgeInsets.zero
        self.layout.minimumInteritemSpacing = spacBetweenCell
        self.layout.minimumLineSpacing = spacBetweenCell
        self.layout.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = layout
    }
    fileprivate func _typeSelection(_ type: SelectionType) {
        self.morningImageView.image = #imageLiteral(resourceName: "inactive_radio")
        self.afternoonImageView.image = #imageLiteral(resourceName: "inactive_radio")
        self.eveningImageView.image = #imageLiteral(resourceName: "inactive_radio")
        self.selectedTime = ""
        self.nextButton.isEnabled = false
        self.nextButton.backgroundColor = .darkGray
        self.times.removeAll()
        self.strDateTime = "AM"
        switch type {
        case .morning:
            self.seletedType = .morning
            if let slots = self.timeSlots {
                if let morningTimes = slots.mornings {
                    self.times = morningTimes
                }
            }
            self.morningImageView.image = #imageLiteral(resourceName: "active_radio")
            self.strDateTime = "AM"
        case .afternoon:
            self.seletedType = .afternoon
            if let slots = self.timeSlots {
                if let afternoonTimes = slots.afternoons {
                    self.times = afternoonTimes
                }
            }
            self.afternoonImageView.image = #imageLiteral(resourceName: "active_radio")
            self.strDateTime = "PM"
        case .evening:
            self.seletedType = .evening
            if let slots = self.timeSlots {
                if let eveningTimes = slots.evenings {
                    self.times = eveningTimes
                }
            }
            self.eveningImageView.image = #imageLiteral(resourceName: "active_radio")
            self.strDateTime = "PM"
        }
        self.collectionView.reloadData()
    }
    
    
    
    private func _calculateDate() {
        if let date = Calendar.current.date(byAdding: .day, value: self.dateByAdding + 1, to: Date()) {
            
            self.strCalendarSelectedDate = Date.stringFromDate(date, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
            
            self.apiDateFormat = Date.convert(self.strCalendarSelectedDate!, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.yyyy_MM_dd)
            
            let dateString = Date.stringFromDate(date, Date.DateFormat.MMMM_dd)
            self.calenderDateLabel.text = dateString
            self.selectedDate = dateString
            let todayString = Date.stringFromDate(Date(), Date.DateFormat.MMMM_dd)
            if dateString == todayString {
                self.calenderDateLabel.text = "Today, \(dateString)"
            }
            if let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
                let yesterDayString = Date.stringFromDate(yesterDay, Date.DateFormat.MMMM_dd)
                if dateString == yesterDayString {
                    self.calenderDateLabel.text = "Yesterday, \(dateString)"
                }
            }
            if let tomorrowDay = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
                let tomorrowDayString = Date.stringFromDate(tomorrowDay, Date.DateFormat.MMMM_dd)
                if dateString == tomorrowDayString {
                    self.calenderDateLabel.text = "Tomorrow, \(dateString)"
                }
            }
        }
        
        _getTimeSlots()
    }
}

extension BRDBookAppointmentVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.times.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BRDBookAppointmentCell.identifier(), for: indexPath) as? BRDBookAppointmentCell {
            cell.backgroundColor = .clear
            cell.timeLabel.backgroundColor = .white
            cell.timeLabel.textColor = .darkGray
            /*if self.times.count > indexPath.item {
                cell.timeLabel.text = self.times[indexPath.item]
                if self.times[indexPath.item] == self.selectedTime {
                    cell.timeLabel.backgroundColor = lightBlueColor
                    cell.timeLabel.textColor = .white
                }
            }*/
            
            if self.times.count > indexPath.item {
                if let typee = self.times[indexPath.item] as? MorningBO{
                    cell.timeLabel.text = typee.time
                    if typee.isAvailable == true{
                        cell.isUserInteractionEnabled = true
                    }else{
                        cell.isUserInteractionEnabled = false
                        cell.timeLabel.textColor = UIColor.white
                        cell.timeLabel.backgroundColor = KVeryLightGreyColor
                    }
                    
                    if typee.time == self.selectedTime && typee.isAvailable == true {
                        cell.timeLabel.backgroundColor = lightBlueColor
                        cell.timeLabel.textColor = .white
                    }
                }else if let typee = self.times[indexPath.item] as? AfternoonBO{
                    cell.timeLabel.text = typee.time
                    if typee.isAvailable == true{
                        cell.isUserInteractionEnabled = true
                    }else{
                        cell.isUserInteractionEnabled = false
                        cell.timeLabel.textColor = UIColor.white
                        cell.timeLabel.backgroundColor = KVeryLightGreyColor
                    }
                    if typee.time == self.selectedTime && typee.isAvailable == true{
                        cell.timeLabel.backgroundColor = lightBlueColor
                        cell.timeLabel.textColor = .white
                    }

                }else if let typee = self.times[indexPath.item] as? EveningBO{
                    cell.timeLabel.text = typee.time
                    if typee.isAvailable == true{
                        cell.isUserInteractionEnabled = true
                    }else{
                        cell.isUserInteractionEnabled = false
                        cell.timeLabel.textColor = UIColor.white
                        cell.timeLabel.backgroundColor = KVeryLightGreyColor
                        
                        
                    }
                    if typee.time == self.selectedTime && typee.isAvailable == true{
                        cell.timeLabel.backgroundColor = lightBlueColor
                        cell.timeLabel.textColor = .white
                    }

                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(collectionView.bounds.width - ((noOfRowInCell - 1) * spacBetweenCell)) / noOfRowInCell, height:cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacBetweenCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacBetweenCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if self.times.count > indexPath.row {
            
            if let typee = self.times[indexPath.item] as? MorningBO{
                if typee.time == self.selectedTime{
                    self.selectedTime = ""
                    self.nextButton.backgroundColor = .darkGray
                    self.nextButton.isEnabled = false
                }else{
                    self.nextButton.backgroundColor = customRedColor
                    self.selectedTime = typee.time!
                    self.nextButton.isEnabled = true
                }
            }else if let typee = self.times[indexPath.item] as? AfternoonBO{
                if typee.time == self.selectedTime{
                    self.selectedTime = ""
                    self.nextButton.backgroundColor = .darkGray
                    self.nextButton.isEnabled = false
                }else{
                    self.nextButton.backgroundColor = customRedColor
                    self.selectedTime = typee.time!
                    self.nextButton.isEnabled = true
                }
            }else if let typee = self.times[indexPath.item] as? EveningBO{
                if typee.time == self.selectedTime{
                    self.selectedTime = ""
                    self.nextButton.backgroundColor = .darkGray
                    self.nextButton.isEnabled = false
                }else{
                    self.nextButton.backgroundColor = customRedColor
                    self.selectedTime = typee.time!
                    self.nextButton.isEnabled = true
                }
            }
            /*if self.times[indexPath.item] == self.selectedTime {
                self.selectedTime = ""
                self.nextButton.backgroundColor = .darkGray
                self.nextButton.isEnabled = false
            }
            else {
                self.nextButton.backgroundColor = customRedColor
                self.selectedTime = self.times[indexPath.item]
                self.nextButton.isEnabled = true
            }*/
            self.collectionView.reloadData()
        }
    }
}



