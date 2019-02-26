//
//  GenericErrorDTO.swift
//  SDOSAlamofire
//
//  Created by Antonio Jesús Pallares on 07/02/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import SDOSKeyedCodable

// Versión 1

public protocol GenericDTO: Decodable { }
public protocol GenericErrorDTO: GenericDTO, Error { }
public protocol HTTPResponseErrorDTO: GenericErrorDTO {
    func isError() -> Bool
}

extension Array: HTTPResponseErrorDTO where Element: HTTPResponseErrorDTO {
    
    public func isError() -> Bool {
        for item in self {
            if item.isError() {
                return true
            }
        }
        return false
    }
}

extension Array: GenericErrorDTO where Element: GenericErrorDTO { }
extension Array: GenericDTO where Element: GenericDTO { }
extension Array: Error where Element: Error { }

extension Array: Keyedable where Element: Keyedable {
    
}


// Versión 2

// Use GenericDTO only (do not use AbstractDTO)
public protocol AbstractDTO: Decodable { }
public protocol GenericDTO: AbstractDTO, Keyedable { }

// Use GenericErrorDTO only
public protocol AbstractErrorDTO: AbstractDTO, Error { }
public protocol GenericErrorDTO: AbstractErrorDTO, Keyedable { }

// Use HTTPResponseErrorDTO only
public protocol AbstractHTTPResponseErrorDTO: AbstractErrorDTO {
    func isError() -> Bool
}
public protocol HTTPResponseErrorDTO: AbstractHTTPResponseErrorDTO, Keyedable { }

extension Array: AbstractHTTPResponseErrorDTO where Element: AbstractHTTPResponseErrorDTO {
    
    public func isError() -> Bool {
        for item in self {
            if item.isError() {
                return true
            }
        }
        return false
    }
    
}

extension Array: AbstractErrorDTO where Element: AbstractErrorDTO { }
extension Array: AbstractDTO where Element: AbstractDTO { }
extension Array: Error where Element: AbstractErrorDTO { }

