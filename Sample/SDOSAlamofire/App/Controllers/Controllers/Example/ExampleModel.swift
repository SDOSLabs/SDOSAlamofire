//
//  ExampleModel.swift
//  SDOSAlamofireSample
//
//  Created by Antonio Jesús Pallares on 27/02/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation

enum ExampleSection {
    case json(type: JSONType)
    case serializer(type: SerializerType)
    case jsonRoot(response: JSONRoot, error: JSONRoot)
    case responseCode(type: Result)
    case parse(response: ResponseObject, error: ErrorType)
}

enum JSONType: String {
    case correct
    case malformed
}

enum SerializerType: String {
    case JSONResponseSerializer
    case HTTPErrorJSONResponseSerializer
}

enum JSONRoot: String {
    case some
    case none
    
    static var responseRootKey = "user"
    static var errorRootKey = "errors"
}

enum Result: String {
    case success
    case failure
}

enum ResponseObject: String {
    case userDTO
}

enum ErrorType: String {
    case errorDTO
}


//MARK: - Functionality

extension ExampleSection: CaseIterable {
    
    typealias AllCases = [ExampleSection]
    
    static var allCases: ExampleSection.AllCases {
        return [
            .json(type: .correct),
            .serializer(type: .JSONResponseSerializer),
            .jsonRoot(response: .none, error: .none),
            .responseCode(type: .success),
            .parse(response: .userDTO, error: .errorDTO)
        ]
    }
    
    static func initialConfiguration() -> [ExampleSection] {
        return allCases
    }

}

extension ExampleSection {
    
    var sectionTitle: String {
        switch self {
        case .json:
            return NSLocalizedString("SDOSAlamofireSample.example.sectionTitle.json", comment: "")
        case .serializer:
            return NSLocalizedString("SDOSAlamofireSample.example.sectionTitle.serializer", comment: "")
        case .jsonRoot:
            return NSLocalizedString("SDOSAlamofireSample.example.sectionTitle.jsonRoot", comment: "")
        case .responseCode:
            return NSLocalizedString("SDOSAlamofireSample.example.sectionTitle.responseCode", comment: "")
        case .parse:
            return NSLocalizedString("SDOSAlamofireSample.example.sectionTitle.parse", comment: "")
        }
    }
    
    var numberOfRows: Int {
        switch self {
        case .json:
            return 1
        case .serializer:
            return 1
        case .jsonRoot:
            return 2
        case .responseCode:
            return 1
        case .parse:
            return 2
        }
    }
    
    mutating func changeAt(index: Int = 0) {
        switch self {
        case .json(type: let type):
            self = .json(type: type.change())
        case .serializer(type: let type):
            self = .serializer(type: type.change())
        case .jsonRoot(response: var response, error: var error):
            if index == 1 {
                error = error.change()
            } else {
                response = response.change()
            }
            self = .jsonRoot(response: response, error: error)
        case .responseCode(type: let type):
            self = .responseCode(type: type.change())
        case .parse:
            break
        }
    }
    
    func text(for index: Int = 0) -> String {
        switch self {
        case .json(type: let type):
            return cellTitleLocalizedStringFor("JSONType", type.rawValue)
        case .serializer(type: let type):
            return cellTitleLocalizedStringFor("SerializerType", type.rawValue)
        case .jsonRoot(response: let response, error: let error):
            if index == 1 {
                return cellTitleLocalizedStringFor("JSONRoot", error.rawValue, "error")
            } else {
                return cellTitleLocalizedStringFor("JSONRoot", response.rawValue, "response")
            }
        case .responseCode(type: let type):
            return cellTitleLocalizedStringFor("Result", type.rawValue)
        case .parse(response: let response, error: let error):
            if index == 1 {
                return cellTitleLocalizedStringFor("ErrorType", error.rawValue)
            } else {
                return cellTitleLocalizedStringFor("ResponseObject", response.rawValue)
            }
        }
    }
}

extension JSONType {
    func change() -> JSONType {
        switch self {
        case .correct:
            return .malformed
        case .malformed:
            return .correct
        }
    }
}

extension SerializerType {
    func change() -> SerializerType {
        switch self {
        case .JSONResponseSerializer:
            return .HTTPErrorJSONResponseSerializer
        case .HTTPErrorJSONResponseSerializer:
            return .JSONResponseSerializer
        }
    }
}

extension JSONRoot {
    func change() -> JSONRoot {
        switch self {
        case .some:
            return .none
        case .none:
            return .some
        }
    }
    
}

extension Result {
    func change() -> Result {
        switch self {
        case .success:
            return .failure
        case .failure:
            return .success
        }
    }
}


fileprivate func cellTitleLocalizedStringFor(_ args: String...) -> String {
    let strToAdd = args.joined(separator: ".")
    return NSLocalizedString("SDOSAlamofireSample.example.cell.\(strToAdd)", comment: "")
}
