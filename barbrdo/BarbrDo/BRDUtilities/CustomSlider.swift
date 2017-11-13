//
//  CustomSlider.swift
//  BarbrDo
//
//  Created by Shami Kumar on 12/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        
        //keeps original origin and width, changes height, you get the idea
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 10.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    //while we are here, why not change the image here as well? (bonus material)
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
}
