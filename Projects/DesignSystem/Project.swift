import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "DesignSystem",
    moduleType: .dynamicFramework,
    hasResource: true,
    dependencies: []
),
resourceSynthesizers: [
   .custom(name: "Lottie", parser: .json, extensions: ["lottie"]),
 ]
