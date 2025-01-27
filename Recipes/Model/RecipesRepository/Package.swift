// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RecipesRepository",
    platforms: [.iOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RecipesRepository",
            targets: ["RecipesRepository"]),
    ],
    dependencies: [.package(name: "APIClient",
                            path: "../Service/APIClient")],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SharedResources",
            resources: [.process("RecipesResponseAllRecipes.json")]
        ),
        .target(
            name: "RecipesRepository",
            dependencies: ["APIClient",
                           "SharedResources"]
        ),
        .testTarget(
            name: "RecipesRepositoryTests",
            dependencies: ["RecipesRepository",
                           "SharedResources"]
        ),
    ]
)
