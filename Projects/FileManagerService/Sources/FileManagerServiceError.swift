import Foundation

public enum FileManagerServiceError: Error {
    /// 알 수 없는 에러
    case unknown
    /// 디렉토리 생성 실패
    case directoryCreationFailed(Error)
    /// 파일 저장 실패
    case saveFailed(Error)
    /// 파일을 찾을 수 없음
    case fileNotFound
    /// 파일 불러오기 실패
    case fetchFailed(Error)
    /// 파일 삭제 실패
    case deleteFailed(Error)
    /// 파일 다운로드 실패
    case downloadFailed(Error)
}
