import UIKit

import DesignSystem

import RxSwift
import RxCocoa

public final class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel
    
    private let disposeBag = DisposeBag()
    private let defaultAlarmSetBtn = PublishSubject<Void>()
    private let termsPrivacyBtnTap = PublishSubject<Void>()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.textColor = DesignSystemAsset.settingColor.color
        label.font
        = DesignSystemFontFamily.NanumSquareNeoOTF.extraBold.font(size: 25)
        return label
    }()
    private let basicAlarmSetting: SettingButton = {
        let view = SettingButton(
            iconName: "alarm",
            title: "알람 설정",
            rightTitle: "",
            isHiddenArrowRight: false
        )
        return view
    }()
    private lazy var developVersion: SettingButton = {
        let view = SettingButton(
            iconName: "exclamationmark.circle",
            title: "프로그램 정보",
            rightTitle: "v \(appVersion ?? "")",
            isHiddenArrowRight: true
        )
        return view
    }()
    private lazy var termsPrivacyBtn: SettingButton = {
        let view = SettingButton(
            iconName: "lock.shield",
            title: "이용약관 및 개인정보처리방침",
            rightTitle: "",
            isHiddenArrowRight: false
        )
        return view
    }()
    private let totalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 20
        return stack
    }()
    private var appVersion: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String
        else { return nil }
        return version
    }
    
    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureUI()
        bind()
    }
    
    private func configureUI() {
        [titleLabel, basicAlarmSetting,
         developVersion, termsPrivacyBtn]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview($0)
            }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 15
            ),
            basicAlarmSetting.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 40
            ),
            basicAlarmSetting.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 18
            ),
            basicAlarmSetting.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -20
            ),
            basicAlarmSetting.heightAnchor.constraint(
                equalToConstant: 30
            ),
            termsPrivacyBtn.topAnchor.constraint(
                equalTo: basicAlarmSetting.bottomAnchor,
                constant: 20
            ),
            termsPrivacyBtn.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 18
            ),
            termsPrivacyBtn.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -20
            ),
            termsPrivacyBtn.heightAnchor.constraint(
                equalToConstant: 30
            ),
            developVersion.topAnchor.constraint(
                equalTo: termsPrivacyBtn.bottomAnchor,
                constant: 20
            ),
            developVersion.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 18
            ),
            developVersion.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -20
            ),
            developVersion.heightAnchor.constraint(
                equalToConstant: 30
            ),
        ])
    }
    
    private func bind() {
        
        basicAlarmSetting.rx.tap
            .bind(to: defaultAlarmSetBtn)
            .disposed(by: disposeBag)
        
        termsPrivacyBtn.rx.tap
            .bind(to: termsPrivacyBtnTap)
            .disposed(by: disposeBag)
        
        _ = viewModel.transform(input: .init(
            defaultAlarmTapEvent: defaultAlarmSetBtn.asObservable(),
            termsTapEvent: termsPrivacyBtnTap.asObservable())
        )
    }
}
