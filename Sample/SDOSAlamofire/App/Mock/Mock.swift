//
//  Mock.swift
//  SDOSAlamofireSample
//
//  Created by Antonio Jesús Pallares on 07/02/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation

func setupServiceMock() throws {
    
    let resourceName = "Example0"
    guard let filepath = Bundle.main.path(forResource: resourceName, ofType: "txt") else {
        throw NSError(domain: "Error de lectura de archivo de mock", code: 0, userInfo: nil)
    }
    let url = URL(fileURLWithPath: filepath)
    let data = try Data(contentsOf: url)
    let jsonString = try String(contentsOfFile: filepath)

    OHHTTPStubs.stubRequests(passingTest: { (request: URLRequest) -> Bool in
        guard
            let host = request.url?.host,
            let hostToStub = URLComponents(string: Constants.WS.wsUserURL)?.host
            else {
            return false
        }
        return hostToStub == host
    }) { _ -> OHHTTPStubsResponse in
        
        let response = OHHTTPStubsResponse(data: data, statusCode: 200, headers: nil)
        response.responseTime = TimeInterval.random(in: 2 ... 5)

        return response
    }
}
