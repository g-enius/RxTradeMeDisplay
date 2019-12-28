//
//  AuthPlugin.swift
//  RxTradeMeDisplay
//
//  Created by Charles on 27/12/19.
//  Copyright © 2019 SKY. All rights reserved.
//

import Foundation
import Moya

struct CustomizedAuthPlugin: PluginType {
    let OAuthBlock:() -> String?
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let auth = OAuthBlock(),
            let target = target as? AuthorizedTargetType,
            target.needAuth
        else {
            return request
        }
        //Cannot use mutating member on immutable value: 'request' is a 'let' constant
        var request = request
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        return request
    }
}
