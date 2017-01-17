//
//  AirplayConstants.swift
//  AirPlayDemo
//
//  Created by fenrir-cd on 17/1/12.
//  Copyright © 2017年 fenrir CD. All rights reserved.
//

import UIKit

class AirplayConstants: NSObject {

    enum ScreenStatus{
        case Connected
        case Disconnected
    }
    struct Notifications{
        static let ScreenDidConnected = "AirplayConstants.Notifications.ScreenDidConnected";
        static let ScreenDidDisconnected = "AirplayConstants.Notifications.ScreenDidDisconnected";
        static let ViewControllerDidUpdate = "AirplayConstants.Notifications.ViewControllerDidUpdate";
    }
}
