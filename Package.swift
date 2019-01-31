// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShopifyAPI",
    products: [
        .library(name: "Shopify", targets: ["Shopify"]),
		.library(name: "Shopify-Vapor", targets: ["Shopify-Vapor"]),
    ],
    dependencies: [
		.package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "Shopify", dependencies: []),
        .testTarget(name: "Tests", dependencies: ["Shopify"]),
		.target(name: "Shopify-Vapor", dependencies: ["Vapor", "Shopify"]),
		.testTarget(name: "Vapor-Tests", dependencies: ["Shopify-Vapor"]),
    ]
)
