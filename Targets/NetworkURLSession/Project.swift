import ProjectDescription
import ProjectDescriptionHelpers


let project = Project(name: "NetworkURLSession",
                      organizationName: "com.wooky",
                      options: .options(automaticSchemesOptions: .disabled),
                      packages: [],
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
                            sources: "Tests/**",
                            dependencies: [.target(name: "NetworkURLSession")]
                        ),
                      ],
                      schemes: []
                )
