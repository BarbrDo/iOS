//
//  ChartStringFormatter.swift
//  BarbrDo
//
//  Created by Shami Kumar on 10/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import Charts

class ChartStringFormatter: NSObject, IAxisValueFormatter {
    
    var monthValues: [String]? =  []
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(describing: monthValues![Int(value)])
    }
}
