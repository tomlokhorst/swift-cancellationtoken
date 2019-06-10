// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "CancellationToken",
  products: [
    .library(name: "CancellationToken", targets: ["CancellationToken"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(name: "CancellationToken"),
    .testTarget(name: "CancellationTokenTests", dependencies: ["CancellationToken"]),
  ]
)

