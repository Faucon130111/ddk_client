//
//  LoginViewController.swift
//  DDK_Client
//
//  Created by 박본혁 on 2022/09/27.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

class LoginViewController:
    UIViewController,
    View {
    
    typealias Reactor = LoginViewReactor
    var disposeBag: DisposeBag = DisposeBag()
    
    private var loginView: LoginView!
    
    init(
        view loginView: LoginView,
        reactor: LoginViewReactor
    ) {
        super.init(
            nibName: nil,
            bundle: nil
        )
        
        self.loginView = loginView
        self.reactor = reactor
        
        self.view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: LoginViewReactor) {
        Observable<String>.combineLatest([
            self.loginView.rx.id,
            self.loginView.rx.pw
        ])
        .map { strings -> Bool in
            let id = strings.first ?? ""
            let pw = strings.last ?? ""
            return id.count > 0 && pw.count > 0
        }
        .bind(to: self.loginView.rx.loginButtonIsEnabled)
        .disposed(by: self.disposeBag)
        
        self.loginView.rx.loginButtonTap
            .map(Reactor.Action.loginButtonTap)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.loginView.rx.signUpButtonTap
            .map { _ in SceneType.signUp }
            .bind(to: Coordinator.instance.rx.present)
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$isLoginComplete)
            .subscribe(onNext: { isLoginComplete in
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.rx.setActivityIndicator)
            .disposed(by: self.disposeBag)
    }
    
}
