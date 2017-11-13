//
//  BRD_Barber_FinancialCenterVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/18/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import Charts
import SwiftLoader
let KBRD_Barber_FinancialCenterVC_StoryboardID = "BRD_Barber_FinancialCenterVC_StoryboardID"

class BRD_Barber_FinancialCenterVC: BRD_BaseViewController {
    
    var btnTimeEvent: Int = 0
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var totalAptLbl: UILabel!
    @IBOutlet weak var dateRangeTotalSaleLlbl: UILabel!
    @IBOutlet weak var endDateTf: UITextField!
    @IBOutlet weak var startdateTf: UITextField!
    @IBOutlet weak var weekAmountLbl: UILabel!
    @IBOutlet weak var totalMonthLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var chartView: BarChartView!
    var xAxis: XAxis? = XAxis()
    var startDate : String? = ""
    var endDate : String? = ""
    var barberSale : BarberSale?
    var shouldHideData : Bool?
    var valueArray : [Int]? = [Int]()
    var appointmentArray : [Int]? = [Int]()
    var appointmentDateArray : [String]? = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.EEE_MM_dd
        let date = Date()
        endDate   = self.dashedStringFromDate(date)
        let sevenDaysAgo: Date? = date.addingTimeInterval(-7 * 24 * 60 * 60)
        startDate = self.dashedStringFromDate(sevenDaysAgo!)
        self.startdateTf.text = self.convertDateToMMDDYY(obj: startDate!)
        self.endDateTf.text = self.convertDateToMMDDYY(obj: endDate!)
        self.getAllData( startDate! ,  endDate! )
       // self.addTopNavigationBar(title: "")
        self.datePicker.maximumDate = Date()

        self.datePicker.addTarget(self, action: #selector(dateChangeAction(sender:)), for: .valueChanged)

        
        let header : NavigationBarWithTitleAndBack = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitleAndBack.self), owner: self, options: nil)![0] as! NavigationBarWithTitleAndBack
        header.btnBack.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        header.btnProfile.addTarget(self, action: #selector(btnProfileMenu), for: .touchUpInside)
        header.initWithTitle(title: "Finance Center")
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

    
    func drawChartView()
    {
        chartView.chartDescription?.enabled = false
        chartView.pinchZoomEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.highlightFullBarEnabled = false
        chartView.isUserInteractionEnabled = true
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.positivePrefix = " $"
        let leftAxis: YAxis? = chartView.leftAxis
        leftAxis?.valueFormatter = DefaultAxisValueFormatter.init(formatter: leftAxisFormatter)
        leftAxis?.axisMinimum = 0.0
        // this replaces startAtZero = YES
        chartView.rightAxis.enabled = false
        xAxis = chartView.xAxis
        xAxis?.labelPosition = .bottom
        let l: Legend? = chartView.legend
        l?.horizontalAlignment = .right
        l?.verticalAlignment = .bottom
        l?.orientation = .horizontal
        l?.drawInside = false
        l?.form = .square
        l?.formSize = 8.0
        l?.formToTextSpace = 4.0
        l?.xEntrySpace = 6.0
        xAxis?.drawGridLinesEnabled = false
        xAxis?.drawAxisLineEnabled = false
        self.chartView.legend.enabled = false
        chartView.isUserInteractionEnabled = false

        self.chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: ChartEasingOption.easeOutBack)
           }
    
    func updateChartData() {
        //        if shouldHideData! {
        //            chartView.data = nil
        //            return
        //        }
        
        if((self.valueArray?.count)! > 0)
        {
        
        let formatter1 = ChartStringFormatter()
        self.xAxis?.valueFormatter = formatter1
        formatter1.monthValues =  self.appointmentDateArray
        self.chartView.xAxis.granularity = 1
        setDataCount((valueArray?.count)!, range: 0)
        }
        else
        {
            self.chartView.clear()
        }
    }
    func setDataCount(_ count: Int, range: Double) {
        var yVals = [Any]()
        for i in 0..<count {
            let val1 = valueArray?[i]
            let val2 = appointmentArray?[i]
            yVals.append(BarChartDataEntry(x: Double(i), yValues: [Double((val1)!), Double((val2)!)], icon: UIImage(named: "icon")))
        }
        var set1: BarChartDataSet? = nil
        //        if (chartView.data?.dataSetCount)! > 0 {
        //            set1 = (chartView.data?.dataSets[0] as? BarChartDataSet)
        //            set1?.values = yVals as! [ChartDataEntry]
        //            chartView.data?.notifyDataChanged()
        //            chartView.notifyDataSetChanged()
        //        }
        //        else {
        set1 = BarChartDataSet(values: yVals as? [ChartDataEntry], label: "")
        set1?.drawIconsEnabled = false
        
        set1?.colors = [UIColor.init(colorLiteralRed: 85.0/255.0, green: 122.0/255.0, blue: 254.0/255.0, alpha: 1) ,UIColor.init(colorLiteralRed: 52.0/255.0, green: 79.0/255.0, blue: 181.0/255.0, alpha: 1)]
        //        set1?.isVisible = false
        set1?.stackLabels = ["", ""]
        var dataSets = [Any]()
        dataSets.append(set1)
        
        
        let formatter = NumberFormatter()
        //            formatter.maximumSignificantDigits = 0
        //            formatter.textAttributesForPositiveInfinity = ["mon","sun","tue","wed","thu","fri","sat"]
        formatter.negativeSuffix = " $"
        formatter.positiveSuffix = " $"
        let data = BarChartData(dataSets: dataSets as? [IChartDataSet])
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: CGFloat(7.0)))
        //            data.setValueFormatter(DefaultValueFormatter(formatter))
        //            data.setValueFormatter(formatter as! IValueFormatter)
        
        data.setValueTextColor(UIColor.clear)
        chartView.fitBars = true
        chartView.data = data
        //        }
        
        
    }
    func dashedStringFromDate(_ obj : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: obj)
    }
    func getAllData(_ startDate1 : String , _ endDate1 : String)
    {
        
        var totalSale : Int? = 0
        var totalAppointments : Int? = 0
        self.appointmentDateArray?.removeAll()
        self.appointmentArray?.removeAll()
        self.valueArray?.removeAll()
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{return}
        
        SwiftLoader.show("Loading ...", animated: true)
        
        
        
        let urlString = KBaseURLString + kBarberSale + "/" + startDate1 + "/" + endDate1
        
        BRDAPI.getBarberSale("GET", inputParameters: nil, header: header!, urlString: urlString) { (response, arrayServices, status, error) in
            
            SwiftLoader.hide()
            //            self.arrayTableView.removeAll()
            if(arrayServices != nil)
            {
                
                if  (arrayServices?.count)! > 0
                    
                {
                    BRDSingleton.removeEmptyMessage(self.view)
                    
                    for obj in arrayServices!
                    {
                        self.barberSale = obj
                    }
                    
                    //Need to sort date here
//                    var ready = self.barberSale!.custom.sorted(by: { $0.compare($1) == .orderedDescending })

                    
                    
                    
                  let theAppointmentArray =  self.barberSale!.custom!.sorted(by: { $0.appointmentDate!.compare($1.appointmentDate!) == .orderedAscending })
                    
                    for i in 0..<theAppointmentArray.count
                    {
                        self.valueArray?.append((theAppointmentArray[i].sale)!)
                        self.appointmentArray?.append((theAppointmentArray[i].appointments )!)
                        self.appointmentDateArray?.append(self.convertDateString(obj:  (theAppointmentArray[i].appointment_Date )!)!)
                        if let sale = self.barberSale?.custom![i].sale
                        {
                            totalSale  = (totalSale! + sale)
                            print("Total Sale is",totalSale)
                            let floatSale: Float = Float(totalSale!)
                            self.dateRangeTotalSaleLlbl.text = String(format : "$%.2f",floatSale)
                        }
                        
                        if let appointment = self.barberSale?.custom![i].appointments
                        {
                            totalAppointments  = (totalAppointments! + appointment)
                            
                            self.totalAptLbl.text = String(format : "%d",totalAppointments!)

                        }
                        
                        if (self.barberSale?.totalSale?.count)! > 0{
                             self.totalAmountLbl.text = String(format : "$%.2f",(self.barberSale?.totalSale?[0].total_sale)!)
                        }
                        
                        if (self.barberSale?.monthSale?.count)! > 0{
                            self.totalMonthLbl.text = String(format : "$%.2f",(self.barberSale?.monthSale?[0].total_sale)!)
                        }
                        
                        if (self.barberSale?.weekSale?.count)! > 0 {
                            
                            self.weekAmountLbl.text = String(format : "$%.2f",(self.barberSale?.weekSale?[0].total_sale)!)
                        }
                        self.drawChartView()
                        self.updateChartData()

                                }
                    
                }
                
                
                           }
            else
            {
                self.view.addSubview(BRDSingleton.showEmptyMessage("No chairs", view: self.view))
            }
            
            
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                    
                })
                return
            }
        }
        
    }
    
    func convertDateString(obj: String) -> String?{
        let myDate = obj //obj.appointment_date // "2016-06-20T13:01:46.457+02:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:myDate)!
        dateFormatter.dateFormat = "MMM dd"
        let dateString = dateFormatter.string(from:date)
        
        
        return dateString
    }
    
    func convertDateToMMDDYY(obj: String) -> String?{
        let myDate = obj //obj.appointment_date // "2016-06-20T13:01:46.457+02:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:myDate)!
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let dateString = dateFormatter.string(from:date)
        
        
        return dateString
    }
    
    
    @IBAction func endDateAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if(sender.isSelected){
            self.dateView.isHidden = false
        }else{
            self.dateView.isHidden = true
        }
    }
    @IBAction func startDateAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btnTimeEvent =   sender.tag
        if(sender.isSelected){
            self.dateView.isHidden = false
        }
        else{
            self.dateView.isHidden = true
        }
    }
    @IBAction func cancelAction(_ sender: Any) {
        
        self.dateView.isHidden = true
    }
    
    @IBAction func dateAction(_ sender: Any) {
        self.dateView.isHidden = true
        
        
        
    }
    
    func dateChangeAction(sender: UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.EEE_MM_dd
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = Date.DateFormat.yyyy_MM_dd
        
        
        if self.btnTimeEvent == 103
        {
            self.startdateTf.text = dateFormatter.string(from: sender.date)
            startDate = dateFormatter1.string(from: sender.date)
            
            
        }else if self.btnTimeEvent == 104{
            self.endDateTf.text = dateFormatter.string(from: sender.date)
            endDate = dateFormatter1.string(from: sender.date)
        }
        
        if(self.endDateTf.text == ""){
            _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: "Please Select the end date", onViewController: self, returnBlock: { (clickedIN) in
            })
        }else if(self.startdateTf.text == "")
        {
            _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: "Please Select the start date", onViewController: self, returnBlock: { (clickedIN) in
                
                
            })
        }
            
        else
        {
            self.getAllData(startDate!,  endDate!)
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
