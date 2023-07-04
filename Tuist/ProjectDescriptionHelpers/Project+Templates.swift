import ProjectDescription

///// Project helpers are functions that simplify the way you define your project.
///// Share code to create targets, settings, dependencies,
///// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
///// See https://docs.tuist.io/guides/helpers/
/////

public enum Constants {
    public static let platform: Platform = .iOS
    public static let minimumDeploymentTarget: DeploymentTarget = .iOS(targetVersion: "15.0", devices: .iphone)
}

extension Project {
    public static func target(
        name: String,
        product: Product,
        infoPlist: InfoPlist = .default,
        sources: SourceFilesList,
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency] = [],
        scripts: [TargetScript] = [],
        baseSettings: ProjectDescription.SettingsDictionary = [:],
        coreDataModels: [CoreDataModel] = []
    ) -> Target {
        Target(
            name: name,
            platform: Constants.platform,
            product: product,
            bundleId: "com.wooky.\(name.lowercased())",
            deploymentTarget: Constants.minimumDeploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            scripts: scripts,
            dependencies: dependencies,
            settings: .settings(
                base: ["OTHER_LDFFLAGS": "$(inherited)"].merging(baseSettings) { $1 },
                configurations: [],
                defaultSettings: .recommended(excluding: [
                    "TARGETED_DEVICE_FAMILY",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS",
                ])
            ),
            coreDataModels: coreDataModels)
    }
}
