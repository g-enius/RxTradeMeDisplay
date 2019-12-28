//
//  ListingTableViewController.swift
//  RxTradeMeDisplay
//
//  Created by Charles on 28/12/19.
//  Copyright © 2019 SKY. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action


class ListingTableViewController: UITableViewController, BindableType {
    //    That ! in the protocol is due to “TaskViewControler” and “EditTaskViewController” also define the viewModel as a var !. That’s a “have-to-do” as there are no inits there.
    var viewModel: ListingViewModel!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.category.name
    }
    
    func bindViewModel() {
        //to handle over to RxCocoa
        tableView.dataSource = nil
        tableView.delegate = nil
        
        viewModel.listings
            .drive(tableView.rx.items) { (tableView, row, listing) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "listingCell")!
                cell.textLabel?.text = listing.title
                cell.detailTextLabel?.text = "\(listing.lisingID ?? 0)"
                return cell
        }
        .disposed(by: bag)
    }
}
