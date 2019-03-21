//
//  SDOSAFError.swift
//  Alamofire
//
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation

public enum SDOSAFError: Error {
    // This kind of error is thrown when:
    //  1. Using the SDOSJSONResponseSerializer, the response is an error but parsing fails with the given E type (E: HTTPResponseErrorDTO).
    //  2. Using the SDOSHTTPErrorJSONResponseSerializer, the response returns an unacceptable response code (thus it's an error) and the parsed error's 'isError()' implementation returns false.
    case badErrorResponse(code: Int)
}
