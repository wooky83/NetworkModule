import ProjectDescription
import ProjectDescriptionHelpers


let project = Project(name: "NetworkURLSession",
                      organizationName: "com.wooky",
                      options: .options(automaticSchemesOptions: .disabled),
                      packages: [
                        .Swifter
                      ],
                      settings: .none,
                      targets: [
                        Project.target(
                            name: "NetworkURLSession",
                            product: .staticFramework,
                            sources: "Sources/**",
                            resources: [],
                            dependencies: []
                        ),
                        Project.target(
                            name: "NetworkURLSessionTests",
                            product: .unitTests,
                            sources: [
                                "Tests/**",
                                "../TestHelper/**"
                            ],
                            dependencies: [
                                .target(name: "NetworkURLSession"),
                                Dependency.MyPackage.Swifter,
                            ]
                        ),
                      ],
                      schemes: []
                )
