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
    dependencies: [.package(name: "RecipesUtility",
                            path: "../Utility/RecipesUtility"),
                   .package(name: "APIClient",
                            path: "../Networking/APIClient")],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RecipesRepository",
            dependencies: ["RecipesUtility",
                           "APIClient"]),
        .testTarget(
            name: "RecipesRepositoryTests",
            dependencies: ["RecipesRepository"]
        ),
    ]
)
