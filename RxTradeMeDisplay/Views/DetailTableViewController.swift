//
//  DetailTableViewController.swift
//  RxTradeMeDisplay
//
//  Created by Charles on 28/12/19.
//  Copyright © 2019 SKY. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class DetailTableViewController: UIViewController, BindableType {
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var bodyLabel: UILabel!
    var viewModel: DetailViewModel!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = viewModel.listing?.title {
            title = name
        }
    }

    func bindViewModel() {
        viewModel.details
            .drive(onNext: { detail in
                self.bodyLabel.text = detail?.body
                
                if let urlString = detail?.thumbnail,
                    let url = URL(string: urlString) {
                    
                    DispatchQueue.global().async {
                        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, res, err) in
                            DispatchQueue.main.async {
                                guard let data = data else {
                                     return
                                }
                               
                                let image = UIImage(data: data)
                                self?.imageView.image = image
                            }
                           
                        }
                        task.resume()
                    }
                }
            })
            .disposed(by: bag)
    }

}



//            .asObservable()
//            .flatMap { [weak self] detail -> Observable<Data?> in
//                if let detail = detail,
//                    let url = URL(string: detail.thumbnail) {
////                    let request = URLRequest(url: url)
////                    imageView.image = UIImage(ur)
//                    self?.bodyLabel.text = detail.body
//                }
