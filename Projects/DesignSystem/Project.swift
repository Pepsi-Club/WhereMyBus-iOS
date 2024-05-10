import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "DesignSystem",
    moduleType: .dynamicFramework,
    hasResource: true,
    packages: [
        .remote(
            url: "https://github.com/airbnb/lottie-ios",
            requirement: .exact("4.4.3")
        ),
    ],
    dependencies: [
        .package(product: "Lottie"),
    ],
    resourceSynthesizers: [
         .custom(
             name: "Lottie",
             parser: .json,
             extensions: ["lottie"]
         ),
     ]
)
