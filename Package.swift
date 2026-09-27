// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "OnyxKodeSecurityLab",
    products: [.library(name: "OnyxKodeSecurityLab", targets: ["OnyxKodeSecurityLab"])],
    targets: [
        .target(name: "OnyxKodeSecurityLab"),
        .testTarget(name: "OnyxKodeSecurityLabTests", dependencies: ["OnyxKodeSecurityLab"])
    ]
)