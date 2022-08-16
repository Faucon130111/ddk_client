//
//  LoginViewController.swift
//  DDK_Client
//
//  Created by Cresoty iOS Developer on 2022/08/12.
//

import UIKit

import ReactorKit
import RxCocoa
import RxOptional
import RxSwift

class LoginViewController: UIViewController, StoryboardView {
    
    typealias Reactor = LoginViewReactor
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.rx.text
            .filterNil()
            .map { $0.count > 0 }
            .bind(to: self.enterButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
    
    func bind(reactor: LoginViewReactor) {
        self.enterButton.rx.tap
            .map { Reactor.Action.enterButtonTap }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isConnected }
            .filterNil()
            .subscribe(onNext: { isConnected in
                if isConnected == false {
                    self.showAlert(
                        title: "서버 접속 실패",
                        message: "잠시 후 다시 시도해 주세요."
                    )
                    return
                }
                if let chatViewController = UIViewController.instantiate(of: ChatViewController.self) {
                    let chatViewReactor = reactor.makeChatViewReactor()
                    chatViewController.reactor = chatViewReactor
                    chatViewController.modalPresentationStyle = .fullScreen
                    self.present(chatViewController, animated: true)
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .bind(to: self.rx.setActivityIndicator)
            .disposed(by: self.disposeBag)
    }
    
    private func showAlert(
        title: String?,
        message: String?
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "확인",
            style: .default
        )
        alert.addAction(okAction)
        self.present(
            alert,
            animated: true
        )
    }
    
}
