//
//  ChatViewController.swift
//  DDK_Client
//
//  Created by Cresoty iOS Developer on 2022/08/11.
//

import UIKit

import ReactorKit
import RxCocoa
import RxKeyboard
import RxOptional
import RxSwift
import SnapKit

class ChatViewController: UIViewController, StoryboardView {

    typealias Reactor = ChatViewReactor
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.rx.text
            .filterNil()
            .map { $0.count > 0 }
            .bind(to: self.sendButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { keyboardHeight in
                var height: CGFloat = 0.0
                if keyboardHeight > 0.0 {
                    height = -keyboardHeight + self.view.safeAreaInsets.bottom - 8.0
                }
                self.textField.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(height)
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bind(reactor: ChatViewReactor) {
        self.sendButton.rx.tap
            .map { self.textField.text }
            .filterNil()
            .filterEmpty()
            .map { Reactor.Action.sendButtonTap($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.newMessage }
            .filterEmpty()
            .map { newMessage in
                var text = self.textView.text ?? ""
                text += "\n\(newMessage)"
                return text
            }
            .bind(to: self.textView.rx.text)
            .disposed(by: self.disposeBag)
    }
    
}

