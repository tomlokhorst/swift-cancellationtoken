// swift-tools-version:5.1
import PackageDescription

let package = Package(
  name: "CancellationToken",
  platforms: [
    .macOS(.v10_12), .iOS(.v10), .tvOS(.v10), .watchOS(.v3)
  ],
  products: [
    .library(name: "CancellationToken", targets: ["CancellationToken"]),
  ],
  dependencies: [],
  targets: [
    .target(name: "CancellationToken"),
    .testTarget(name: "CancellationTokenTests", dependencies: ["CancellationToken"]),
  ],
  swiftLanguageVersions: [.v5]
)

