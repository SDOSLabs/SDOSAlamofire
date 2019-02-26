//
//  SDOSAFError.swift
//  Alamofire
//
//  Created by Antonio Jesús Pallares on 26/02/2019.
//

import Foundation

enum SDOSAFError: Error {
    // This kind of error is thrown when:
    //  1. Using the SDOSJSONResponseSerializer, the response is an error but parsing failed with the given E type (E: HTTPResponseErrorDTO).
    //  2. Using the SDOSHTTPErrorJSONResponseSerializer, the response returns an unacceptable response code (thus it's an error) and the parsed error's 'isError()' implementation returns false.
    case badErrorResponse(code: Int)
}
