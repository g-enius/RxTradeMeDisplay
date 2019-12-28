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
}
