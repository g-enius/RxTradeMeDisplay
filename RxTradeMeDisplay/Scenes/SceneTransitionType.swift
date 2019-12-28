//
//  SceneTransitionType.swift
//  RxTradeMeDisplay
//
//  Created by Charles on 28/12/19.
//  Copyright © 2019 SKY. All rights reserved.
//

import Foundation

enum SceneTransitionType {
    // you can extend this to add animated transition types,
    // interactive transitions and even child view controllers!
    case root       // make view controller the root view controller
    case push       // push view controller to navigation stack
    case showDetail //a split view controller replaces its second child view controller (the detail controller) with the new content
    case modal      // present view controller modally
}
