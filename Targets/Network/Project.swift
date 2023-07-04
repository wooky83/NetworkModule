import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "Network",
                      organizationName: "com.wooky",
                      options: .options(automaticSchemesOptions: .disabled),
                      packages: [],
                      settings: .none,
                      targets: [
                        Project.target(
                            name: "Network",
                            product: .app,
                            infoPlist: .extendingDefault(with: [
                                "CFBundleShortVersionString": "1.0",
                                "CFBundleVersion": "1",
                            ]),
                            sources: "Sources/**",
                            resources: "Resources/**",
                            dependencies: [
                                .project(target: "NetworkAlamofire", path: .relativeToRoot("Targets/NetworkAlamofire")),
                                .project(target: "NetworkURLSession", path: .relativeToRoot("Targets/NetworkURLSession")),
                            ]
                        ),
                        Project.target(
                            name: "NetworkTests",
                            product: .unitTests,
                            sources: "Tests/**",
                            dependencies: [.target(name: "Network")]
                        ),
                      ],
                      schemes: [
                        .init(
                            name: "Network-Dev",
                            buildAction: .buildAction(
                                targets: ["Network"]
                            )
                        ),
                      ],
                      additionalFiles: []
)
