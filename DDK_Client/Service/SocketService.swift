//
//  SocketService.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/08/12.
//

import Foundation

import RxCocoa
import RxSwift
import SocketIO

protocol SocketServiceSpec {
    init(url: URL)
    func connect() -> Observable<Bool>
    func disconnect()
    func sendChatData(
        _ chatData: ChatData,
        completion: (() -> ())?
    )
    func receiveChatData(handler: @escaping ((ChatData) -> Void))
}

class SocketService: SocketServiceSpec {

    private var manager: SocketManager!
    private var receiveChatDataHandler: ((ChatData) -> Void)?
    private var disposeBag = DisposeBag()
    private var statusObserver: PublishSubject<Bool> = .init()
    
    required init(url: URL) {
        self.manager = SocketManager(
            socketURL: url,
            config: [
                .log(true),
                .connectParams(["EIO": "3"]),
                .compress
            ]
        )
    }
    
    func connect() -> Observable<Bool> {
        .create { observer in
            self.addSocketHandlers()
            self.manager.reconnects = true
            self.manager.defaultSocket.connect(timeoutAfter: 3.0) {
                print("socket connect failed")
                self.manager.reconnects = false
                self.manager.defaultSocket.removeAllHandlers()
                self.statusObserver.onNext(false)
            }
            
            self.statusObserver
                .subscribe { event in
                    let isConnected = event.element ?? false
                    observer.onNext(isConnected)
                    observer.onCompleted()
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func disconnect() {
        self.manager.defaultSocket.disconnect()
    }
    
    func sendChatData(
        _ chatData: ChatData,
        completion: (() -> ())? = nil
    ) {
        self.manager.defaultSocket.emit(
            "chat-msg",
            chatData.jsonString(),
            completion: completion
        )
    }
    
    func receiveChatData(handler: @escaping ((ChatData) -> Void)) {
        self.receiveChatDataHandler = handler
    }
    
    private func addSocketHandlers() {
        self.manager.defaultSocket.on(clientEvent: .connect) { data, ack in
            print("socket connected")
        }
        self.manager.defaultSocket.on(clientEvent: .error) { data, ack in
            print("error: \(data)")
        }
        self.manager.defaultSocket.on(clientEvent: .statusChange) { data, ack in
            print("status change: \(data)")
            if let status = data[0] as? SocketIOStatus {
                if status == .connected {
                    self.statusObserver.onNext(true)
                }
            }
        }
        self.manager.defaultSocket.on("chat-msg") { [weak self] data, ack in
            let jsonString = (data[0] as? String) ?? ""
            guard let jsonData = jsonString.data(using: .utf8),
                  let chatData = try? JSONDecoder().decode(
                    ChatData.self,
                    from: jsonData
                  )
            else {
                return
            }
            self?.receiveChatDataHandler?(chatData)
        }
    }
    
}