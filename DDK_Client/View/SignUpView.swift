//
//  SignUpView.swift
//  DDK_Client
//
//  Created by 박본혁 on 2022/10/05.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class SignUpView: UIView {
    
    fileprivate let idTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "아이디"
        $0.returnKeyType = .next
    }
    
    fileprivate let idActivityIndcator = UIActivityIndicatorView().then {
        $0.stopAnimating()
    }
    
    fileprivate let isDuplicateIdLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11.0)
        $0.isHidden = true
    }
    
    fileprivate let pwTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "비밀번호"
        $0.isSecureTextEntry = true
        $0.returnKeyType = .next
    }
    
    fileprivate let pwConfirmTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "비밀번호 확인"
        $0.isSecureTextEntry = true
        $0.returnKeyType = .next
    }
    
    fileprivate let isPWConfirmNotEqualLabel = UILabel().then {
        $0.text = "* 비밀번호가 일치하지 않습니다."
        $0.textColor = .systemRed.withAlphaComponent(0.7)
        $0.font = .systemFont(ofSize: 11.0)
        $0.isHidden = true
    }
    
    fileprivate let nameTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "이름"
        $0.returnKeyType = .join
    }
    
    fileprivate let signUpButton = UIButton().then {
        $0.setTitle(
            "가입하기",
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
            self.pwTextField,
            self.pwConfirmTextField,
            self.nameTextField
        ]
        
        self.textFieldGroup = TextFieldGroup(textFields) { _, textField in
            if textField == self.nameTextField,
               self.signUpButton.isEnabled {
                self.signUpButton.sendActions(for: .touchUpInside)
            }
        }
        
        self.backgroundColor = .white
        
        self.idTextField.rightView = self.idActivityIndcator
        self.idTextField.rightViewMode = .never
        
        let idStackView = UIStackView(arrangedSubviews: [
            self.idTextField,
            self.isDuplicateIdLabel
        ]).then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 8.0
        }
        
        let pwConfirmStackView = UIStackView(arrangedSubviews: [
            self.pwConfirmTextField,
            self.isPWConfirmNotEqualLabel
        ]).then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 8.0
        }
        
        let textFieldStackView = UIStackView(arrangedSubviews: [
            idStackView,
            self.pwTextField,
            pwConfirmStackView,
            self.nameTextField
        ]).then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 16.0
        }
        
        let contentsStackView = UIStackView(arrangedSubviews: [
            textFieldStackView,
            self.signUpButton
        ]).then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 32.0
        }
        
        self.addSubview(contentsStackView)
        contentsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40.0)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
}

extension Reactive where Base: SignUpView {
    
    var id: Observable<String> {
        return base.idTextField.rx.text.compactMap { $0 }
    }
    
    var setDuplicateIdCheckLoading: Binder<Bool> {
        return Binder(base) { signUpView, isLoading in
            if isLoading {
                signUpView.idActivityIndcator.startAnimating()
                signUpView.idTextField.rightViewMode = .always
            } else {
                signUpView.idActivityIndcator.stopAnimating()
                signUpView.idTextField.rightViewMode = .never
            }
        }
    }
    
    var isDuplicateIdLabelText: Binder<(String, UIColor)> {
        return Binder(base) { signUpView, args in
            signUpView.isDuplicateIdLabel.isHidden = false
            signUpView.isDuplicateIdLabel.text = args.0
            signUpView.isDuplicateIdLabel.textColor = args.1
        }
    }
    
    var pw: Observable<String> {
        return base.pwTextField.rx.text.compactMap { $0 }
    }
    
    var pwConfirm: Observable<String> {
        return base.pwConfirmTextField.rx.text.compactMap { $0 }
    }
    
    var isPWConfirmNotEqualLabelHidden: Binder<Bool> {
        return Binder(base) { signUpView, isHidden in
            signUpView.isPWConfirmNotEqualLabel.isHidden = isHidden
        }
    }
    
    var name: Observable<String> {
        return base.nameTextField.rx.text.compactMap { $0 }
    }
    
    var isSignUpButtonEnabled: Binder<Bool> {
        return Binder(base) { signUpView, isEnabled in
            signUpView.signUpButton.isEnabled = isEnabled
        }
    }
    
    var signUpButtonTap: ControlEvent<Void> {
        let source = base.signUpButton.rx.tap
        return ControlEvent(events: source)
    }
    
}
