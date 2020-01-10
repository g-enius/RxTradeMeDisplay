//
//  APIService.swift
//  RxTradeMeDisplay
//
//  Created by Charles on 27/12/19.
//  Copyright © 2019 SKY. All rights reserved.
//

import Foundation
import Moya

enum APIService {
    case categories
    case search(category: String, searchText: String? = nil, rows: String)
    case listingDetails(listingID: String)
}

protocol AuthorizedTargetType: TargetType {
    var needAuth: Bool { get }
}

extension APIService: AuthorizedTargetType {
    var baseURL: URL {
        return URL(string:"https://api.tmsandbox.co.nz/v1")!
    }
    
    var path: String {
        switch self {
        case .categories:
            return "/Categories/0.json"
            
        case .search:
            return "Search/General.json"
            
        case .listingDetails(let listingID):
            return "Listings/\(listingID).json"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .categories:
            return "{\"Name\": \"Root\",\"Number\": \"\",\"Path\": \"\",\"Subcategories\": [{\"Name\": \"Trade Me Motors\",\"Number\": \"0001-\",\"Path\": \"/Trade-Me-Motors\",\"HasClassifieds\": true,\"AreaOfBusiness\": 3,\"CanHaveSecondCategory\": true,\"CanBeSecondCategory\": true,\"IsLeaf\": false}]".data(using: .utf8)!
            
        case .search:
            return "{\"TotalCount\": 1361,\"Page\": 1,\"PageSize\": 20,\"List\": [{\"ListingId\": 2148442234,\"Title\": \"Car 107 by Junk 1\",\"Category\": \"0347-0924-1194-7778-\",\"StartPrice\": 13.0000,\"BuyNowPrice\": 27.0000,\"StartDate\": \"/Date(1577228272320)/\",\"EndDate\": \"/Date(1578092272320)/\",\"ListingLength\": null,\"IsFeatured\": true,\"HasGallery\": true,\"IsBold\": true,\"AsAt\": \"/Date(1577412342807)/\",\"CategoryPath\": \"/Toys-models/Models/Cars-trucks/Classic-cars\",\"PictureHref\":\"https://images.tmsandbox.co.nz/photoserver/thumb/4550587.jpg\",\"Region\": \"Canterbury\",\"Suburb\": \"Christchurch City\",\"HasBuyNow\": true,\"NoteDate\": \"/Date(0)/\",\"Subtitle\": \"F10d\",\"PriceDisplay\": \"$13.00\",\"PromotionId\": 4,\"AdditionalData\": {\"BulletPoints\": [],\"Tags\": []},\"MemberId\": 4000148}]".data(using: .utf8)!
            
        case .listingDetails:
            return "{\"ListingId\": 4192588,\"Title\": \"Thorndon, car park\",\"Category\": \"0350-5748-8945-\",\"StartPrice\": 0,\"StartDate\": \"/Date(1437631679380)/\",\"EndDate\": \"/Date(1578805679410)/\",\"Body\": \"Covered Car park in a secure building in Thorndon. Remote control access\",\"Photos\": [{\"Key\": 1260490,\"Value\": {\"Thumbnail\": \"https://images.tmsandbox.co.nz/photoserver/thumb/1260490.jpg\",\"List\": \"https://images.tmsandbox.co.nz/photoserver/lv2/1260490.jpg\",\"Medium\": \"https://images.tmsandbox.co.nz/photoserver/med/1260490.jpg\",\"Gallery\": \"https://images.tmsandbox.co.nz/photoserver/gv/1260490.jpg\",\"Large\": \"https://images.tmsandbox.co.nz/photoserver/tq/1260490.jpg\",\"FullSize\": \"https://images.tmsandbox.co.nz/photoserver/full/1260490.jpg\",\"PhotoId\": 1260490,\"OriginalWidth\": 448,\"OriginalHeight\": 336}}]}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .categories:
            let parameters = ["depth": "1"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        
        case .search(let category, let searchText, let rows):
            let parameters: [String: String]
            if let searchText = searchText {
                parameters = ["category": category,
                "search_string": searchText,
                "rows": rows]
            } else {
                parameters = ["category": category,
                "rows": rows]
            }
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .listingDetails(let listingID):
            let parameters = ["ListingId": listingID]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var needAuth: Bool {
        switch self {
        case .categories:
            return false
        
        case .search:
            return true
            
        case .listingDetails:
            return true
        }
    }
}
