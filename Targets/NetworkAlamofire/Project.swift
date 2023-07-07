import ProjectDescription
import ProjectDescriptionHelpers


let project = Project(name: "NetworkAlamofire",
                      organizationName: "com.wooky",
                      options: .options(automaticSchemesOptions: .disabled),
                      packages: [
                        .Alamofire,
                        .PromiseKit,
                        .Swifter,
                      ],
                      settings: .none,
                      targets: [
                        Project.target(
                            name: "NetworkAlamofire",
                            product: .staticFramework,
                            sources: "Sources/**",
                            resources: [],
                            dependencies: [
                                Dependency.MyPackage.Alamofire,
                                Dependency.MyPackage.PromiseKit,
                            ]
                        ),
                        Project.target(
                            name: "NetworkAlamofireTests",
                            product: .unitTests,
                            sources: [
                                "Tests/**",
                                "../TestHelper/**"
                            ],
                            dependencies: [
                                .target(name: "NetworkAlamofire"),
                                Dependency.MyPackage.Swifter,
                            ]
                        ),
                      ],
                      schemes: []
                )
