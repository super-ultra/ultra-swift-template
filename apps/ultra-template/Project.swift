import ProjectDescription

let project = Project(
    name: "UltraTemplate",
    targets: [
        .target(
            name: "UltraTemplate",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.organization.UltraTemplate",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "UltraTemplate/Sources",
                "UltraTemplate/Resources",
            ],
            dependencies: [
                .external(name: "UltraTemplateAssets"),
                .external(name: "UltraTemplateCore")
            ]
        ),
        .target(
            name: "UltraTemplateTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.organization.UltraTemplateTests",
            infoPlist: .default,
            buildableFolders: [
                "UltraTemplate/Tests"
            ],
            dependencies: [.target(name: "UltraTemplate")]
        ),
    ]
)
