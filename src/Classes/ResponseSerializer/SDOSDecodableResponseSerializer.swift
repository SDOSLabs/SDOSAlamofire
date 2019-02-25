//
//  SDOSDecodableResponseSerializer.swift
//  Alamofire
//
//  Created by Antonio Jesús Pallares on 07/02/2019.
//

import Foundation
import Alamofire

//    typealias SDOSJSONResponseSerializerDefaultError<ResponseDTO: GenericDTO> = SDOSJSONResponseSerializer<ResponseDTO, DefaultErrorDTO>

public class SDOSJSONResponseSerializer<ResponseDTO: GenericDTO, ErrorDTO: GenericErrorDTO>: ResponseSerializer {
    
    //TODO: ¿Deberíamos tener un DefaultErrorDTO? De esa forma, no siempre tendríamos que crear un objeto para parsear el error. En Obj-c, no se ponía el objeto de error (errorClass) en todas las peticiones. El problema es que, en Swift no se puede tener un genérico con un valor por defecto, por ejemplo:
    
//    public class SDOSJSONResponseSerializer<ResponseDTO: GenericDTO, ErrorDTO: GenericErrorDTO = DefaultErrorDTO>: ResponseSerializer { }
    
    // Lo que sí se podría es definir un typealias
    
//    typealias SDOSJSONResponseSerializerDefaultError<ResponseDTO: GenericDTO> = SDOSJSONResponseSerializer<ResponseDTO, DefaultErrorDTO>
    
    // Pero eso haría que habiera dos nombres para los response serializer: uno para un errorDTO 'custom', y otro para el DefaultErrorDTO.
    
    public let emptyResponseCodes: Set<Int>
    public let emptyRequestMethods: Set<HTTPMethod>
    public let jsonResponseRootKey: String?
    public let jsonErrorRootKey: String?
    
    private lazy var responseSerializer: DecodableResponseSerializer<ResponseDTO> = {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.jsonDecoderRootKeyName] = jsonResponseRootKey
        return DecodableResponseSerializer<ResponseDTO>(decoder: decoder, emptyResponseCodes: emptyResponseCodes, emptyRequestMethods: emptyRequestMethods)
    }()
    
    private lazy var responseErrorSerializer: DecodableResponseSerializer<ErrorDTO> = {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.jsonDecoderRootKeyName] = jsonErrorRootKey
        return DecodableResponseSerializer<ErrorDTO>(decoder: errorDecoder, emptyResponseCodes: [], emptyRequestMethods: [])
    }()
    
    /// QUE APAREZCA --> "16 en 1"
    ///
    /// - Parameters:
    ///   - emptyResponseCodes: <#emptyResponseCodes description#>
    ///   - emptyRequestMethods: <#emptyRequestMethods description#>
    ///   - jsonResponseRootKey: <#jsonResponseRootKey description#>
    ///   - jsonErrorRootKey: <#jsonErrorRootKey description#>
    public init(emptyResponseCodes: Set<Int> = DecodableResponseSerializer<ResponseDTO>.defaultEmptyResponseCodes,
                emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<ResponseDTO>.defaultEmptyRequestMethods,
                jsonResponseRootKey: String? = nil,
                jsonErrorRootKey: String? = nil) {
        self.emptyResponseCodes = emptyResponseCodes
        self.emptyRequestMethods = emptyRequestMethods
        self.jsonResponseRootKey = jsonResponseRootKey
        self.jsonErrorRootKey = jsonErrorRootKey
    }
    
    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> ResponseDTO {
            if let errorRootKey = jsonErrorRootKey {
                if let decodableError: DecodableRoot<ErrorDTO> = try? responseErrorSerializer.serialize(request: request, response: response, data: data, error: nil), decodableError.value.isError() {
                    throw decodableError.value
                }
            } else if let error = try? responseErrorSerializer.serialize(request: request, response: response, data: data, error: nil), error.isError() {
                throw error
        } else if let responseRootKey = jsonR
        return try responseSerializer.serialize(request: request, response: response, data: data, error: error)
        
        //TODO: Si lo hacemos así, perderíamos el código del error cuando el responseErrorSerializer serializa correctamente el objeto error
        
//        if
//            let error = error as? AFError.ResponseValidationFailureReason,
//            case AFError.ResponseValidationFailureReason.unacceptableStatusCode(let code) = error
//            {
//                //TODO: Parse error and throw it
//
//                throw NSError(domain: "REMOVE", code: code, userInfo: nil)
//        } else {
//            return try responseSerializer.serialize(request: request, response: response, data: data, error: error)
//        }
        
        // Pero haciéndolo así, solo se intentaría parsear el objeto de error cuando el código de respuesta sera un código de los no aceptados. Y esto no permitiría tener una respuesta con un 200 y parsear a un error
    }
    
}
