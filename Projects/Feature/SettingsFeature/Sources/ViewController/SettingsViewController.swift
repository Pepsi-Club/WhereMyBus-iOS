import UIKit

import DesignSystem

import RxSwift
import RxCocoa

public final class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel
    
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.textColor = DesignSystemAsset.settingColor.color
        label.font
        = DesignSystemFontFamily.NanumSquareNeoOTF.extraBold.font(size: 25)
        return label
    }()
    
    private let buttonsView = SettingButtonView()
    
    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(
            true,
            animated: true
        )
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureUI()
        bind()
        // TODO: 서버 테스트용, 추후 함수와 호출 제거
        configureFCMTokenView()
    }
    
    private func configureUI() {
        [titleLabel, buttonsView]
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
            buttonsView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 40
            ),
            buttonsView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 18
            ),
            buttonsView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -20
            ),
            buttonsView.heightAnchor.constraint(
                equalToConstant: 250
            )
        ])
    }
    
    private func bind() {
        
        _ = viewModel.transform(
            input:
                .init(
//                    defaultAlarmTapEvent
//                    : buttonsView.basicAlarmSetting.rx.tap.asObservable(),
                    termsTapEvent
                    : buttonsView.termsPrivacyBtn.rx.tap.asObservable(),
                    locationTapEvent
                    : buttonsView.locationPrivacyBtn.rx.tap.asObservable()
                )
        )
    }
    
    private func configureFCMTokenView() {
        let label = UILabel()
        let copyBtn = UIButton()
        let textView = UITextView()
        label.text = "FCM 토큰"
        copyBtn.setImage(
            .init(systemName: "doc.on.doc")?
                .withConfiguration(
                    UIImage.SymbolConfiguration(
                        font: .systemFont(ofSize: 24)
                    )
                ),
            for: .normal
        )
        copyBtn.rx.tap
            .subscribe(
                onNext: { _ in
                    UIPasteboard.general.string = textView.text
                }
            )
            .disposed(by: disposeBag)
        textView.text = UserDefaults.standard.string(forKey: "fcmToken")
        textView.sizeToFit()
        textView.backgroundColor = .lightGray
        textView.isEditable = false
        [label, copyBtn, textView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            label.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 10
            ),
            copyBtn.topAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            copyBtn.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -10
            ),
            textView.topAnchor.constraint(equalTo: copyBtn.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            textView.trailingAnchor.constraint(
                equalTo: copyBtn.trailingAnchor
            ),
            textView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -10
            ),
        ])
    }
}
