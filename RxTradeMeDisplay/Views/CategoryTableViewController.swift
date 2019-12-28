//
//  CategoryTableViewController.swift
//  RxTradeMeDisplay
//
//  Created by Charles on 28/12/19.
//  Copyright © 2019 SKY. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryTableViewController: UITableViewController, BindableType {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var viewModel: CategoryViewModel!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categories"
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
    }

    func bindViewModel() {
        //to handle over to RxCocoa
        tableView.dataSource = nil
        tableView.delegate = nil
        
        viewModel.categories
            //can also done by another observable
            .do(onNext: { [unowned self] _ in
                self.activityIndicatorView.stopAnimating()
            })
            .drive(tableView.rx.items) { (tableView, row, category) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "categoryCell")
                cell.textLabel?.text = category.name
                cell.detailTextLabel?.text = category.number
                cell.accessoryType = .disclosureIndicator
                return cell
            }
            .disposed(by: bag)
    }
}
