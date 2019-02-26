//
//  GenericDTO.swift
//  SDOSAlamofire
//
//  Created by Antonio Jesús Pallares on 07/02/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import SDOSKeyedCodable

/// Use this type to parse WS responses
public typealias GenericDTO = Decodable & Keyedable

/// Use this type to parse WS response errors
public typealias GenericErrorDTO = AbstractErrorDTO & Keyedable

/// Use this type to parse WS response errors of the legacy type HTTPResponseError
public typealias GenericHTTPResponseErrorDTO = HTTPResponseErrorProtocol & Keyedable


public typealias AbstractErrorDTO = Decodable & Error
public protocol HTTPResponseErrorProtocol: AbstractErrorDTO {
    func isError() -> Bool
}


extension Array: Error where Element: Error { }
extension Array: HTTPResponseErrorProtocol where Element: HTTPResponseErrorProtocol {
    
    public func isError() -> Bool {
        for item in self {
            if item.isError() {
                return true
            }
        }
        return false
    }
    
}

