//
//  SDOSDecodableResponseSerializer.swift
//  Alamofire
//
//  Created by Antonio Jesús Pallares on 07/02/2019.
//

import Foundation
import Alamofire

public class SDOSDecodableResponseSerializer<ResponseDTO: GenericDTO, ErrorDTO: GenericErrorDTO>: ResponseSerializer {
    
    public let decoder: DataDecoder
    public let emptyResponseCodes: Set<Int>
    public let emptyRequestMethods: Set<HTTPMethod>
    
    private lazy var responseSerializer: DecodableResponseSerializer<ResponseDTO> = {
        return DecodableResponseSerializer<ResponseDTO>(decoder: decoder, emptyResponseCodes: emptyResponseCodes, emptyRequestMethods: emptyRequestMethods)
    }()
    
    public init(decoder: DataDecoder = JSONDecoder(),
                emptyResponseCodes: Set<Int> = DecodableResponseSerializer<ResponseDTO>.defaultEmptyResponseCodes,
                emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<ResponseDTO>.defaultEmptyRequestMethods) {
        self.decoder = decoder
        self.emptyResponseCodes = emptyResponseCodes
        self.emptyRequestMethods = emptyRequestMethods
    }
    
    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> ResponseDTO {
        if
            let error = error as? AFError.ResponseValidationFailureReason,
            case AFError.ResponseValidationFailureReason.unacceptableStatusCode(let code) = error
            {
                //TODO: Parse error and throw it
                
                throw NSError(domain: "REMOVE", code: code, userInfo: nil)
        } else {
            return try responseSerializer.serialize(request: request, response: response, data: data, error: nil)
        }
    }
    
}
