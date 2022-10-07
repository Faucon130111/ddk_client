//
//  LoginView.swift
//  DDK_Client
//
//  Created by 박본혁 on 2022/09/27.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class LoginView: UIView {
    
    fileprivate let idTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "아이디"
        $0.returnKeyType = .next
    }
    
    fileprivate let pwTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "비밀번호"
        $0.isSecureTextEntry = true
        $0.returnKeyType = .continue
    }
    
    fileprivate let loginButton = UIButton().then {
        $0.setTitle(
            "로그인",
            for: .normal
        )
        $0.setTitleColor(
            .systemBlue,
            for: .normal
        )
        $0.setTitleColor(
            .lightGray,
            for: .disabled
        )
        $0.isEnabled = false
    }
    
    fileprivate let signUpButton = UIButton().then {
        $0.setTitle(
            "회원가입",
            for: .normal
        )
        $0.setTitleColor(
            .systemBlue,
            for: .normal
        )
    }
    
    private var textFieldGroup: TextFieldGroup!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let textFields = [
            self.idTextField,
            self.pwTextField
        ]
        
        self.textFieldGroup = TextFieldGroup(textFields) { _, textField in
            if textField == self.pwTextField,
               self.loginButton.isEnabled {
                self.loginButton.sendActions(for: .touchUpInside)
            }
        }
        
        let textFieldStackView = UIStackView(arrangedSubviews:textFields).then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 16.0
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [
            self.loginButton,
            self.signUpButton
        ]).then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 8.0
        }
        
        let contentsStackView = UIStackView(arrangedSubviews: [
            textFieldStackView,
            buttonStackView
        ]).then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 32.0
        }
        
        self.addSubview(contentsStackView)
        contentsStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
}

extension Reactive where Base: LoginView {
    
    var id: Observable<String> {
        return base.idTextField.rx.text.compactMap { $0 }
    }
    
    var pw: Observable<String> {
        return base.pwTextField.rx.text.compactMap { $0 }
    }
    
    var loginButtonIsEnabled: Binder<Bool> {
        return Binder(base) { loginView, isEnalbed in
            loginView.loginButton.isEnabled = isEnalbed
        }
    }
    
    var loginButtonTap: ControlEvent<[String]> {
        let source = base.loginButton.rx.tap
            .map {[
                base.idTextField.text ?? "",
                base.pwTextField.text ?? ""
            ]}
        return ControlEvent(events: source)
    }
    
    var signUpButtonTap: ControlEvent<Void> {
        let source = base.signUpButton.rx.tap
        return ControlEvent(events: source)
    }
    
}
