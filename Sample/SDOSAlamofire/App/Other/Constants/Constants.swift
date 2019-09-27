//
//  Constants.swift
//  SDOSAlamofireSample
//
//  Created by Antonio Jesús Pallares on 07/02/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation

struct Constants {
    private init() {}
    
    struct Documentation {
        private init() { }
        
        static let url = "https://kc.sdos.es/x/OQLLAQ"
    }
    
    struct Navigation {
        private init() { }
        
        static let goBackButtonTitle = "<"
        static let goForwardButtonTitle = ">"
    }
    
    struct App {
        private init() { }
        
        static var versionStringFormat: String {
            return NSLocalizedString("SDOSAlamofireSample.version", comment: "")
        }
    }
    
    struct WS {
        static let wsUserURL = "http://prueba.es"
        static let wsJSONAPIURL = "https://staging-costa-turismo.sdos-dev.tech/es/jsonapi/node/scity_route?sort=title&page[offset]=0&page[limit]=1&include=field_route_category"
    }
}
