// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

//let _ = Package

let package = Package(
    name: "TCACalc_UI",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TCACalc_UI",
            targets: ["TCACalc_UI"]),
    ],
    dependencies: [
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.1.0"),
      .package(url: "https://github.com/tgrapperon/swift-dependencies-additions", from: "1.0.0"),
      .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.13.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TCACalc_UI",
            dependencies: [
              .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
              .product(name: "DependenciesAdditions", package: "swift-dependencies-additions")
            ]
        ),
        .testTarget(
            name: "TCACalc_UITests",
            dependencies: [
              "TCACalc_UI",
              .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
              .product(name: "InlineSnapshotTesting", package: "swift-snapshot-testing")
            ]),
    ]
)

