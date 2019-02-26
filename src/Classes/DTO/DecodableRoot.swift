//
//  GenericErrorDTO.swift
//  SDOSAlamofire
//
//  Created by Antonio Jesús Pallares on 12/02/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import SDOSKeyedCodable

extension CodingUserInfoKey {

    static let jsonDecoderRootKeyName = CodingUserInfoKey(rawValue: "rootKeyName")!

}

internal struct DecodableRoot<T>: Decodable, Keyedable where T: Decodable {

    private(set) var value: T!
    let jsonRootKeyPath: String
    
    private static var defaultDecodingError: Error {
        return DecodingError.valueNotFound(
            T.self,
            DecodingError.Context(codingPath: [], debugDescription: "Value not found at root level.")
        )
    }
    
    init(from decoder: Decoder) throws {
        guard let keyPath = decoder.userInfo[CodingUserInfoKey.jsonDecoderRootKeyName] as? String else {
            throw DecodableRoot<T>.defaultDecodingError
        }
        self.jsonRootKeyPath = keyPath
        try KeyedDecoder(with: decoder).decode(to: &self)
    }
    
    mutating func map(map: KeyMap) throws {
        try value <<- map[jsonRootKeyPath]
    
        guard value != nil else {
            throw DecodableRoot<T>.defaultDecodingError
        }
    }

}
