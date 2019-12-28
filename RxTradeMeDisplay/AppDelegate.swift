//
//  AppDelegate.swift
//  RxTradeMeDisplay
//
//  Created by Charles on 27/12/19.
//  Copyright © 2019 SKY. All rights reserved.
//

import UIKit
import Moya

fileprivate let consumerKey = "A1AC63F0332A131A78FAC304D007E7D1"
fileprivate let consumerSecret = "EC7F18B17A062962C6930A8AE88B16C7"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let testing = NSClassFromString("XCTest") != nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Avoid creating the app’s navigation and view controllers during testing
        if !testing {
            let service = MoyaProvider<APIService>(
                plugins: [
                    NetworkLoggerPlugin(),
                    CustomizedAuthPlugin(OAuthBlock: {
                        return "OAuth oauth_consumer_key=\(consumerKey), oauth_signature_method=PLAINTEXT, oauth_signature=\(consumerSecret)&"
                    })
            ])
            
            let sceneCoordinator = SceneCoordinator(window: window!)
            let categoryViewModel = CategoryViewModel(sceneCoordinator: sceneCoordinator, service: service)
            let firstScene = Scene.category(categoryViewModel)
            
            //You can use a different startup scene if needed; for example, a tutorial that runs the first time the user opens your application.
            sceneCoordinator.transition(to: firstScene, type: .root)
        }
        
        return true
    }

}

