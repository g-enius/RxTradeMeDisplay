//
//  ListViewModel.swift
//  RxTradeMeDisplay
//
//  Created by Charles on 28/12/19.
//  Copyright © 2019 SKY. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import Moya
import SwiftyJSON

struct ListingViewModel {
    let sceneCoordinator: SceneCoordinatorType
    let service: MoyaProvider<APIService>
    let category: Category?
    
    // MARK: INIT
    init(sceneCoordinator: SceneCoordinatorType, service: MoyaProvider<APIService>, category: Category) {
        self.sceneCoordinator = sceneCoordinator
        self.service = service
        self.category = category
    }
    
    // MARK: OUTPUT
    lazy var listings: Driver<[Listing]>! = {
        return self.service.rx
            .request(.search(category: self.category!.number!, rows: "20"))
            .filter(statusCode: 200)
            .retry(1)
            .map { (response: Response) -> [Listing] in
                guard let array = try JSON(data: response.data)["List"].array else {
                    return []
                }
                
                var lisings = Array<Listing>()
                array.forEach { model in
                    let title = model["Title"].string
                    let listingID = model["ListingId"].intValue
                    let category = model["Category"].string
                    let imageURL = model["PictureHref"].string
                    let lising = Listing(title: title, lisingID: listingID, category: category, imageURL: imageURL)
                    
                    lisings.append(lising)
                }
                return lisings
        }
        .asDriver(onErrorJustReturn: [])
    }()
    
    
    lazy var clickListingAction: Action<Listing, Never> = { this in
        return Action { listing -> Observable<Never> in
            let detailViewModel = DetailViewModel(sceneCoordicator: this.sceneCoordinator,
                                                  service: this.service,
                                                  listing: listing)
            
            return this.sceneCoordinator
                .transition(to: .detail(detailViewModel), type: .push)
                .asObservable()
        }
    }(self)
}
