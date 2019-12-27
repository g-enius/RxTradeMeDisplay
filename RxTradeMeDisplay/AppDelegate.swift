//
//  AppDelegate.swift
//  RxTradeMeDisplay
//
//  Created by Charles on 27/12/19.
//  Copyright © 2019 SKY. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let testing = NSClassFromString("XCTest") != nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //avoid creating the app’s navigation and view controllers during testing
        if !testing {
            
        }
        
        return true
    }

}

