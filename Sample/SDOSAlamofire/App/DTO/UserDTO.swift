//
//  UserDTO.swift
//  SDOSAlamofireSample
//
//  Created by Antonio Jesús Pallares on 07/02/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import SDOSAlamofire
import SDOSKeyedCodable

struct UserDTO: GenericDTO {
    
    var code: String!
    var name: String!
    var birthday: String?
    var signUpDatetime: String?
    
    mutating func map(map: KeyMap) throws {
        try code <-> map["codigo"]
        try name <-> map["nombre"]
        try birthday <-> map["fechas.nacimiento"]
        try signUpDatetime <-> map["fechas.inscripcion"]
    }
    
    init(from decoder: Decoder) throws {
        try KeyedDecoder(with: decoder).decode(to: &self)
    }

}
