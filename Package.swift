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
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0")),
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
    ]
)
