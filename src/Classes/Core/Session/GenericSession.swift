//
//  GenericSession.swift
//  SDOSAlamofire
//
//  Copyright © 2019 SDOS. All rights reserved.
//

import Alamofire
import UIKit
import SDOSSwiftExtension

public extension HTTPHeader {
    
    static let HTTPHeaderAppVersion = "version"
    
    static let HTTPHeaderDevice = "device"
    
    static func version(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: HTTPHeaderAppVersion, value: value)
    }
    
    static func device(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: HTTPHeaderDevice, value: value)
    }
    
}

open class GenericSession: Session {
    
    fileprivate static var defaultHTTPHeaders: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(.acceptLanguage(Locale.currentLocale))
        if let version = UIApplication.version {
            headers.add(.version(version))
        }
        headers.add(.device(UIDevice.current.deviceInformation))
        return headers
    }
    
    open func customizeHTTPHeaders(_ headers: HTTPHeaders?) -> HTTPHeaders {
        var finalHeaders = GenericSession.defaultHTTPHeaders
        headers?.forEach{ finalHeaders.update($0) }
        return finalHeaders
    }
    
    override open func request(_ convertible: URLConvertible,
                               method: HTTPMethod = .get,
                               parameters: Parameters? = nil,
                               encoding: ParameterEncoding = URLEncoding.default,
                               headers: HTTPHeaders? = nil,
                               interceptor: RequestInterceptor? = nil,
                               requestModifier: RequestModifier? = nil) -> DataRequest {
        return super.request(convertible,
                             method: method,
                             parameters: parameters,
                             encoding: encoding,
                             headers: customizeHTTPHeaders(headers),
                             interceptor: interceptor)
    }
    
    override open func request<Parameters: Encodable>(_ convertible: URLConvertible,
                                                      method: HTTPMethod = .get,
                                                      parameters: Parameters? = nil,
                                                      encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default,
                                                      headers: HTTPHeaders? = nil,
                                                      interceptor: RequestInterceptor? = nil,
                                                      requestModifier: RequestModifier? = nil) -> DataRequest {
        return super.request(convertible,
                             method: method,
                             parameters: parameters,
                             encoder: encoder,
                             headers: customizeHTTPHeaders(headers),
                             interceptor: interceptor,
                             requestModifier: requestModifier)
    }
    
    override open func streamRequest<Parameters: Encodable>(_ convertible: URLConvertible,
                                                            method: HTTPMethod = .get,
                                                            parameters: Parameters? = nil,
                                                            encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default,
                                                            headers: HTTPHeaders? = nil,
                                                            automaticallyCancelOnStreamError: Bool = false,
                                                            interceptor: RequestInterceptor? = nil,
                                                            requestModifier: RequestModifier? = nil) -> DataStreamRequest {
        super.streamRequest(convertible,
                            method: method,
                            parameters: parameters,
                            encoder: encoder,
                            headers: customizeHTTPHeaders(headers),
                            automaticallyCancelOnStreamError: automaticallyCancelOnStreamError,
                            interceptor: interceptor,
                            requestModifier: requestModifier)
    }
    
    override open func streamRequest(_ convertible: URLConvertible,
                                     method: HTTPMethod = .get,
                                     headers: HTTPHeaders? = nil,
                                     automaticallyCancelOnStreamError: Bool = false,
                                     interceptor: RequestInterceptor? = nil,
                                     requestModifier: RequestModifier? = nil) -> DataStreamRequest {
        super.streamRequest(convertible,
                            method: method,
                            headers: customizeHTTPHeaders(headers),
                            automaticallyCancelOnStreamError: automaticallyCancelOnStreamError,
                            interceptor: interceptor,
                            requestModifier: requestModifier)
    }
    
    override open func download(_ convertible: URLConvertible,
                                method: HTTPMethod = .get,
                                parameters: Parameters? = nil,
                                encoding: ParameterEncoding = URLEncoding.default,
                                headers: HTTPHeaders? = nil,
                                interceptor: RequestInterceptor? = nil,
                                requestModifier: RequestModifier? = nil,
                                to destination: DownloadRequest.Destination? = nil) -> DownloadRequest {
        return super.download(convertible,
                                     method: method,
                                     parameters: parameters,
                                     encoding: encoding,
                                     headers: customizeHTTPHeaders(headers),
                                     interceptor: interceptor,
                                     requestModifier: requestModifier,
                                     to: destination)
    }
    
    override open func download<Parameters: Encodable>(_ convertible: URLConvertible,
                                                       method: HTTPMethod = .get,
                                                       parameters: Parameters? = nil,
                                                       encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default,
                                                       headers: HTTPHeaders? = nil,
                                                       interceptor: RequestInterceptor? = nil,
                                                       requestModifier: RequestModifier? = nil,
                                                       to destination: DownloadRequest.Destination? = nil) -> DownloadRequest {
        return super.download(convertible,
                                     method: method,
                                     parameters: parameters,
                                     encoder: encoder,
                                     headers: customizeHTTPHeaders(headers),
                                     interceptor: interceptor,
                                     requestModifier: requestModifier,
                                     to: destination)
    }
    
    override open func upload(_ data: Data,
                              to convertible: URLConvertible,
                              method: HTTPMethod = .post,
                              headers: HTTPHeaders? = nil,
                              interceptor: RequestInterceptor? = nil,
                              fileManager: FileManager = .default,
                              requestModifier: RequestModifier? = nil) -> UploadRequest {
        return super.upload(data,
                            to: convertible,
                            method: method,
                            headers: customizeHTTPHeaders(headers),
                            interceptor: interceptor,
                            fileManager: fileManager,
                            requestModifier: requestModifier)
    }
    
    override open func upload(_ fileURL: URL,
                              to convertible: URLConvertible,
                              method: HTTPMethod = .post,
                              headers: HTTPHeaders? = nil,
                              interceptor: RequestInterceptor? = nil,
                              fileManager: FileManager = .default,
                              requestModifier: RequestModifier? = nil) -> UploadRequest {
        return super.upload(fileURL,
                                   to: convertible,
                                   method: method,
                                   headers: customizeHTTPHeaders(headers),
                                   fileManager: fileManager,
                                   requestModifier: requestModifier)
    }
    
    override open func upload(_ stream: InputStream,
                     to convertible: URLConvertible,
                     method: HTTPMethod = .post,
                     headers: HTTPHeaders? = nil,
                     interceptor: RequestInterceptor? = nil,
                     fileManager: FileManager = .default,
                     requestModifier: RequestModifier? = nil) -> UploadRequest {
        return super.upload(stream,
                                   to: convertible,
                                   method: method,
                                   headers: customizeHTTPHeaders(headers),
                                   interceptor: interceptor,
                                   fileManager: fileManager,
                                   requestModifier: requestModifier)
    }
    
    override open func upload(multipartFormData: @escaping (MultipartFormData) -> Void,
                              to url: URLConvertible,
                              usingThreshold encodingMemoryThreshold: UInt64 = MultipartFormData.encodingMemoryThreshold,
                              method: HTTPMethod = .post,
                              headers: HTTPHeaders? = nil,
                              interceptor: RequestInterceptor? = nil,
                              fileManager: FileManager = .default,
                              requestModifier: RequestModifier? = nil) -> UploadRequest {
        return super.upload(multipartFormData: multipartFormData,
                            to: url,
                            usingThreshold: encodingMemoryThreshold,
                            method: method,
                            headers: customizeHTTPHeaders(headers),
                            interceptor: interceptor,
                            fileManager: fileManager,
                            requestModifier: requestModifier)
    }
    
}
