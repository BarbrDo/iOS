//
//  BRD_UIButton.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 08/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_UIButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
//        layer.cornerRadius = 5.0
        clipsToBounds = true
//        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        setTitleColor(tintColor, forState: .Normal)
//        setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
//        setBackgroundImage(UIImage(color: tintColor), forState: .Highlighted)
    }

}

extension UIButton {
    
    func addImage(name: String) {
        let imageView = UIImageView(frame: CGRect(x: self.frame.width - 10, y: 10, width: 10, height: 10))
        imageView.image = UIImage(named: name)
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        
    }
    
    func addLabel() {
        let lbl = UILabel.init(frame: CGRect(x:20, y:28, width: 80, height: 1))
        lbl.backgroundColor = UIColor.darkGray
        self.addSubview(lbl)
    }
}
