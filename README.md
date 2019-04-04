# SDOSAlamofire

- Para consultar los últimos cambios en la librería consultar el [CHANGELOG.md](https://svrgitpub.sdos.es/iOS/SDOSAlamofire/blob/master/CHANGELOG.md).

- Enlace confluence: https://kc.sdos.es/x/OQLLAQ

## Introducción

SDOSAlamofire ofrece una capa de integración con [Alamofire](https://github.com/Alamofire/Alamofire) que proporciona response serializers para el parseo de las respuestas de los servicios web.

## Instalación

### Cocoapods

Usaremos [CocoaPods](https://cocoapods.org). Hay que añadir la dependencia al `Podfile`:

```ruby
pod 'SDOSAlamofire', '~>0.9.4' 
```

## La librería

### Qué hay en SDOSAlamofire

SDOSAlamofire consta de:

1. **Tipos DTO de parseo**:
```js
/// Use this type to parse WS responses
public typealias GenericDTO = Decodable & Keyedable
 
/// Use this type to parse WS response errors
public typealias GenericErrorDTO = AbstractErrorDTO & Keyedable
 
 
public typealias AbstractErrorDTO = Decodable & Error
 
public protocol HTTPResponseErrorProtocol: AbstractErrorDTO {
    func isError() -> Bool
}
 
/// Use this type to parse WS response errors of the legacy type HTTPResponseError
public typealias GenericHTTPResponseErrorDTO = HTTPResponseErrorProtocol & Keyedable
```
Obsérvese que todos los tipos DTO deben implementar los protocolos `Decodable` y `Keyedable`. Para obtener más información sobre cómo implementar estos protocolos, véase [SDOSKeyedCodable](https://kc.sdos.es/x/FALLAQ).

* **`GenericDTO`**: todos los objetos de parseo de respuesta deben implementar este tipo. 

* **`GenericErrorDTO`**: todos los objetos de parseo de errores deben implementar este tipo.

* **`GenericHTTPResponseErrorDTO`**: este tipo debe usarse para los objetos de parseo de errores en las peticiones de tipo error/respuesta.

2. **Response serializers**:
    
    2.1. **`SDOSJSONResponseSerializer`**: es el serializador por defecto que debe usarse por defecto para parsear las respuestas de los servicios web.
    ```js
    public class SDOSJSONResponseSerializer<R: Decodable, E: AbstractErrorDTO>: ResponseSerializer {
        public init(emptyResponseCodes: Set<Int> = default, emptyRequestMethods: Set<HTTPMethod> = default, jsonResponseRootKey: String? = default, jsonErrorRootKey: String? = default)
    }
    ```
    * Parámetros:
        * `emptyResponseCodes`: los códigos de respuesta para los que una respuesta vacía se considera aceptable. Por defecto, para Alamofire son los códigos 204, 205.
        * `emptyRequestMethods`: los métodos HTTP para los que una respuesta vacía se considera aceptable. Por defecto, para Alamofire es el método HEAD.
        * `jsonResponseRootKey`: la clave (o keypath separado por puntos) desde la que iniciar el parseo del objeto de respuesta. El valor por defecto del parámetro es nulo.
        * `jsonErrorRootKey`: la clave (o keypath separado por puntos) desde la que iniciar el parseo del objeto de error de respuesta. El valor por defecto del parámetro es nulo.
            * Todos los parámetros tienen valores por defecto. Por tanto, tenemos 16 init en 1.
    * La lógica de parseo de este serializador es la siguiente:
        * Realiza la serialización en función del código de la respuesta del servidor. 
        * Si el código de la respuesta es válido (por ejemplo, 200), serializa la respuesta utilizando el tipo DTO de respuesta `R`. 
        * Si el código de la respuesta no es un código válido (por ejemplo, 400) utiliza el tipo DTO de error (`E`) para serializar la respuesta.
    * Asimismo, es posible modificar los códigos de respuesta que se consideran aceptables (esto no depende del response serializer). Para ello, la validación de la request debe hacerse con el método `validate` del `DataRequest` (de Alamofire) que recibe el parámetro `acceptableStatusCodes`.

    2.2 **`SDOSHTTPErrorJSONResponseSerializer`**: es el serializador que debe usarse cuando queramos parsear respuestas de tipo error/respuesta, común en los proyectos más antiguos.
    ```js
    public class SDOSHTTPErrorJSONResponseSerializer<R: Decodable, E: HTTPResponseErrorProtocol>: SDOSJSONResponseSerializer<R, E> {
        public init(emptyResponseCodes: Set<Int> = default, emptyRequestMethods: Set<HTTPMethod> = default, jsonResponseRootKey: String? = default, jsonErrorRootKey: String? = default)
    }
    ```
    * Un ejemplo de respuesta de tipo error/respuesta es la siguiente:
    ```js
    Status:
    200 OK
 
    Response JSON:
    {
        "error" : {
            "codError" : 1,
            "descripcion" : "Usuario o contraseña no válidos"
        },
        "respuesta" : null
    }
    ```
    Aunque el código de la respuesta sea un 200 OK, en este caso la respuesta está reflejando un error. Para este tipo de casos, debemos usar el SDOSHTTPErrorJSONResponseSerializer.

    * Parámetros:
        * `emptyResponseCodes`: los códigos de respuesta para los que una respuesta vacía se considera aceptable. Por defecto, para Alamofire son los códigos 204, 205.
        * `emptyRequestMethods`: los métodos HTTP para los que una respuesta vacía se considera aceptable. Por defecto, para Alamofire es el método HEAD.
        * `jsonResponseRootKey`: la clave (o keypath separado por puntos) desde la que iniciar el parseo del objeto de respuesta. El valor por defecto del parámetro es `"respuesta"`.
        * `jsonErrorRootKey`: la clave (o keypath separado por puntos) desde la que iniciar el parseo del objeto de error de respuesta. El valor por defecto del parámetro es `"error"`.
            * Todos los parámetros tienen valores por defecto. Por tanto, tenemos 16 init en 1.
    * La lógica de parseo de este serializador es la siguiente:
        * En primer lugar realiza la serialización del tipo error `E`. Puesto que el tipo `E` debe implementar el protocolo `HTTPResponseErrorProtocol`, en particular implementará el método `isError()`.
        * Si el objeto de error puede parsearse y devuelve `true` para el método `isError()`, entonces se considerará que la petición ha fallado, devolviendo el error parseado.
        * En caso de que no se pueda parsear el error o de que `isError()` devuelva `false`, el serializer se basa en el código de la respuesta.
        * Solo si ese código de respuesta es válido, intenta realizar el parseo de la misma con el tipo `R`.
    * Igualmente, es posible modificar los códigos de respuesta que se consideran aceptables (esto no depende del response serializer). Para ello, la validación de la request debe hacerse con el método `validate` del `DataRequest` (de Alamofire) que recibe el parámetro `acceptableStatusCodes`.

3. **`SDOSAFError`**: SDOSAlamofire añade un nuevo tipo de error, `SDOSAFError`.
    
    ```js
    public enum SDOSAFError : Error {
        case badErrorResponse(code: Int)
    }
    ```

    * Este error se lanzará en los siguientes casos concretos:
        * Cuando, usando el `SDOSJSONResponseSerializer`, el código de respuesta de la petición web es de error pero no es posible parsear el JSON de respuesta con el tipo proporcionado `R`. Esto puede darse cuando la petición web devuelve un error 500 pues, en este caso, es común que la respuesta sea un texto XML con la traza del error del servidor.
        * Cuando, usando el `SDOSHTTPErrorJSONResponseSerializer`, el código de respuesta de la petición web es de error pero, o bien no es posible parsear el JSON de respuesta como error o bien el método `isError()` del error parseado devuelve `false`.

4.  **Extensión de `DataRequest`** para el uso de los response serializers anteriores. 
    
    ```js
    extension DataRequest {
        @discardableResult
        public func responseSDOSDecodable<R: Decodable, E: AbstractErrorDTO>(responseSerializer: SDOSJSONResponseSerializer<R, E>,
                                                                            queue: DispatchQueue? = nil,
                                                                            completionHandler: @escaping(DataResponse<R>) -> Void) -> Self
    }
    ```

### Cómo usar SDOSAlamofire
Por lo general, para hacer peticiones web, necesitaremos:
* Struct de respuesta DTO que implemente `GenericDTO`.
* Struct de error DTO que implemente `GenericErrorDTO`.
* Una instancia de `SDOSJSONResponseSerializer` con los dos tipos anteriores. 
* El método `responseSDOSDecodable(responseSerializer:, completionHandler:)` declarado en la extensión de `DataRequest` que recibirá el anterior response serializer.

Alamofire permite customizar, entre otros:
* La serialización de la petición (lo que en AFNetworking se correspondía con los request serializers). Esto se haría mediante el parámetro `encoding: ParameterEncoding` del método `request(...)`. (Ver archivo Alamofire.swift)
* Los headers de la petición. Esto se haría mediante el parámetro `headers: HTTPHeaders?` del método `request(...)`.
* La validación de la respuesta. Todos los métodos para validar la respuesta se encuentra en el archivo Validation.swift. El método `validate()` de Alamofire valida:
    1. Que el código de respuesta sea aceptable. Por defecto, los códigos válidos son los 2XX ( Array(200..<300)).
    2. Que el content type de la respuesta sea aceptable.
* El interceptor de la petición mediante el parámetro `interceptor: RequestInterceptor?`. Esto permitiría, por ejemplo, implementar una capa de Oauth que se encargara de refrescar el token de acceso caducado.

### Ejemplos de peticiones con SDOSAlamofire

**Ejemplo 1**

Este es el caso más básico posible.
* Usamos `SDOSJSONResponseSerializer` con los DTO `UserDTO` y `ErrorDTO`.
* Hacemos una petición GET.
* Validamos la respuesta con el método básico `validate()`.
* Parseamos la respuesta con el response serializer anterior.

```js
let responseSerializer = SDOSJSONResponseSerializer<UserDTO, ErrorDTO>()
let strURL = "https://base.url.es/user"
AF.request(strURL, method: .get, parameters: nil).validate().responseSDOSDecodable(responseSerializer: responseSerializer) { response in
    switch response.result {
    case .success(let user):
        // Petición realizada con éxito y 'user' parseado correctamente
    case .failure(let error as ErrorDTO):
        // La petición ha devuelto un error y la respuesta se ha parseado con el tipo 'ErrorDTO'
    case .failure(let error):
        // La petición ha devuelto un error no controlado
    }
}
```

**Ejemplo 2**
* Usamos `SDOSJSONResponseSerializer` con los DTO `UserDTO` y `ErrorDTO`.
* Usamos la clave root de respuesta `"user"` y la clave root de error `"error"`.
* Hacemos una petición POST enviando un diccionario de parámetros.
* Validamos la respuesta con el método básico `validate()`.
* Parseamos la respuesta con el response serializer anterior.

```js
let responseRootKey = "user"
let errorRootKey = "error"
let responseSerializer = SDOSJSONResponseSerializer<UserDTO, ErrorDTO>(jsonResponseRootKey: responseRootKey, jsonErrorRootKey: errorRootKey)
let strURL = "https://base.url.es/user"
let parameters: Parameters = ["id" : 1242,
                              "name" : "Alberto",
                              "surname" : "Alfaro"]
AF.request(strURL, method: .post, parameters: parameters).validate().responseSDOSDecodable(responseSerializer: responseSerializer) { response in
    switch response.result {
    case .success(let user):
        // Petición realizada con éxito y 'user' parseado correctamente
    case .failure(let error as ErrorDTO):
        // La petición ha devuelto un error y la respuesta se ha parseado con el tipo 'ErrorDTO'
    case .failure(let error):
        // La petición ha devuelto un error no controlado
    }
}
```

## Proyecto de ejemplo

* Descargar el proyecto SDOSAlamofire desde el siguiente enlace: https://svrgitpub.sdos.es/iOS/SDOSAlamofire.
* Comprobar que, al pulsar el botón **Ver ejemplo** se muestra una app que permite simular llamadas a un servicio. Podemos elegir diversos parámetros para modificar la llamada al servicio

## Dependencias

* Alamofire 5.0.0-beta-4

## Referencias

* [Alamofire](https://github.com/Alamofire/Alamofire)
* [SDOSKeyedCodable](https://kc.sdos.es/x/FALLAQ)
* https://svrgitpub.sdos.es/iOS/SDOSAlamofire


Esta documentación ha sido publicada a partir del fichero README.md de la librería. **No editar**