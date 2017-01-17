//
//  AirplayHomeViewController.swift
//  AirPlayDemo
//
//  Created by fenrir-cd on 17/1/12.
//  Copyright © 2017年 fenrir CD. All rights reserved.
//

import UIKit

class AirplayHomeViewController: AirplayViewController {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(changeBackgroundColor(noti: )), name: NSNotification.Name(rawValue: Constants.Notifications.ChangeBackgroundColor), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDefalutScreenVC(noti: )), name: NSNotification.Name(rawValue: Constants.Notifications.SetDefalutScreenVC), object: nil)
    }

    func changeBackgroundColor(noti:Notification) {
        self.view.backgroundColor = UIColor.randomColor()
    }
    

    func setDefalutScreenVC(noti:Notification) {
        AirplayService.sharedService.showDefalutScreen()
    }

    
}
