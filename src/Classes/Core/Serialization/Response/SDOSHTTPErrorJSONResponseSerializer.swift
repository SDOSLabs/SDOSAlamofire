//
//  SDOSHTTPErrorJSONResponseSerializer.swift
//  SDOSAlamofire
//
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
    
    /// A serializer that used to parse JSON responses in the "error-respuesta" legacy way. This initializer actually is "16 initializers in 1" since the 4 parameters have default values.
    ///
    /// - Parameters:
    ///   - emptyResponseCodes: The codes for which an empty response is acceptable.
    ///   - emptyRequestMethods: The HTTP methods for which an empty response is acceptable.
    ///   - jsonResponseRootKey: The key (or keypath separated by points) where to start the parsing of the response JSON. By default, the parsing of the response type (`R`) is done from the key "respuesta".
    ///   - jsonErrorRootKey: The key (or keypath separated by points) where to start the parsing of the response JSON error. By default, the parsing of the response error type (`E`) is done from the key "error".
    public override init(emptyResponseCodes: Set<Int> = DecodableResponseSerializer<R>.defaultEmptyResponseCodes,
                         emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<R>.defaultEmptyRequestMethods,
                         jsonResponseRootKey: String? = HTTPErrorSerializerDomainKey.response,
                         jsonErrorRootKey: String? = HTTPErrorSerializerDomainKey.error) {
        super.init(emptyResponseCodes: emptyResponseCodes, emptyRequestMethods: emptyRequestMethods, jsonResponseRootKey: jsonResponseRootKey, jsonErrorRootKey: jsonErrorRootKey)
    }
    
    public override func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> R {
        if let parsedError = try? parseError(request: request, response: response, data: data), parsedError.isError() {
            throw parsedError
        } else if let error = error {
            throw error
        } else {
            return try parseResponse(request: request, response: response, data: data, error: error)
        }
    }
    
}
