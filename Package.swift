// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Segmenter",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "Segmenter",
            targets: ["Segmenter"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Segmenter",
            dependencies: []),
        .testTarget(
            name: "SegmenterTests",
            dependencies: ["Segmenter"]),
    ]
)
