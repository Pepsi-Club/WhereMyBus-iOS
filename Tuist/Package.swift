// swift-tools-version:5.0
//
//  Package.swift
//  WhereMyBus-iOSManifests
//
//  Created by Logan on 3/30/25.
//


@preconcurrency import PackageDescription

#if TUIST
import EnvironmentPlugin
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    productTypes: [
        "RxSwift": .framework,
        "RxCocoa": .framework,
        "RxCocoaRuntime": .framework,
        "Lottie": .framework,
    ],
    targetSettings: [:]
)

#endif

let package = Package(
    name: "Packages",
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .exactItem("6.8.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .exactItem("11.4.0")),
        .package(url: "https://github.com/airbnb/lottie-ios", .exactItem("4.4.3")),
    ]
)
