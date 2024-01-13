//
//  BaseViewController.swift
//  FeatureDependency
//
//  Created by gnksbm on 2023/12/30.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import UIKit

import RxSwift

open class BaseViewController: UIViewController {
    public let disposeBag = DisposeBag()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        view.backgroundColor = .white
    }
}
