//
//  ResponseSerialization.swift
//  Alamofire
//
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {
    /// Adds a handler to be called once the request has finished.
    ///
    /// - Parameters:
    ///   - responseSerializer: The serializer used to parse the response.
    ///   - queue:              The queue on which the completion handler is dispatched. Defaults to `nil`, which means
    ///                         the handler is called on `.main`.
    ///   - completionHandler:  A closure to be executed once the request has finished.
    /// - Returns:              The request.
    @discardableResult
    public func responseSDOSDecodable<R: Decodable, E: AbstractErrorDTO>(responseSerializer: SDOSJSONResponseSerializer<R, E>,
                                                                         queue: DispatchQueue = .main,
                                                                         completionHandler: @escaping (DataResponse<R>) -> Void) -> Self {
        return response(queue: queue,
                        responseSerializer: responseSerializer,
                        completionHandler: completionHandler)
    }
}
