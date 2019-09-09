//
//  AFError+DTO.swift
//  Alamofire
//
//  Copyright © 2019 SDOS. All rights reserved.
//

import Alamofire

public extension AFError {
    
    var errorDTO: AbstractErrorDTO? {
        if case .responseSerializationFailed(reason: let reason) = self,
            case .customSerializationFailed(error: let error) = reason {
            return error as? AbstractErrorDTO
        }
        return nil
    }
    
}
