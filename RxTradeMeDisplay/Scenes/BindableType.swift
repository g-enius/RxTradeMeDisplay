//
//  BindableType.swift
//  RxTradeMeDisplay
//
//  Created by Charles on 28/12/19.
//  Copyright © 2019 SKY. All rights reserved.
//

import RxSwift

protocol BindableType {
  associatedtype ViewModelType
// That ! in the protocol is due to there are no inits there.
  var viewModel: ViewModelType! { get set }
  func bindViewModel()
}

// Only add this func extension to UIViewController which adopts BindableType protocol
extension BindableType where Self: UIViewController {
// As (self.)viewModel is mutated in bindViewModel(to:), so self (a ViewController) must be a var.
  mutating func bindViewModel(to model: Self.ViewModelType) {
    viewModel = model
    loadViewIfNeeded()
    bindViewModel()
  }
}
