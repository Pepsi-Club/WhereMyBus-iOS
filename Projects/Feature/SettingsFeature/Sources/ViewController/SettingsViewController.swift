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
    private let buttonsView = SettingButtonView()
    
    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureUI()
        bind()
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
        buttonsView.basicAlarmSetting.rx.tap
            .bind(to: defaultAlarmSetBtn)
            .disposed(by: disposeBag)
        
        buttonsView.termsPrivacyBtn.rx.tap
            .bind(to: termsPrivacyBtnTap)
            .disposed(by: disposeBag)
        
        _ = viewModel.transform(input: .init(
            defaultAlarmTapEvent: defaultAlarmSetBtn.asObservable(),
            termsTapEvent: termsPrivacyBtnTap.asObservable())
        )
    }
}
