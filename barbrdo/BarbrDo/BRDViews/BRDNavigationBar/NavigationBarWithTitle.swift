//
//  NavigationBarWithTitle.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 03/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class NavigationBarWithTitle: UITableViewCell {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblScreenTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func initWithTitle(title: String){
        
        self.lblScreenTitle.text = title
    }
    
}
