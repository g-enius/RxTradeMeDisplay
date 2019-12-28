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
  fileprivate var currentViewController: UIViewController

  required init(window: UIWindow) {
    self.window = window
    currentViewController = window.rootViewController!
  }

  static func actualViewController(for viewController: UIViewController) -> UIViewController {
    if let navigationController = viewController as? UINavigationController {
      return navigationController.viewControllers.first!
    } else {
      return viewController
    }
  }

  @discardableResult
  func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
    let subject = PublishSubject<Void>()
    //3) Scene Coordinator instantiates the new View Controller
    let viewController = scene.instantiateViewController()
    switch type {
    case .root:
        currentViewController = SceneCoordinator.actualViewController(for: viewController)
        window.rootViewController = viewController
        
        handleSplitVC(splitVC: viewController as! UISplitViewController)
        subject.onCompleted()
        
    case .push:
        guard let navigationController = currentViewController.navigationController else {
            fatalError("Can't push a view controller without a current navigation controller")
        }
        // one-off subscription to be notified when push complete
        _ = navigationController.rx
        .didShow
        .map { _ -> Void in }
        .bind(to: subject)
        
        //5) Scene Coordinator pushs/presents second VC
        navigationController.pushViewController(viewController, animated: true)
        currentViewController = SceneCoordinator.actualViewController(for: viewController)
        
    case .showDetail:
        #warning("need to adapt")
        guard let navigationController = currentViewController.navigationController else {
            fatalError("Can't push a view controller without a current navigation controller")
        }
        // one-off subscription to be notified when push complete
        _ = navigationController.rx
        .didShow
        .map { _ -> Void in }
        .bind(to: subject)
        
        //5) Scene Coordinator pushs/presents second VC
        navigationController.pushViewController(viewController, animated: true)
        currentViewController = SceneCoordinator.actualViewController(for: viewController)
        
        
    case .modal:
        currentViewController.present(viewController, animated: true) {
            subject.onCompleted()
        }
        
        currentViewController = SceneCoordinator.actualViewController(for: viewController)
    }
    
    return subject.asObservable()
      .take(1)
      .ignoreElements()
  }

  @discardableResult
  func pop(animated: Bool) -> Completable {
    let subject = PublishSubject<Void>()
    
    if let presenter = currentViewController.presentingViewController {
        // dismiss a modal controller
        currentViewController.dismiss(animated: animated) {
            self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
            subject.onCompleted()
        }
    } else if let navigationController = currentViewController.navigationController {
        // navigate up the stack
        // one-off subscription to be notified when pop complete
        
        // it creates a UINavigationController DelegateProxy, an RxSwift proxy which can intercept messages while forwarding messages to the actual delegate
        _ = navigationController.rx
        .didShow
        .map { _ in }
        .bind(to: subject)
        
        guard navigationController.popViewController(animated: animated) != nil else {
            fatalError("can't navigate back from \(currentViewController)")
        }
        
        currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
    } else {
        fatalError("Not a modal, no navigation controller: can't navigation back from \(currentViewController)")
    }

    return subject.asObservable()
        .take(1)
        .ignoreElements()
  }
    
    private func handleSplitVC(splitVC: UISplitViewController) {
        let listingNavi = splitVC.viewControllers.last as! UINavigationController
        listingNavi.topViewController?.navigationItem.leftBarButtonItem = splitVC.displayModeButtonItem
        splitVC.delegate = self
    }
}

extension SceneCoordinator: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if secondaryViewController.isKind(of: UINavigationController.self) {
            let topVC = (secondaryViewController as! UINavigationController).topViewController!
            if topVC.isKind(of: ListingTableViewController.self) {
//                if(listTableViewController.dataSource.count > 0) {
//                    return NO;
//                }
            } else if topVC.isKind(of: DetailTableViewController.self) {
//                if(listDetailTableViewController.detail) {
//                    return NO;
//                }
            }
        }
        
        return true
    }
}
