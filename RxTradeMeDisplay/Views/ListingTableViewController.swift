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



class ListingTableViewController: UITableViewController, BindableType {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var viewModel: ListingViewModel!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.hidesWhenStopped = true
        if let name = viewModel?.category?.name {
            activityIndicatorView.startAnimating()
            title = name
        } else {
            activityIndicatorView.stopAnimating()
            title = "Listings"
        }
    }
    
    func bindViewModel() {
        //to handle over to RxCocoa
        tableView.dataSource = nil
        tableView.delegate = nil
        
        viewModel.listings
            //can also done by another observable
            .do(onNext: { [unowned self] _ in
                self.activityIndicatorView.stopAnimating()
            })
            .drive(tableView.rx.items) { (tableView, row, listing) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "listingCell")!
                cell.textLabel?.text = listing.title
                cell.detailTextLabel?.text = "\(listing.lisingID ?? 0)"
                return cell
        }
        .disposed(by: bag)
        
        tableView.rx.itemSelected
            .do(onNext: { [unowned self] indexPath in
                self.tableView.deselectRow(at: indexPath, animated: false)
            })
            .map { [unowned self] indexPath -> Listing in
                try! self.tableView.rx.model(at: indexPath)
        }
        .subscribe(viewModel.clickListingAction.inputs)
        .disposed(by:bag)
    }
}
