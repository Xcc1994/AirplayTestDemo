//
//  UIColor+Extension.swift
//  AirPlayDemo
//
//  Created by fenrir-cd on 17/1/12.
//  Copyright © 2017年 fenrir CD. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func randomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
        let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        return UIColor(red:red, green:green, blue:blue , alpha: 1)
    }
}

