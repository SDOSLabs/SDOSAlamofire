// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SDOSAlamofire",
    products: [
        .library(
            name: "SDOSAlamofire",
            targets: ["SDOSAlamofire"])
    ],
    dependencies: [
                .package(url: "https://github.com/Alamofire/Alamofire.git", .branch("5.0.0-beta.6")),
                .package(url: "git@svrgitpub.sdos.es:iOS/SDOSKeyedCodable.git", .branch("feature/spm")),
                .package(url: "git@svrgitpub.sdos.es:iOS/SDOSSwiftExtension.git", .branch("feature/spm"))

    ],
    targets: [
        .target(
            name: "SDOSAlamofire",
            dependencies: [],
            path: "src")
    ]
)
