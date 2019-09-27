//
//  RequestValue.swift
//  SDOSAlamofire
//
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import Alamofire

public struct RequestValue<ValueType> {
    
    public let request: Request?
    public let value: ValueType
    
    public init(request: Request?, value: ValueType) {
        self.request = request
        self.value = value
    }
}
