import Foundation

import Domain
import FeatureDependency

import RxSwift

import MessageUI

public final class SettingsViewModel
: NSObject, ViewModel, MFMailComposeViewControllerDelegate {
    private let coordinator: SettingsCoordinator
    private let disposeBag = DisposeBag()
    
    public init(coordinator: SettingsCoordinator) {
        self.coordinator = coordinator
    }
    
    public func transform(input: Input) -> Output {
        let output = Output()
        
//        input.defaultAlarmTapEvent
//            .withUnretained(self)
//            .subscribe(onNext: { viewModel, _ in
//                // 뷰 이동
//                viewModel.coordinator.setDefaultAlarm()
//                print("알람설정 tap")
//            })
//            .disposed(by: disposeBag)
        
        input.termsTapEvent
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                print("개인정보 tap")
                guard let termsPrivacyURL
                        = Bundle.main.object(
                            forInfoDictionaryKey: "TERMS_OF_PRIVACY_URL"
                        ) as? String
                else { return }
                viewModel.coordinator.presentPrivacy(url: termsPrivacyURL)
            })
            .disposed(by: disposeBag)
        
        input.locationTapEvent
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                print("위치정보 탭")
                guard let locationURL = Bundle.main.object(
                    forInfoDictionaryKey: "LOCATION_PRIVACY_URL"
                ) as? String
                else { return }
                viewModel.coordinator.presentPrivacy(url: locationURL)
                
            })
            .disposed(by: disposeBag)
        
        input.inquryTapEvent
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                if MFMailComposeViewController.canSendMail() {
                    print("여기 ?")
                    let mailViewController = MFMailComposeViewController()
                    mailViewController.mailComposeDelegate = self
                    
                    let bodyString = 
                             """
                             이곳에 문의 내용을 작성해주세요.
                             ex) 버스 정류장 데이터 이상, 버스 데이터 이상 등
                             
                             ------------
                             
                             Device Model : \(String.getDeviceIdentifier())
                             Device OS : \(UIDevice.current.systemVersion)
                             App Version : \(String.getCurrentVersion())
                             
                             ------------
                             """
                    
                    mailViewController.setToRecipients(["modynic12@gmail.com"])
                    mailViewController.setSubject("[버스어디] 문의하기")
                    mailViewController.setMessageBody(bodyString, isHTML: false)
                    
                    viewModel.coordinator.presentMail(vc: mailViewController)
                } else {
                    print("여기 ?????")
                    guard let inquryURL = Bundle.main.object(
                        forInfoDictionaryKey: "INQURY_URL"
                    ) as? String
                    else { return }
                    viewModel.coordinator.presentPrivacy(url: inquryURL)
                }
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension SettingsViewModel {
    public struct Input {
//        let defaultAlarmTapEvent: Observable<Void>
        let termsTapEvent: Observable<Void>
        let locationTapEvent: Observable<Void>
        let inquryTapEvent: Observable<Void>
    }
    
    public struct Output {
    }
}
