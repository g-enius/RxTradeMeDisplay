//
//  RxTradeMeDisplayTests.swift
//  RxTradeMeDisplayTests
//
//  Created by Charles on 27/12/19.
//  Copyright © 2019 SKY. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import RxTest
import Moya
import Nimble

@testable import RxTradeMeDisplay

class RxTradeMeDisplayTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_whenInitialized_bindsCategories() {
        let customEndpointClosure = { (target: APIService) -> Endpoint in
            switch target {
            case .categories:
                return Endpoint.init(url: URL(target: target).absoluteString,
                                     sampleResponseClosure: { .networkResponse(403, target.sampleData) },
                                     method: target.method,
                                     task: target.task,
                                     httpHeaderFields: target.headers)
                
            default:
                return Endpoint.init(url: URL(target: target).absoluteString,
                                     sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                                     method: target.method,
                                     task: target.task,
                                     httpHeaderFields: target.headers)
            }
        }
        
        var stubTime = 0
        let customStubClosure = { (target: APIService) -> Moya.StubBehavior in
            switch target {
            case .categories:
                if stubTime < 3 {
                    stubTime = stubTime + 1
                    return .delayed(seconds: 0.5)
                } else {
                    return .never
                }
                
            default:
                return .never
            }
        }
        
        let service = MoyaProvider<APIService>(
            endpointClosure: customEndpointClosure,
            stubClosure: customStubClosure,
            plugins: [
                NetworkLoggerPlugin(),
                CustomizedAuthPlugin(OAuthBlock: {
                    return "OAuth oauth_consumer_key=wrongKey, oauth_signature_method=PLAINTEXT, oauth_signature=wrongKey&"
                })
        ])
        
        let sceneCoordinator = SceneCoordinator(window: UIWindow(frame: UIScreen.main.bounds))
        var categoryViewModel = CategoryViewModel(sceneCoordinator: sceneCoordinator, service: service)
        expect(categoryViewModel.categories.asObservable().toBlocking(timeout: 3).firstOrNil()).toNot(beNil())
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension BlockingObservable {
    func firstOrNil() -> Element? {
        do {
            return try first()
        } catch {
            return nil
        }
    }
}
