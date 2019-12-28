//
//  SceneCoordinator.swift
//  RxTradeMeDisplay
//
//  Created by Charles on 28/12/19.
//  Copyright © 2019 SKY. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SceneCoordinator: SceneCoordinatorType {
  fileprivate var window: UIWindow
    
  required init(window: UIWindow) {
    self.window = window
  }
    
  @discardableResult
  func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
    let subject = PublishSubject<Void>()
    //3) Scene Coordinator instantiates the new View Controller
    let viewController = scene.instantiateViewController()
    switch type {
    case .root:
        window.rootViewController = viewController
        
        handleSplitVC(splitVC: viewController as! UISplitViewController)
        subject.onCompleted()
        
    case .push:
        guard let navigationController = SceneCoordinator.topMostViewController().navigationController else {
            fatalError("Can't push a view controller without a current navigation controller")
        }
        // one-off subscription to be notified when push complete
        _ = navigationController.rx
        .didShow
        .map { _ -> Void in }
        .bind(to: subject)
        
        //5) Scene Coordinator pushs/presents second VC
        navigationController.pushViewController(viewController, animated: true)
        
    case .showDetail:
        let splitVC = window.rootViewController as! UISplitViewController
        guard let navigationController = viewController.navigationController else {
            fatalError("Can't show detail a view controller without a current navigation controller")
        }
        
        // one-off subscription to be notified when push complete
        _ = navigationController.rx
        .didShow
        .map { _ -> Void in }
        .bind(to: subject)
        
        splitVC.showDetailViewController(navigationController, sender: self)
        handleSplitVC(splitVC: splitVC)
        
    case .modal:
        SceneCoordinator.topMostViewController().present(viewController, animated: true) {
            subject.onCompleted()
        }
    }
    
    return subject.asObservable()
      .take(1)
      .ignoreElements()
  }

  @discardableResult
  func pop(animated: Bool) -> Completable {
    let subject = PublishSubject<Void>()
    
    if let _ = SceneCoordinator.topMostViewController().presentingViewController {
        // dismiss a modal controller
        SceneCoordinator.topMostViewController().dismiss(animated: animated) {
            subject.onCompleted()
        }
    } else if let navigationController = SceneCoordinator.topMostViewController().navigationController {
        // navigate up the stack
        // one-off subscription to be notified when pop complete
        
        // it creates a UINavigationController DelegateProxy, an RxSwift proxy which can intercept messages while forwarding messages to the actual delegate
        _ = navigationController.rx
        .didShow
        .map { _ in }
        .bind(to: subject)
        
        guard navigationController.popViewController(animated: animated) != nil else {
            fatalError("can't navigate back from \(String(describing: SceneCoordinator.topMostViewController()))")
        }
    } else {
        fatalError("Not a modal, no navigation controller: can't navigation back from \(String(describing: SceneCoordinator.topMostViewController()))")
    }

    return subject.asObservable()
        .take(1)
        .ignoreElements()
  }
    
    private func handleSplitVC(splitVC: UISplitViewController) {
        let listingNavi = splitVC.viewControllers.last as! UINavigationController
        listingNavi.topViewController?.navigationItem.leftBarButtonItem = splitVC.displayModeButtonItem
        listingNavi.topViewController?.navigationItem.leftItemsSupplementBackButton = true

        splitVC.delegate = self
    }
    
    static func topMostViewController() -> UIViewController! {
         if var topController = UIApplication.shared.keyWindow?.rootViewController {
             //may add UITabBarController
             if let splitVC = topController.splitViewController {
                 topController = splitVC.viewControllers.last!
             }
             
             if let presentedViewController = topController.presentedViewController {
                 topController = presentedViewController
             }
             
             if topController.isKind(of: UINavigationController.self) {
                 return (topController as! UINavigationController).topViewController
             }
             
             return topController
         }
         
         return nil
     }
}

extension SceneCoordinator: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
