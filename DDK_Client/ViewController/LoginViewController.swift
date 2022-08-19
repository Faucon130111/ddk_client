//
//  LoginViewController.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/08/12.
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
            .do(onNext: { _ in
                self.view.endEditing(true)
            })
            .map { self.nameTextField.text ?? "" }
            .map(Reactor.Action.enterButtonTap)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        let isConnect = reactor.state.map { $0.isConnected }
            .filterNil()
            .share()
        
        isConnect
            .filter { $0 == false }
            .map { _ in (
                title: "서버 접속 실패",
                message: "잠시 후 다시 시도해 주세요."
            )}
            .bind(to: self.rx.showAlert)
            .disposed(by: self.disposeBag)
        
        isConnect
            .filter { $0 == true }
            .map { _ in reactor.currentState.name }
            .map(SceneType.chatRoom)
            .bind(to: Coordinator.instance.rx.present)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .bind(to: self.rx.setActivityIndicator)
            .disposed(by: self.disposeBag)
    }
    
}
