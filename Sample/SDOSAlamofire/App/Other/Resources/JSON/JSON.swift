//
//  JSON.swift
//  SDOSAlamofireSample
//
//  Created by Antonio Jesús Pallares on 04/03/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation

struct JSON {
    private init() {}
    
    static var malformedJSONData: Data {
        let url = urlForResourceName("MalformedJSON")
        return try! Data(contentsOf: url)
    }
    
    static var correctJSONData: Data {
        let url = urlForResourceName("Example0")
        return try! Data(contentsOf: url)
    }
    
    static var malformedJSON: String {
        let url = urlForResourceName("MalformedJSON")
        return try! String(contentsOfFile: url.path)
    }
    
    static var correctJSON: String {
        let url = urlForResourceName("Example0")
        return try! String(contentsOfFile: url.path)
    }
    
    private static func urlForResourceName(_ resourceName: String) -> URL {
        let filepath = Bundle.main.path(forResource: resourceName, ofType: "txt")!
        return URL(fileURLWithPath: filepath)
        
    }
}
