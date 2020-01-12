//
//  DetailViewModel.swift
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

struct DetailViewModel {
    let sceneCoordicator: SceneCoordinatorType
    let service: MoyaProvider<APIService>
    let listing: Listing?
    
    
    //MARK: INIT
    init(sceneCoordicator: SceneCoordinatorType, service: MoyaProvider<APIService>, listing: Listing) {
        self.sceneCoordicator = sceneCoordicator
        self.service = service
        self.listing = listing
    }
    
    //MARK: OUTPUT
    lazy var details: Driver<Details?>! = {
        return self.service.rx
            .request(.listingDetails(listingID:"\(self.listing?.lisingID ?? 0)"))
            .filter(statusCode: 200)
            .retry(1)
            .map { (response: Response) -> Details? in
                let details = try JSON(data: response.data)
                let listingID = details["ListingId"].stringValue
                let title = details["Title"].stringValue
                let body = details["Body"].stringValue
                
                var thumbnail = ""
                if let photo = details["Photos"].arrayValue.first {
                    thumbnail = photo["Value"]["Thumbnail"].stringValue
                }
                
                return Details(listingID:listingID, title: title, thumbnail: thumbnail, body: body)
        }
        .asDriver(onErrorJustReturn: nil)
    }()
}
