//
//  BRD_TextField.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 19/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_TextField: UITextField {
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
   
    // placeholder position
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 30, dy: 0)
    }
    // text position
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: 40, dy: 0)
        return bounds.offsetBy(dx: 30, dy: 0)
    }
    
    func setPlaceholder(placeholderString: NSString, color:UIColor) -> Void{
        
        self.attributedPlaceholder = NSAttributedString(string:placeholderString as String,attributes:[NSForegroundColorAttributeName: color])
    }
    
    
}

extension UITextField {
    
    func addImage(name: String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 20, height: 20))
        imageView.image = UIImage(named: name)
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
    }
}


