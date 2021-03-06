// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "qbio",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(
            name: "qbio",
            targets: ["qbio"]),
        .library(
            name: "qbio-lib",
            targets: ["qbio-lib"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "qbio",
            dependencies: ["qbio-lib", .product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .target(
            name: "qbio-lib",
            dependencies: []),
        .testTarget(
            name: "qbio-libTests",
            dependencies: ["qbio-lib"]),
    ]
)
