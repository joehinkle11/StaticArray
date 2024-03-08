// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "StaticArray",
    products: [
        .library(
            name: "StaticArray",
            targets: ["StaticArray"]),
    ],
    targets: [
        .target(name: "StaticArray", dependencies: ["CStaticArray"]),
        .target(name: "CStaticArray"),
        .testTarget(
            name: "StaticArrayTests",
            dependencies: ["StaticArray"]),
    ]
)
