//
//  JapxAlamofire.swift
//  Japx
//
//  Created by José Manuel Velázquez González on 25/09/2019.
//

import Alamofire
import Foundation
//Import when install with cocoapods
#if canImport(Japx)
import Japx
#endif

//Import when install with SPM
#if canImport(JapxCodable)
import JapxCodable
#endif
#if canImport(JapxCore)
import JapxCore
#endif
#if canImport(SDOSAlamofire)
import SDOSAlamofire
#endif


private let emptyDataStatusCodes: Set<Int> = [204, 205]

/// `JapxAlamofireError` is the error type returned by JapxAlamofire subspec.
public enum JapxAlamofireError: Error {
    
    /// - invalidKeyPath: Returned when a nested JSON object doesn't exist in parsed JSON:API response by provided `keyPath`.
    case invalidKeyPath(keyPath: String)
}

extension JapxAlamofireError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case let .invalidKeyPath(keyPath: keyPath): return "Nested JSON doesn't exist by keyPath: \(keyPath)."
        }
    }
}

extension Request {
    /// Returns a parsed and decoded JSON:API object into requested type contained in result type.
    ///
    /// - parameter response:       The response from the server.
    /// - parameter data:           The data returned from the server.
    /// - parameter error:          The error already encountered if it exists.
    /// - parameter includeList:    The include list for deserializing JSON:API relationships.
    /// - parameter keyPath:        The keyPath where object decoding on parsed JSON should be performed.
    /// - parameter decoder:        The decoder that performs the decoding on parsed JSON into requested type.
    ///
    /// - returns: The result data type.
    public static func serializeResponseJSONAPI<R: Decodable>(response: HTTPURLResponse?, data: Data?, error: Error?, includeList: String?, keyPath: String?, decoder: JapxDecoder) throws -> R {
        guard error == nil else { throw error! }
        
        guard let validData = data, validData.count > 0 else {
            throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
        }
        
        do {
            guard let keyPath = keyPath, !keyPath.isEmpty else  {
                let decodable = try decoder.decode(R.self, from: validData, includeList: includeList)
                return decodable
            }
            
            let json = try Japx.Decoder.jsonObject(with: validData, includeList: includeList)
            guard let jsonForKeyPath = (json as AnyObject).value(forKeyPath: keyPath) else {
                throw JapxAlamofireError.invalidKeyPath(keyPath: keyPath)
            }
            let data = try JSONSerialization.data(withJSONObject: jsonForKeyPath, options: .init(rawValue: 0))
            
            let decodable = try decoder.jsonDecoder.decode(R.self, from: data)
            return decodable
            
        } catch {
            throw AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
        }
    }
}

extension DataRequest {
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter responseSerializer:     The response serializer responsible for serializing the request, response and data.
    /// - parameter queue:                  The queue on which the completion handler is dispatched.
    /// - parameter completionHandler:      A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    
    @discardableResult
    public func responseJSONAPI<R: Decodable, E: AbstractErrorDTO>(responseSerializer: SDOSJSONAPIResponseSerializer<R, E>, queue: DispatchQueue = .main, completionHandler: @escaping (AFDataResponse<R>) -> Void) -> Self {
        return response(queue: queue,
                        responseSerializer: responseSerializer,
                        completionHandler: completionHandler)
    }
}
