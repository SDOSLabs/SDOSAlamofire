//
//  WS.swift
//  SDOSAlamofireSample
//
//  Created by Antonio Jesús Pallares on 27/02/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import SDOSAlamofire
import Alamofire

typealias WSConfiguration = [ExampleSection]

struct WS {
    private init() { }
    
    static let sharedSession = GenericSession()
    
    static func makeWSCall(configuration: WSConfiguration, completion: @escaping () -> Void) {
        
        logConfiguration(configuration: configuration)
        configureResponse(configuration: configuration)
        
        var responseRootKey: String? = nil
        if case .some = configuration.jsonRootForResponse {
            responseRootKey = JSONRoot.responseRootKey
        }
        
        var errorRootKey: String? = nil
        if case .some = configuration.jsonRootForError {
            errorRootKey = JSONRoot.errorRootKey
        }
        
        guard configuration.parseForResponse == .userDTO && configuration.parseForError == .errorDTO else {
            // Right now only parsing with UserDTO and ErrorDTO is supported,
            return
        }
        
        let responseSerializer: SDOSJSONResponseSerializer<UserDTO, ErrorDTO>
        switch configuration.serializerType {
        case .JSONResponseSerializer:
            responseSerializer = SDOSJSONResponseSerializer<UserDTO, ErrorDTO>(jsonResponseRootKey: responseRootKey, jsonErrorRootKey: errorRootKey)
        case .HTTPErrorJSONResponseSerializer:
            responseSerializer = SDOSHTTPErrorJSONResponseSerializer<UserDTO, ErrorDTO>(jsonResponseRootKey: responseRootKey, jsonErrorRootKey: errorRootKey)
        }
        
        let dataRequest = sharedSession.request(Constants.WS.wsUserURL, method: .get, parameters: nil)
        dataRequest.validate().responseSDOSDecodable(responseSerializer: responseSerializer) { response in
            if let data = response.data,
                let str = String(data: data, encoding: String.Encoding.utf8) {
                LoggingViewManager.logString("Response received: \n\(str)")
            }
            switch response.result {
            case .success(let user):
                LoggingViewManager.logString("Success. Received dto response: \(user)")
            case .failure(let error):
                if let errorDTO = error.errorDTO {
                    LoggingViewManager.logString("Error. Received dto error: \(errorDTO)")
                } else {
                    LoggingViewManager.logString("Error. Could not parse dto error. Received error: \(error)")
                }
            }
            completion()
        }
    }
    
    private static func configureResponse(configuration: WSConfiguration) {
        
        let jsonMalformed: Bool
        let errorCodeInResponse: Bool
        
        switch configuration.jsonType {
        case .correct:
            jsonMalformed = false
        case .malformed:
            jsonMalformed = true
        }
        
        switch configuration.responseCode {
        case .success:
            errorCodeInResponse = false
        case .failure:
            errorCodeInResponse = true
        }
        
        UserDefaults.standard.set(jsonMalformed, forKey: kDefaultsJSONMalformedKey)
        UserDefaults.standard.set(errorCodeInResponse, forKey: kDefaultsJSONErrorCodeResponseKey)
    }
    
    private static func logConfiguration(configuration: WSConfiguration) {
        
        // JSONType
        let strJSONType: String
        switch configuration.jsonType {
        case .correct:
            strJSONType = "Receiving a correct JSON\n"
        case .malformed:
            strJSONType = "Receiving a malformed JSON\n"
        }
        LoggingViewManager.logString(strJSONType)
        
        // JSON Root & Serializers
        var strSerializerType = "What serializer was used?\n"
        var strJSONResponseRootKey = "Used a json root key for the response object?\n"
        var strJSONErrorRootKey = "Used a json root key for the error object?\n"
        switch configuration.serializerType {
        case .JSONResponseSerializer:
            strSerializerType += "SDOSJSONResponseSerializer\n"
            switch configuration.jsonRootForResponse {
            case .none:
                strJSONResponseRootKey += "No json root key\n"
            case .some:
                strJSONResponseRootKey += "Yes: \"user\"\n"
            }
            switch configuration.jsonRootForError {
            case .none:
                strJSONErrorRootKey += "No json root key\n"
            case .some:
                strJSONErrorRootKey += "Yes: \"errors\"\n"
            }
        case .HTTPErrorJSONResponseSerializer:
            strSerializerType += "SDOSHTTPErrorJSONResponseSerializer\n"
            switch configuration.jsonRootForResponse {
            case .none:
                strJSONResponseRootKey += "No json root key.\nRemember: passing nil as the json root key for the response to the SDOSHTTPErrorJSONResponseSerializer means that the serializer uses the json root key \"respuesta\" by default\n"
            case .some:
                strJSONResponseRootKey += "Yes: \"user\"\n"
            }
            switch configuration.jsonRootForError {
            case .none:
                strJSONErrorRootKey += "No json root key.\nRemember: passing nil as the json root key for the error to the SDOSHTTPErrorJSONResponseSerializer means that the serializer uses the json root key \"error\" by default\n"
            case .some:
                strJSONErrorRootKey += "Yes: \"errors\"\n"
            }
        }
        LoggingViewManager.logString(strSerializerType)
        LoggingViewManager.logString(strJSONResponseRootKey)
        LoggingViewManager.logString(strJSONErrorRootKey)
        
        // Response Code
        var strResponseCodeToLog = "Response code for the request?\n"
        switch configuration.responseCode {
        case .success:
            strResponseCodeToLog += "200\n"
        case .failure:
            strResponseCodeToLog += "400\n"
        }
        LoggingViewManager.logString(strResponseCodeToLog)
            
        // Parsing response type
        var strParseResponse = "Type to parse the response?\n"
        switch configuration.parseForResponse {
        case .userDTO:
            strParseResponse += "\(String(describing: UserDTO.self))\n"
        }
        LoggingViewManager.logString(strParseResponse)
        
        // Parsing error type
        var strParseError = "Type to parse the error?\n"
        switch configuration.parseForError {
        case .errorDTO:
            strParseError += "\(String(describing: ErrorDTO.self))\n"
        }
        LoggingViewManager.logString(strParseError)
    }
    
}

extension Array where Element == ExampleSection {
    var jsonType: JSONType {
        for section in self {
            if case ExampleSection.json(type: let type) = section {
                return type
            }
        }
        return JSONType.correct
    }
    
    var serializerType: SerializerType {
        for section in self {
            if case ExampleSection.serializer(type: let type) = section {
                return type
            }
        }
        return SerializerType.JSONResponseSerializer
    }
    
    var jsonRootForResponse: JSONRoot {
        for section in self {
            if case ExampleSection.jsonRoot(response: let response, error: _) = section {
                return response
            }
        }
        return JSONRoot.none
    }
    
    var jsonRootForError: JSONRoot {
        for section in self {
            if case ExampleSection.jsonRoot(response: _, error: let error) = section {
                return error
            }
        }
        return JSONRoot.none
    }
    
    var responseCode: Result {
        for section in self {
            if case ExampleSection.responseCode(type: let type) = section {
                return type
            }
        }
        return Result.success
    }
    
    var parseForResponse: ResponseObject {
        for section in self {
            if case ExampleSection.parse(response: let response, error: _) = section {
                return response
            }
        }
        return ResponseObject.userDTO
    }
    
    var parseForError: ErrorType {
        for section in self {
            if case ExampleSection.parse(response: _, error: let error) = section {
                return error
            }
        }
        return ErrorType.errorDTO
    }
    
}
