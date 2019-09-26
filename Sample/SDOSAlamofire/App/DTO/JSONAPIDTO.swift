//
//  JSONAPI.swift
//  SDOSAlamofireSample
//
//  Created by José Manuel Velázquez on 25/09/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import SDOSKeyedCodable
import SDOSAlamofire

public struct Route: GenericDTO {
    var type: String?
    var id: String?
    var title: String?
    var body: String?
    var category: Category? //Include
    
    mutating public func map(map: KeyMap) throws {
        try type <-> map["type"]
        try id <-> map["id"]
        try title <-> map["title"]
        try body <-> map["body.value"]
        try category <<- map["field_route_category"]
    }
    
    public init(from decoder: Decoder) throws {
        try KeyedDecoder(with: decoder).decode(to: &self)
    }
}

struct Category: GenericDTO {
    var type: String?
    var id: String?
    var name: String?
    
    mutating func map(map: KeyMap) throws {
        try type <-> map["type"]
        try id <-> map["id"]
        try name <-> map["name"]
    }
    
    init(from decoder: Decoder) throws {
        try KeyedDecoder(with: decoder).decode(to: &self)
    }
}
