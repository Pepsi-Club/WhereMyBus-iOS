import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "NetworkService") {
    NetworkService {
        // TODO: Domain 의존성 제거, RxSwift를 의존하도록, Core / Data 의존성 필요 여부 체크
        Domain()
    }
}
