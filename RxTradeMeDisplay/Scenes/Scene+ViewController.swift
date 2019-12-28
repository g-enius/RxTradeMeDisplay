//
//  Scene+ViewController.swift
//  RxTradeMeDisplay
//
//  Created by Charles on 28/12/19.
//  Copyright © 2019 SKY. All rights reserved.
//

import UIKit

extension Scene {
  func instantiateViewController() -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    switch self {
    case .category(let viewModel):
        let splitVC = storyboard.instantiateViewController(withIdentifier: "Category") as! UISplitViewController
        var vc = (splitVC.viewControllers.first as! UINavigationController).viewControllers.first as! CategoryTableViewController
//        As (self.)viewModel is mutated in bindViewModel(to:), so self (a ViewController) must be a var.
        vc.bindViewModel(to: viewModel)
        return splitVC
        
    case .listing(let viewModel):
        let navi = storyboard.instantiateViewController(withIdentifier: "Listing") as! UINavigationController
        var vc = navi.topViewController as! ListingTableViewController
        //4) Scene Coordinator binds second VC and VM together
        vc.bindViewModel(to: viewModel)
        return vc
        
    case .detail(let viewModel):
        var vc = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailTableViewController
        //4) Scene Coordinator binds second VC and VM together
        vc.bindViewModel(to: viewModel)
        return vc
    }
  }
}
