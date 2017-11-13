//
//  BRD_Shop_FinancialCenterVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 6/1/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import Charts
import SwiftLoader

let KBRD_Shop_FinancialCenter_StoryboardID = "BRD_Shop_FinancialCenterVCStoryboardID"
class BRD_Shop_FinancialCenterVC: BRD_BaseViewController {

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
    var shopSale : ShopSale?
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
        self.addTopNavigationBar(title: "")
        self.datePicker.addTarget(self, action: #selector(dateChangeAction(sender:)), for: .valueChanged)
        
        
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
        chartView.isUserInteractionEnabled = false
        xAxis?.drawGridLinesEnabled = false
        xAxis?.drawAxisLineEnabled = false
        self.chartView.legend.enabled = false
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
        
        let shopId = BRDSingleton.sharedInstane.objShop_id! + "/" + startDate1 + "/" + endDate1
        
        let urlString = KBaseURLString + kShopSale + "/" + shopId
        
        BRDAPI.getShopSale("GET", inputParameters: nil, header: header!, urlString: urlString) { (response, arrayServices, status, error) in
            
            SwiftLoader.hide()
            //            self.arrayTableView.removeAll()
            if(arrayServices != nil)
            {
                
                if  (arrayServices?.count)! > 0
                    
                {
                    BRDSingleton.removeEmptyMessage(self.view)
                    
                    for obj in arrayServices!
                    {
                        self.shopSale = obj
                    }
                    
                    for i in 0..<self.shopSale!.shopcustom!.count
                    {
                        
//                        print(self.barberSale!.custom![i].sale!)
                        
                        self.valueArray?.append((self.shopSale?.shopcustom![i].shop_sale)!)
                        self.appointmentArray?.append((self.shopSale?.shopcustom![i].appointments )!)
                        self.appointmentDateArray?.append(self.convertDateString(obj:  (self.shopSale?.shopcustom![i].appointment_Date )!)!)
                        if let sale = self.shopSale?.shopcustom![i].shop_sale
                        {
                            totalSale  = (totalSale! + sale)
                            
                            self.dateRangeTotalSaleLlbl.text = String(format : "%d",totalSale!)
                        }
                        
                        if let appointment = self.shopSale?.shopcustom![i].appointments
                        {
                            totalAppointments  = (totalAppointments! + appointment)
                            
                            self.totalAptLbl.text = String(format : "%d",totalAppointments!)
                            
                        }
                        
                        self.totalAmountLbl.text = String(format : "$ %.0f",(self.shopSale?.shoptotalSale?[0].price)!)
                        self.totalMonthLbl.text = String(format : "$ %.0f",(self.shopSale?.shopmonthSale?[0].price)!)
                        self.weekAmountLbl.text = String(format : "$ %.0f",(self.shopSale?.shopweekSale?[0].price)!)
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
        
        
        if(sender.isSelected)
        {
            self.dateView.isHidden = false
        }
        else
            
        {
            self.dateView.isHidden = true
            
        }
        
        
        
    }
    @IBAction func startDateAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btnTimeEvent =   sender.tag
        if(sender.isSelected)
        {
            self.dateView.isHidden = false
        }
        else
            
        {
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
            
            
        }
        else if self.btnTimeEvent == 104
        {
            self.endDateTf.text = dateFormatter.string(from: sender.date)
            endDate = dateFormatter1.string(from: sender.date)
            
            
            
        }
        
        if(self.endDateTf.text == "")
        {
            _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: "Please Select the end date", onViewController: self, returnBlock: { (clickedIN) in
                
                
            })
        }
        else if(self.startdateTf.text == "")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
