//
//  InfoModel.swift
//  SDOSAlamofireSample
//
//  Created by Antonio Jesús Pallares on 27/02/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation

struct InfoModel {
    let title: String
    let explanation: String
}

extension JSONType {
    var infoTitle: String {
        return titleLocalizedStringFor("JSONType", self.rawValue)
    }
    var infoExplanation: String {
        switch self {
        case .correct:
            return JSON.correctJSON
        case .malformed:
            return JSON.malformedJSON
        }
    }
}

extension SerializerType {
    var infoTitle : String {
        return titleLocalizedStringFor("SerializerType", self.rawValue)
    }
    var infoExplanation : String {
        return explanationLocalizedStringFor("SerializerType", self.rawValue)
    }
}

extension JSONRoot {
    var infoTitle : String {
        return titleLocalizedStringFor("JSONRoot")
    }
    var infoExplanation : String {
        return explanationLocalizedStringFor("JSONRoot")
    } 
}

extension Result {
    var infoTitle : String {
        return titleLocalizedStringFor("Result", self.rawValue)
    }
    var infoExplanation : String {
        return explanationLocalizedStringFor("Result", self.rawValue)
    }
}

extension ResponseObject {
    var infoTitle : String {
        return titleLocalizedStringFor("ResponseObject", self.rawValue)
    }
    var infoExplanation : String {
        return explanationLocalizedStringFor("ResponseObject", self.rawValue)
    }
}

extension ErrorType {
    var infoTitle : String {
        return titleLocalizedStringFor("ErrorType", self.rawValue)
    }
    var infoExplanation : String {
        return explanationLocalizedStringFor("ErrorType", self.rawValue)
    }
}

fileprivate func titleLocalizedStringFor(_ args: String...) -> String {
    let strToAdd = args.joined(separator: ".")
    return NSLocalizedString("SDOSAlamofireSample.example.info.\(strToAdd).title", comment: "")
}

fileprivate func explanationLocalizedStringFor(_ args: String...) -> String {
    let strToAdd = args.joined(separator: ".")
    return NSLocalizedString("SDOSAlamofireSample.example.info.\(strToAdd).explanation", comment: "")
}

extension ExampleSection {
 
    func infoModel(atIndex index: Int = 0) -> InfoModel {
        let title: String
        let explanation: String
        switch self {
        case .json(type: let type):
            title = type.infoTitle
            explanation = type.infoExplanation
        case .serializer(type: let type):
            title = type.infoTitle
            explanation = type.infoExplanation
        case .jsonRoot(response: let response, error: let error):
            if index == 1 {
                title = error.infoTitle
                explanation = error.infoExplanation
            } else {
                title = response.infoTitle
                explanation = response.infoExplanation
            }
        case .responseCode(type: let type):
            title = type.infoTitle
            explanation = type.infoExplanation
        case .parse(response: let response, error: let error):
            if index == 1 {
                title = error.infoTitle
                explanation = error.infoExplanation
            } else {
                title = response.infoTitle
                explanation = response.infoExplanation
            }
        }
        return InfoModel(title: title, explanation: explanation)
    }
    
}
