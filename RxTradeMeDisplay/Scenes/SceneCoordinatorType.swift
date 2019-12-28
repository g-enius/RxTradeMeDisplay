//
//  SceneCoordinatorType.swift
//  RxTradeMeDisplay
//
//  Created by Charles on 28/12/19.
//  Copyright © 2019 SKY. All rights reserved.
//

import Foundation
import RxSwift

//The purpose of this protocol is for testing purpose. Tests can instantiate a testSceneCoordinator to do mocks
protocol SceneCoordinatorType {
  /// transition to another scene
  @discardableResult
  func transition(to scene: Scene, type: SceneTransitionType) -> Completable

  /// pop scene from navigation stack or dismiss current modal
  @discardableResult
  func pop(animated: Bool) -> Completable
}

//You can also develop a test implementation that fakes transitions
extension SceneCoordinatorType {
  @discardableResult
  func pop() -> Completable {
    return pop(animated: true)
  }
}
