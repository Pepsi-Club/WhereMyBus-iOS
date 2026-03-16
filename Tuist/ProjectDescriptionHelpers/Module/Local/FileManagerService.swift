
public struct FileManagerService: FrameworkTarget {
    public let product: Product = .framework
    public let infoPlist: InfoPlist?
    public let dependencies: [TargetDependency]
    
    public init(
        @TargetComponentBuilder dependencies builder: () -> TargetComponentBuilder = {
            .init()
        }
    ) {
        let builder = builder()
        self.dependencies = builder.buildTargetDependency()
        self.infoPlist = builder.buildInfoPlist()
    }
}
