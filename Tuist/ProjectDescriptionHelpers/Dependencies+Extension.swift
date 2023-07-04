import ProjectDescription

public extension Package {
    static let Alamofire = Package.remote(
        url: "https://github.com/Alamofire/Alamofire.git",
        requirement: .exact("5.7.1")
    )

    static let PromiseKit = Package.remote(
        url: "https://github.com/mxcl/PromiseKit.git",
        requirement: .exact("8.0.0")
    )
}

public typealias Dependency = TargetDependency

public extension Dependency {
    enum MyPackage {}
}

public extension Dependency.MyPackage {
    static let Alamofire: Dependency = .package(product: "Alamofire")
    static let PromiseKit: Dependency = .package(product: "PromiseKit")
}

