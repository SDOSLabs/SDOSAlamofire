//
//  ErrorDTO.swift
//  SDOSAlamofireSample
//
//  Created by Antonio Jesús Pallares on 26/02/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import SDOSAlamofire
import SDOSKeyedCodable

struct ErrorDTO: GenericErrorDTO {
    var code: Int = 0
    var description: String?
    
    mutating func map(map: KeyMap) throws {
        try code <-> map["codError"]
        try description <-> map["descripcion"]
    }
    
    init(from decoder: Decoder) throws {
        try KeyedDecoder(with: decoder).decode(to: &self)
    }
}

extension ErrorDTO: HTTPResponseErrorProtocol {
    func isError() -> Bool {
        return code != 0
    }
}
