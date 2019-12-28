//
//  CategoryViewModel.swift
//  RxTradeMeDisplay
//
//  Created by Charles on 28/12/19.
//  Copyright © 2019 SKY. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON
import Action

struct CategoryViewModel {
    let sceneCoordinator: SceneCoordinatorType
    let service: MoyaProvider<APIService>
    
    // MARK: INIT
    init(sceneCoordinator: SceneCoordinatorType, service: MoyaProvider<APIService>) {
        self.sceneCoordinator = sceneCoordinator
        self.service = service
    }
    
    // MARK: OUTPUT
    lazy var categories: Driver<[Category]>! = {
        return self.service.rx
            .request(.categories)
            .filter(statusCode: 200)
            .retry(1)
            .map { (response: Response) -> [Category] in
                guard let array = try JSON(data: response.data)["Subcategories"].array else {
                    return []
                }
                
                var categories = Array<Category>()
                array.forEach { model in
                    let name = model["Name"].string
                    let number = model["Number"].string
                    let category = Category(name: name, number: number)
                    categories.append(category)
                }
                return categories
            }
            .asDriver(onErrorJustReturn: [])
    }()
    
    // View controllers shouldn’t initiate the transition to another scene; this is the domain of the business logic running in the view model.
    // Note: Since self is a struct, the action gets its own “copy” of the struct (optimized by Swift to being just a reference), and there is no circular reference - no risk of leaking memory! That's why you don't see [weak self] or [unowned self] here, which don't apply to value types.

    lazy var clickCategoryAction: Action<Category, Never> = { this in
        return Action { category -> Observable<Never> in
            let lisingViewModel = ListingViewModel(sceneCoordinator: this.sceneCoordinator,
                                                   service: this.service,
                                                   category: category)
            
            return this.sceneCoordinator
                .transition(to: .listing(lisingViewModel), type: .showDetail)
                .asObservable()
        }
    }(self)
    
}
