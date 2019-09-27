- [SDOSAlamofire](#sdosalamofire)
  - [Introducción](#introducci%c3%b3n)
  - [Instalación](#instalaci%c3%b3n)
    - [Cocoapods](#cocoapods)
  - [La librería](#la-librer%c3%ada)
    - [Qué hay en SDOSAlamofire](#qu%c3%a9-hay-en-sdosalamofire)
    - [Cómo usar SDOSAlamofire](#c%c3%b3mo-usar-sdosalamofire)
    - [Ejemplos de peticiones con SDOSAlamofire](#ejemplos-de-peticiones-con-sdosalamofire)
  - [Proyecto de ejemplo](#proyecto-de-ejemplo)
  - [Dependencias](#dependencias)
  - [Referencias](#referencias)
- [SDOSAlamofire+JSONAPI](#sdosalamofirejsonapi)
  - [Introducción](#introducci%c3%b3n-1)
  - [Instalación](#instalaci%c3%b3n-1)
    - [Cocoapods](#cocoapods-1)
  - [ResponseSerializer](#responseserializer)
    - [SDOSJSONAPIResponseSerializer](#sdosjsonapiresponseserializer)
    - [Modelos](#modelos)
    - [Ejemplo](#ejemplo)
  - [Dependencias](#dependencias-1)

# SDOSAlamofire

- Para consultar los últimos cambios en la librería consultar el [CHANGELOG.md](https://github.com/SDOSLabs/SDOSAlamofire/blob/master/CHANGELOG.md).

- Enlace confluence: https://kc.sdos.es/x/OQLLAQ

## Introducción

SDOSAlamofire ofrece una capa de integración con [Alamofire](https://github.com/Alamofire/Alamofire) que proporciona response serializers para el parseo de las respuestas de los servicios web.

## Instalación

### Cocoapods

Usaremos [CocoaPods](https://cocoapods.org). Hay que añadir la dependencia al `Podfile`:

```ruby
pod 'SDOSAlamofire', '~>0.10.0' 
```

## La librería

### Qué hay en SDOSAlamofire

SDOSAlamofire consta de:

1. **`GenericSession`**: la subclase del tipo `Session` de Alamofire que deberemos usar para hacer las peticiones web. Únicamente añade los HTTP headers:
    * `"device"`: enviando el modelo del dispositivo desde el que se realiza la petición. El valor que se envía es el devuelto por `UIDevice.current.deviceInformation` declarado en [SDOSSwiftExtension](	https://kc.sdos.es/x/DALLAQ)
    * `"version"`: enviando la versión de iOS del dispositivo desde el que se realiza la petición. El valor que se envía es el devuelto por `UIApplication.version` declarado en [SDOSSwiftExtension](	https://kc.sdos.es/x/DALLAQ)
    * `"Accept-Language"`: enviando el locale actual del dispositivo desde el que se realiza la petición. El valor que se envía es el devuelto por `Locale.currentLocale` declarado en [SDOSSwiftExtension](	https://kc.sdos.es/x/DALLAQ)

    La instancia del `GenericSession` (o subclase) que utilicemos para realizar las peticiones web, **deberá guardarse en una variable** (generalmente en el objeto Repository):
    ```js
    class UserRepository: BaseRepository {
        private lazy var session = GenericSession()
    }
    ```
    Esto se debe a que cuando el objeto `GenericSession` se libera de memoria (dealloc / deinit) éste se encarga de cancelar todas sus peticiones web activas. Este comportamiento es especialmente útil cuando se se sale de una pantalla (por ejemplo, un detalle) cuya petición web asociada no se ha completado; la petición web se cancela porque ya no se necesitan los datos de la respuesta.

2. **Tipos DTO de parseo**:
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

3. **Response serializers**:
    
    3.1. **`SDOSJSONResponseSerializer`**: es el serializador por defecto que debe usarse por defecto para parsear las respuestas de los servicios web.
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

    3.2 **`SDOSHTTPErrorJSONResponseSerializer`**: es el serializador que debe usarse cuando queramos parsear respuestas de tipo error/respuesta, común en los proyectos más antiguos.
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

    
4. **`AFError`'s `errorDTO`**: SDOSAlamofire añade la propiedad `errorDTO` al tipo de error de Alamofire (`AFError`) para acceder rápidamente al objeto DTO error de parseo.
    
    ```js
    public extension AFError {
        var errorDTO: AbstractErrorDTO?
    }
    ```

5.  **Extensión de `DataRequest`** para el uso de los response serializers anteriores. 
    
    ```js
    extension DataRequest {
        @discardableResult
        public func responseSDOSDecodable<R: Decodable, E: AbstractErrorDTO>(responseSerializer: SDOSJSONResponseSerializer<R, E>,
                                                                            queue: DispatchQueue? = nil,
                                                                            completionHandler: @escaping(DataResponse<R>) -> Void) -> Self
    }
    ```

6. **`RequestValue`**: struct que servirá como respuesta para los objetos Repository. Es un wrapper que contiene una `Request`y un objeto de tipo genérico que, por lo general, será un `Promise`.

### Cómo usar SDOSAlamofire
Por lo general, para hacer peticiones web, necesitaremos:
* Struct de respuesta DTO que implemente `GenericDTO`.
* Struct de error DTO que implemente `GenericErrorDTO`.
* Una instancia de `SDOSJSONResponseSerializer` con los dos tipos anteriores. 
* El método `responseSDOSDecodable(responseSerializer:, completionHandler:)` declarado en la extensión de `DataRequest` que recibirá el anterior response serializer.
* Hacer uso de [PromiseKit](https://github.com/mxcl/PromiseKit) para tratar con las posibles respuestas del Repository.

Alamofire permite customizar, entre otros:
* La serialización de la petición (lo que en AFNetworking se correspondía con los request serializers). Esto se haría mediante el parámetro `encoding: ParameterEncoding` del método `request(...)`. (Ver archivo Alamofire.swift). Por defecto el encoding de los parámetros se hace en la URL (`URLEncoding.default`). **Si queremos enviar los parámetros en JSON deberemos pasar `JSONEncoding.default`**
* Los headers de la petición. Esto se haría mediante el parámetro `headers: HTTPHeaders?` del método `request(...)`.
* La validación de la respuesta. Todos los métodos para validar la respuesta se encuentra en el archivo Validation.swift. El método `validate()` de Alamofire valida:
    1. Que el código de respuesta sea aceptable. Por defecto, los códigos válidos son los 2XX ( Array(200..<300)).
    2. Que el content type de la respuesta sea aceptable.
* El interceptor de la petición mediante el parámetro `interceptor: RequestInterceptor?`. Esto permitiría, por ejemplo, implementar una capa de Oauth para refrescar el token de acceso caducado.

### Ejemplos de peticiones con SDOSAlamofire

**Ejemplo 1**

En general, las peticiones web en nuestros desarrollos tendrán una implementación similar a la siguiente (en este caso, el código estaría implementado en el `NewsRepository`):
```js
fileprivate lazy var session = GenericSession()

func loadList() -> RequestValue<Promise<[NewsListBO]>> {

    var url = "https://api.myjson.com/bins/wro6i"
    let responseSerializer = SDOSJSONResponseSerializer<[NewsDTO], ErrorDTO>()
    let request = session.request(url, method: .get, parameters: nil)

    let promise = Promise<[NewsListBO]> { seal in
        request.validate().responseSDOSDecodable(responseSerializer: responseSerializer) {
            (dataResponse: DataResponse<[NewsDTO]>) in
            switch dataResponse.result {
            case .success(let newsList):
                seal.fulfill(newsList)
            case .failure(let error as AFError):
                switch error {
                case .explicitlyCancelled, .sessionDeinitialized:
                    seal.reject(PMKError.cancelled)
                default:
                    seal.reject(error)
                }
            case .failure(let error):
                seal.reject(error)
            }
        }
        }.map { items -> [NewsListBO] in
            items
    }

    return RequestValue(request: request, value: promise)
}
```
* Usamos `SDOSJSONResponseSerializer` con los DTO `[NewsDTO]` y `ErrorDTO`.
* Hacemos una petición GET sin parámetros.
* Validamos la respuesta con el método básico `validate()`.
* Parseamos la respuesta con el response serializer anterior.
* El método devuelve un `RequestValue` que contiene el `Promise<[NewsDTO]>`y el `DataRequest`.

**Ejemplo 2**

Este ejemplo es similar al anterior, pero la petición tiene parámetros (en la URL):

```js
fileprivate lazy var session = GenericSession()

func loadDetail(record: String, campaign: String) -> RequestValue<Promise<RecordBO>> {
    let url = Constants.ws.records + "/" + record
    let responseSerializer = SDOSJSONResponseSerializer<RecordDTO, ErrorDTO>()
    let parameters: Parameters = [Constants.ws.keys.campaign : campaign]
    let request = session.request(url, method: .get, parameters: parameters)
        
    let promise = Promise<RecordBO> { seal in
        request.validate().responseSDOSDecodable(responseSerializer: responseSerializer) {
            (dataResponse: DataResponse<RecordDTO>) in
            switch dataResponse.result {
            case .success(let item):
                seal.fulfill(item)
            case .failure(let error as AFError):
                switch error {
                case .explicitlyCancelled, .sessionDeinitialized:
                    seal.reject(PMKError.cancelled)
                default:
                    seal.reject(error)
                }
            case .failure(let error):
                seal.reject(error)
            }
        }
        }.map { item -> RecordBO in
            item //By default BO is the same object than DTO. Only need return
    }
        
    return RequestValue(request: request, value: promise)
}
```
* Usamos `SDOSJSONResponseSerializer` con los DTO `RecordDTO` y `ErrorDTO`.
* Hacemos una petición GET con parámetros. Los parámetros se envían en la URL (ya que no se especifica otra cosa con el parámetro `encoding:` del método `request(...)`).
* Validamos la respuesta con el método básico `validate()`.
* Parseamos la respuesta con el response serializer anterior.
* El método devuelve un `RequestValue` que contiene el `Promise<[NewsDTO]>` y el `DataRequest`.

**Ejemplo 3**

Este es el caso más básico posible. 
* Usamos `SDOSJSONResponseSerializer` con los DTO `UserDTO` y `ErrorDTO`.
* Hacemos una petición GET.
* Validamos la respuesta con el método básico `validate()`.
* Parseamos la respuesta con el response serializer anterior.
* No se usa [PromiseKit](https://github.com/mxcl/PromiseKit). En nuestros desarrollos el Repository siempre debe devolver un Promise en las peticiones.

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

**Ejemplo 4**
* Usamos `SDOSJSONResponseSerializer` con los DTO `UserDTO` y `ErrorDTO`.
* Usamos la clave root de respuesta `"user"` y la clave root de error `"error"`.
* Hacemos una petición POST enviando un diccionario de parámetros en JSON.
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
AF.request(strURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseSDOSDecodable(responseSerializer: responseSerializer) { response in
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

* Descargar el proyecto SDOSAlamofire desde el siguiente enlace: https://github.com/SDOSLabs/SDOSAlamofire.
* Comprobar que, al pulsar el botón **Ver ejemplo** se muestra una app que permite simular llamadas a un servicio. Podemos elegir diversos parámetros para modificar la llamada al servicio

## Dependencias

* [Alamofire](https://github.com/Alamofire/Alamofire) 5.0.0-rc.2
* [SDOSSwiftExtension](https://kc.sdos.es/x/DALLAQ)

## Referencias

* [Alamofire](https://github.com/Alamofire/Alamofire)
* [SDOSKeyedCodable](https://kc.sdos.es/x/FALLAQ)
* [PromiseKit](https://github.com/mxcl/PromiseKit)
* https://github.com/SDOSLabs/SDOSAlamofire

# SDOSAlamofire+JSONAPI

## Introducción

Con SDOSAlamofire podemos integrar un serializer para el parseo de las respuestas de los servicios web con una estructura [JSON:API](https://jsonapi.org).

## Instalación

### Cocoapods

Usaremos [CocoaPods](https://cocoapods.org). Hay que añadir la dependencia al `Podfile`:

```ruby
pod 'SDOSAlamofire/JSONAPI', '~>0.10.0'
```

## ResponseSerializer

### SDOSJSONAPIResponseSerializer

**`SDOSJSONAPIResponseSerializer`**: es el serializador que se usará para parsear los servicios que vengan con estructura JSONAPI.

```js
public class SDOSJSONAPIResponseSerializer<R: Decodable, E: AbstractErrorDTO>: ResponseSerializer {
    public init(includeList: String? = nil, keyPath: String? = JSONAPI.rootPath)
}
    
* Parámetros:
    * `includeList`: Lista de includes para la deserialización de relaciones de JSON:API.
    * `keyPath`: Raiz del JSON para su decodificación.
```

### Modelos

Los modelos de datos son iguales que los modelos que usamos para **`SDOSJSONResponseSerializer`**:

```js
public struct RouteDTO: GenericDTO {
    var type: String?
    var id: String?
    var title: String?
    var body: String?
    var category: CategoryDTO? //Include
    
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

struct CategoryDTO: GenericDTO {
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
```

### Ejemplo

La forma de usar **`SDOSJSONAPIResponseSerializer`** es similar a **`SDOSJSONResponseSerializer`**:

```js
fileprivate lazy var session = GenericSession()

func loadRoutes() -> RequestValue<Promise<[RouteBO]>> {

    var url = "https://staging-costa-turismo.sdos-dev.tech/es/jsonapi/node/scity_route?sort=title&page[offset]=0&page[limit]=1&include=field_route_category"
    let responseSerializer = SDOSJSONAPIResponseSerializer<[RouteDTO], ErrorDTO>()
    let request = session.request(url, method: .get, parameters: nil)

    let promise = Promise<[RouteBO]> { seal in
        request.validate().responseJSONAPI(responseSerializer: responseSerializer) {
            (dataResponse: DataResponse<[RouteDTO]>) in
            switch dataResponse.result {
            case .success(let routesList):
                seal.fulfill(routesList)
            case .failure(let error as AFError):
                switch error {
                case .explicitlyCancelled, .sessionDeinitialized:
                    seal.reject(PMKError.cancelled)
                default:
                    seal.reject(error)
                }
            case .failure(let error):
                seal.reject(error)
            }
        }
        }.map { items -> [RouteBO] in
            items
    }

    return RequestValue(request: request, value: promise)
}
```

## Dependencias

* [SDOSAlamofire](https://github.com/SDOSLabs/SDOSAlamofire)
* [Japx/Codable](https://github.com/infinum/Japx) 2.1.0
