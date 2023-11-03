// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkModule",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
        .macOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PromiseNetworkKit",
            targets: ["PromiseNetworkKit"]
        ),
        .library(
            name: "CombineNetworkKit",
            targets: ["CombineNetworkKit"]
        ),
        .library(
            name: "RxNetworkKit",
            targets: ["RxNetworkKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.7.1"),
        .package(url: "https://github.com/mxcl/PromiseKit.git", from: "8.0.0"),
        .package(url: "https://github.com/httpswift/swifter.git", from: "1.5.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxAlamofire.git", from: "6.1.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PromiseNetworkKit",
            dependencies: [
                "Alamofire",
                "PromiseKit"
            ]
        ),
        .target(
            name: "CombineNetworkKit",
            dependencies: []
        ),
        .target(
            name: "RxNetworkKit",
            dependencies: [
                "RxAlamofire",
            ]
        ),
        .testTarget(
            name: "NetworkModuleTests",
            dependencies: [
                "PromiseNetworkKit",
                "CombineNetworkKit",
                "RxNetworkKit",
                .product(name: "Swifter", package: "swifter")
            ]
        ),
    ]
)
