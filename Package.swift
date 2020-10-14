// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SDOSAlamofire",
    platforms: [
        .iOS("10.0")
    ],
    products: [
        .library(
            name: "SDOSAlamofire",
            targets: ["SDOSAlamofire"]),
        .library(
            name: "SDOSAlamofireJSONAPI",
            targets: ["SDOSAlamofireJSONAPI"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0")),
        //        .package(url: "https://github.com/SDOSLabs/Japx.git", .branch("feature/spm")),
        .package(path: "../Japx"),
        .package(url: "https://github.com/SDOSLabs/SDOSKeyedCodable.git", .branch("feature/spm")),
        .package(url: "https://github.com/SDOSLabs/SDOSSwiftExtension.git", .branch("feature/spm"))
        
    ],
    targets: [
        .target(
            name: "SDOSAlamofire",
            dependencies: [
                "Alamofire",
                "SDOSKeyedCodable",
                "SDOSSwiftExtension"
            ],
            path: "src/Classes/Core"),
        .target(
            name: "SDOSAlamofireJSONAPI",
            dependencies: [
                "SDOSAlamofire",
                .product(name: "JapxCodable", package: "Japx")
            ],
            path: "src/Classes/JSONAPI")
        
    ]
)
