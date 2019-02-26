//
//  SDOSHTTPErrorJSONResponseSerializer.swift
//  SDOSAlamofire
//
//  Created by Antonio Jesús Pallares on 25/02/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import Alamofire

public struct HTTPErrorSerializerDomainKey {
    private init() {}
    public static let error = "error"
    public static let response = "respuesta"
}

public class SDOSHTTPErrorJSONResponseSerializer<R: Decodable, E: HTTPResponseErrorProtocol>: SDOSJSONResponseSerializer<R, E> {
    
    public override init(emptyResponseCodes: Set<Int> = DecodableResponseSerializer<R>.defaultEmptyResponseCodes,
                         emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<R>.defaultEmptyRequestMethods,
                         jsonResponseRootKey: String? = HTTPErrorSerializerDomainKey.response,
                         jsonErrorRootKey: String? = HTTPErrorSerializerDomainKey.error) {
        super.init(emptyResponseCodes: emptyResponseCodes, emptyRequestMethods: emptyRequestMethods, jsonResponseRootKey: jsonResponseRootKey, jsonErrorRootKey: jsonErrorRootKey)
    }
    
    public override func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> R {
        if let parsedError = try? parseError(request: request, response: response, data: data), parsedError.isError() {
            throw parsedError
        } else if
            let error = error as? AFError.ResponseValidationFailureReason,
            case AFError.ResponseValidationFailureReason.unacceptableStatusCode(let code) = error {
            throw SDOSAFError.badErrorResponse(code: code)
        } else {
            return try parseResponse(request: request, response: response, data: data, error: error)
        }

    }
    
}
