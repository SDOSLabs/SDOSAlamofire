//
//  WS.swift
//  SDOSAlamofireSample
//
//  Created by Antonio Jesús Pallares on 27/02/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import SDOSAlamofire
import Alamofire

typealias WSConfiguration = [ExampleSection]

struct WS {
    private init() { }
    
    static func makeWSCall(configuration: WSConfiguration, completion: (_ textToShow: String) -> Void) {
        let responseSerializer = SDOSJSONResponseSerializer<UserDTO, ResponseErrorDTO>(jsonErrorRootKey: "Error")
        AF.request(Constants.WS.wsUserURL, method: .get, parameters: nil).validate().responseSDOSDecodable(responseSerializer: responseSerializer) { response in
            switch response.result {
            case .success(let user):
                print("Success with user: \(user)")
            case .failure(let error as ResponseErrorDTO):
                print("Failure with response error: \(error)")
            case .failure(let error):
                print("Failure with error: \(error)")
            }
        }
    }
}
