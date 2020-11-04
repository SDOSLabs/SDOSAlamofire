//
//  Mock.swift
//  SDOSAlamofireSample
//
//  Created by Antonio Jesús Pallares on 07/02/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import OHHTTPStubs

let kDefaultsJSONMalformedKey = "kDefaultsJSONMalformedKey"
let kDefaultsJSONErrorCodeResponseKey = "kDefaultsJSONErrorCodeResponseKey"

func setupServiceMock() throws {
    HTTPStubs.stubRequests(passingTest: { (request: URLRequest) -> Bool in
        guard
            let host = request.url?.host,
            let hostToStub = URLComponents(string: Constants.WS.wsUserURL)?.host
            else {
            return false
        }
        return hostToStub == host
    }) { _ -> HTTPStubsResponse in
        
        let responseData: Data
        if UserDefaults.standard.bool(forKey: kDefaultsJSONMalformedKey) {
            responseData = JSON.malformedJSONData
        } else {
            responseData = JSON.correctJSONData
        }
        
        let statusCode: Int32
        if UserDefaults.standard.bool(forKey: kDefaultsJSONErrorCodeResponseKey) {
            statusCode = 400
        } else {
            statusCode = 200
        }
        
        
        let response = HTTPStubsResponse(data: responseData, statusCode: statusCode, headers: nil)
        response.responseTime = TimeInterval.random(in: 0.3 ... 2)

        return response
    }
}

func setupServiceJSONAPIMock() throws {
    HTTPStubs.stubRequests(passingTest: { (request: URLRequest) -> Bool in
        guard
            let host = request.url?.host,
            let hostToStub = URLComponents(string: Constants.WS.wsJSONAPIURL)?.host
            else {
                return false
        }
        return hostToStub == host
    }) { _ -> HTTPStubsResponse in
        
        let responseData: Data = JSON.correctJSONAPIData
        let statusCode: Int32 = 200
        
        let response = HTTPStubsResponse(data: responseData, statusCode: statusCode, headers: nil)
        response.responseTime = TimeInterval.random(in: 0.3 ... 2)
        
        return response
    }
}
