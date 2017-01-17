//
//  ViewController.swift
//  AirPlayDemo
//
//  Created by fenrir-cd on 17/1/12.
//  Copyright © 2017年 fenrir CD. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var changeBackgroundColorBtn: UIButton!
    @IBOutlet weak var setDefalutScreenVCBtn: UIButton!
    @IBOutlet weak var goHomeVCBtn: UIButton!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AirplayService.sharedService.showDefalutScreen()
    }


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func goHomeVC(_ sender: UIButton) {
        if AirplayService.sharedService.screenStatus == .Connected {
            goHomeVCBtnIsShow(isShow: false)
            let airplayVC:AirplayViewController = UIStoryboard.init(name: Constants.UIStoryboardNames.Airplay, bundle: nil).instantiateViewController(withIdentifier: Constants.VCwithIdentifiers.AirplayHomeViewController) as! AirplayHomeViewController
            AirplayService.sharedService.updateViewController(viewController: airplayVC, animation: true)
        }else{
            showAlter(message: "未连接Airplay")
        }
    }
    @IBAction func changeBackgroundColor(_ sender: UIButton) {
        if AirplayService.sharedService.screenStatus == .Connected {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.ChangeBackgroundColor), object: nil)
          }else{
            showAlter(message: "未连接Airplay")
        }
    }
    
    @IBAction func setDefalutScreenVC(_ sender: UIButton) {
        if AirplayService.sharedService.screenStatus == .Connected {
            goHomeVCBtnIsShow(isShow: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.SetDefalutScreenVC), object: nil)
        }else{
             showAlter(message: "未连接Airplay")
        }
       
    }
}
extension ViewController {
    func showAlter(message:String?) {
        let alter = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let cancleBtn = UIAlertAction(title: "好的", style: .default, handler: nil)
        alter.addAction(cancleBtn)
        self.present(alter, animated: true, completion: nil)
    }
    func goHomeVCBtnIsShow(isShow:Bool) {
        goHomeVCBtn.isHidden = !isShow
        setDefalutScreenVCBtn.isHidden = isShow
        changeBackgroundColorBtn.isHidden = isShow
    }
}
