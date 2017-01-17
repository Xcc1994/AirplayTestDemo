//
//  AirplayService.swift
//  AirPlayDemo
//
//  Created by fenrir-cd on 17/1/12.
//  Copyright © 2017年 fenrir CD. All rights reserved.
//

import UIKit
protocol AirplayScreenDelegate {
    func didConnectScreen(screen:UIScreen)
    func didDisconnectScrren(screen:UIScreen)
}

class AirplayService: NSObject {
    private static var _service : AirplayService?
    internal static var sharedService: AirplayService{
        if _service == nil {
            _service = AirplayService()
        }
        return _service!
    }
    //Airplay 扩展屏幕
    internal var screenWindow:UIWindow?
    
    //当前屏幕所显示ViewController
    var currentViewController : AirplayViewController?
    
    //检测Airplay连接状态
    var screenStatus:AirplayConstants.ScreenStatus = .Disconnected
    
    private override init() {
        super.init()
        self.beginReceivingScreenNotification()
    }
    
}
extension AirplayService:AirplayScreenDelegate {
    //已经连接
    @objc func didConnectScreen(screen: UIScreen) {
        if currentViewController == nil {
            let defalutScreen =  DefalutViewController()
            currentViewController = defalutScreen
        }
        if screenWindow == nil {
            let window = UIWindow(frame: screen.bounds)
            screenWindow = window
            screenWindow?.rootViewController = currentViewController
            screenWindow?.isHidden = false
        }
        screenStatus = .Connected
        screenWindow?.screen = screen
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AirplayConstants.Notifications.ScreenDidConnected), object: nil)
    }
    //断开连接
    @objc func didDisconnectScrren(screen: UIScreen) {
        screenStatus = .Disconnected
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AirplayConstants.Notifications.ScreenDidDisconnected), object: nil)
    }
}
extension AirplayService {
    //开始Airplay监听
    func beginReceivingScreenNotification() {
        //首先检查是否已经连接了
        connectScreen()
        //启动监听
        NotificationCenter.default.addObserver(self, selector: #selector(AirplayService.didReceiveConnectScreenNotification(noti:)), name: NSNotification.Name.UIScreenDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AirplayService.didReceiveDisConnectScreenNotification(noti:)), name: NSNotification.Name.UIScreenDidDisconnect, object: nil)
    }
    
    //关闭Airplay监听
    func closeReceivingScreenNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: AirplayConstants.Notifications.ScreenDidConnected), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: AirplayConstants.Notifications.ScreenDidDisconnected), object: nil)
    }
    @objc func didReceiveConnectScreenNotification(noti:NSNotification) {
        let screen:UIScreen = noti.object as! UIScreen
        self.didConnectScreen(screen: screen)
    }
    
    @objc func didReceiveDisConnectScreenNotification(noti:NSNotification) {
        let screen:UIScreen = noti.object as! UIScreen
        self.didDisconnectScrren(screen: screen)
    }
    
}
extension AirplayService {
    //连接Airplay Screen
    func connectScreen() {
        if UIScreen.screens.count > 1 {
            UIScreen.screens.forEach({[weak self] (screen:UIScreen) in
                if screen != UIScreen.main {
                    self?.didConnectScreen(screen: screen)
                }
            })
        }
    }
    //断开Airplay Screen
    func disconnectScreen() {
        if self.screenWindow != nil {
            screenWindow?.isHidden = true
            screenWindow?.removeFromSuperview()
            self.screenWindow = nil
        }
    }
    //显示默认的Screen
    func showDefalutScreen() {
        let defalutScreen = DefalutViewController()
        self.updateViewController(viewController: defalutScreen, animation: true)
    }
    
   @discardableResult func updateViewController(viewController:AirplayViewController,animation:Bool) -> Bool{
        guard screenWindow != nil else {
            return false
        }
        currentViewController?.airplayViewWillClose()
        currentViewController = viewController
        screenWindow?.rootViewController?.removeFromParentViewController()
        screenWindow?.rootViewController?.navigationController?.removeFromParentViewController()
        screenWindow?.rootViewController = nil
        screenWindow?.rootViewController = currentViewController
        currentViewController?.view.frame = (screenWindow?.bounds)!
        currentViewController?.view.layoutIfNeeded()
        currentViewController?.airplayViewWillShow()
        if animation {
            let maskView:UIView = UIView(frame: (currentViewController?.view.frame)!)
            maskView.backgroundColor = UIColor.black
            self.currentViewController?.view.addSubview(maskView)
            UIView.animate(withDuration: 0.5, animations: { 
                maskView.alpha = 0
            }, completion: { (finish:Bool) in
                maskView.removeFromSuperview()
                
            })
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AirplayConstants.Notifications.ViewControllerDidUpdate), object: nil)
        return true
    }
    
    func getScreenSize() -> CGSize? {
        guard screenWindow != nil else {
            return nil
        }
        return screenWindow?.bounds.size
    }
    
}
