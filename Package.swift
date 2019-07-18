// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Valy",
    products: [
        .library(name: "Valy", targets: ["Valy"])
    ],
    targets: [
        .target(
            name: "Valy",
            path: "Sources",
            exclude: []
        )
    ]
)
