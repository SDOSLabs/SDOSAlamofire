// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SDOSAlamofire",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "SDOSAlamofire",
            targets: ["SDOSAlamofire"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.3.0")),
        .package(url: "https://github.com/SDOSLabs/SDOSKeyedCodable.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/SDOSLabs/SDOSSwiftExtension.git", .upToNextMajor(from: "1.1.0"))
        
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
    ]
)
