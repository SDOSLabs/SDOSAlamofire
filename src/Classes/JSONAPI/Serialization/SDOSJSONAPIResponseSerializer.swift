//
//  SDOSJSONAPIResponseSerializer.swift
//  SDOSAlamofire
//
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import Alamofire
#if canImport(JapxCodable)
import JapxCodable
#endif
#if canImport(Japx)
import Japx
#endif
#if canImport(SDOSAlamofire)
import SDOSAlamofire
#endif

public struct JSONAPI {
    public static let rootPath: String = "data"
    
    public struct Include {
        public static let key: String = "include"
        public static let separator: String = "&"
    }
}

public class SDOSJSONAPIResponseSerializer<R: Decodable, E: AbstractErrorDTO>: ResponseSerializer {
    public let includeList: String?
    public let keyPath: String?
    
    /// Serializador utilizado para JSONAPI
    ///
    /// - parameter includeList:    Lista de includes para la deserialización de relaciones de JSON:API.
    /// - parameter keyPath:        Raiz del JOSN para su decodificación.
    
    public init(includeList: String? = nil, keyPath: String? = JSONAPI.rootPath) {
        self.includeList = includeList
        self.keyPath = keyPath
    }
    
    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> R {
        var includeUrl = includeList
        
        if let url = request?.url?.absoluteString, includeList == nil {
            includeUrl = getInclude(url: url)
        }
        
        return try Request.serializeResponseJSONAPI(response: response, data: data, error: error, includeList: includeUrl, keyPath: keyPath, decoder: JapxDecoder())
    }
    
    private func getInclude(url: String) -> String {
        let include = url.components(separatedBy: "\(JSONAPI.Include.key)=").last?.components(separatedBy: JSONAPI.Include.separator).first
        return include ?? ""
    }
    
}
