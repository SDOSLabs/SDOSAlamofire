//
//  GenericErrorDTO.swift
//  Alamofire
//
//  Created by Antonio Jesús Pallares on 07/02/2019.
//

import KeyedCodable

public protocol GenericDTO: Decodable, Keyedable { }
public protocol GenericErrorDTO: GenericDTO & Error {
    
//    var code: Int { get }
//    func isError() -> Bool
}

//extension GenericErrorDTO {
//
//    func isError() {
//        return code != 0
//    }
//}
