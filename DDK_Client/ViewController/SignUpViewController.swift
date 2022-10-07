//
//  SignUpViewController.swift
//  DDK_Client
//
//  Created by 박본혁 on 2022/10/05.
//

import UIKit

import ReactorKit
import RxCocoa
import RxOptional
import RxSwift
import SnapKit

class SignUpViewController:
    UIViewController,
    View {
    
    typealias Reactor = SignUpViewReactor
    var disposeBag: DisposeBag = DisposeBag()
    
    private var signUpView: SignUpView!
    
    init(
        view signUpview: SignUpView,
        reactor: SignUpViewReactor
    ) {
        super.init(
            nibName: nil,
            bundle: nil
        )
        
        self.signUpView = signUpview
        self.reactor = reactor
        
        self.view.addSubview(signUpview)
        signUpview.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: SignUpViewReactor) {
        self.signUpView.rx.id
            .filterEmpty()
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map(Reactor.Action.idValueChanged)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
            
        Observable<String>.combineLatest([
            self.signUpView.rx.pw,
            self.signUpView.rx.pwConfirm
        ])
        .filterEmpty()
        .distinctUntilChanged()
        .map { args in
            Reactor.Action.pwValueChanged(
                args.first ?? "",
                args.last ?? ""
            )
        }
        .bind(to: reactor.action)
        .disposed(by: self.disposeBag)
        
        self.signUpView.rx.name
            .distinctUntilChanged()
            .map(Reactor.Action.nameValueChanged)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.signUpView.rx.signUpButtonTap
            .map { _ in Reactor.Action.signUpButtonTap }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { ($0.isDuplicateIdLabelText, $0.isDuplicateIdLabelTextColor) }
            .bind(to: self.signUpView.rx.isDuplicateIdLabelText)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isDuplicateIdCheckLoading }
            .distinctUntilChanged()
            .bind(to: self.signUpView.rx.setDuplicateIdCheckLoading)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isPWConfirmEqual }
            .bind(to: self.signUpView.rx.isPWConfirmNotEqualLabelHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isSignUpButtonEnabled }
            .bind(to: self.signUpView.rx.isSignUpButtonEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$isSignUpSuccess)
            .compactMap { $0 }
            .map { isSuccess in
                let title = "회원 가입"
                let message = isSuccess ? "성공" : "실패"
                let handler = isSuccess ? ((UIAlertAction) -> Void)? { _ in
                    self.dismiss(animated: true)
                }
                : nil
                return (
                    title,
                    message,
                    handler
                )
            }
            .bind(to: self.rx.showAlert)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.rx.setActivityIndicator)
            .disposed(by: self.disposeBag)
    }
    
}
