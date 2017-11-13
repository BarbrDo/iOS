//
//  BRD_Barber_CalenderEventsVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 23/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//


//
//  ViewController.swift
//  MapDemo
//
//  Created by Mahesh Kumar on 22/05/17.
//  Copyright © 2017 Mahesh Kumar. All rights reserved.
//

import UIKit

class TimeTableViewCell : UITableViewCell{
    //Mark
    @IBOutlet weak var timeLbl: UILabel!
    
    
    
}

class BRD_Barber_CalenderEventsVC: BRD_BaseViewController , UITableViewDelegate ,UITableViewDataSource {
    
    //Mark
    var timeDisplayArray = ["8 AM","9 AM","10 AM","11 AM","12 PM","1 PM","2 PM","3 PM","4 PM","5 PM","6 PM","7 PM","8 PM"]
    
    //Markk
    
    @IBOutlet weak var currentDate: UILabel!
    var dateCounter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addTopNavigationBar(title: "")

        let dateString = Date.stringFromDate(Date(), Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        currentDate.text =  Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.EEEE_dd_MMMM)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark -
    
    @IBAction func acnNextDate(_ sender: Any) {
        
        dateCounter = dateCounter + 1
        //Mark
        let value = (Calendar.current as NSCalendar).date(byAdding: .day, value: dateCounter, to: Date(), options: [])!
        
        //Mark
            
        let dateString = Date.stringFromDate(value, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        currentDate.text =  Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.EEEE_dd_MMMM)
    }
    
    
    @IBAction func acnPreviousDate(_ sender: Any) {
        //Mark
        dateCounter = dateCounter - 1
        let value =   (Calendar.current as NSCalendar).date(byAdding: .day, value: dateCounter, to: Date(), options: [])!
        
        //Mark
        let dateString = Date.stringFromDate(value, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z)
        currentDate.text =  Date.convert(dateString, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_z, Date.DateFormat.EEEE_dd_MMMM)
    }
    
    @IBAction func addEventAction(){
        //Mark
        let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateEventVC") as! CreateEventVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    //MARK : TableViewDelegate/DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeDisplayArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //mark
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TimeTableViewCell
        cell?.timeLbl.text = timeDisplayArray[indexPath.row]
        return cell!
    }
    
  
}

