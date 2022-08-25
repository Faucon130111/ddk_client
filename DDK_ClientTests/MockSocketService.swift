//
//  MockSocketService.swift
//  DDK_ClientTests
//
//  Created by iOS Developer on 2022/08/24.
//

import Foundation

import RxCocoa
import RxSwift
@testable import DDK_Client

class MockSocketService: SocketServiceSpec {
    
    var url: URL!
    var isConnected: Bool = false
    var sendedChatData: ChatData?
    
    private var receiveChatDataHandler: ((ChatData) -> Void)?
    
    required init(url: URL) {
        self.url = url
    }
    
    init(
        url: URL,
        isConnected: Bool
    ) {
        self.url = url
        self.isConnected = isConnected
    }
    
    func connect() -> Observable<Bool> {
        return .create { observer in
            observer.onNext(self.isConnected)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func disconnect() {
        self.isConnected = false
    }
    
    func sendChatData(_ chatData: ChatData, completion: (() -> ())?) {
        self.sendedChatData = chatData
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.receiveChatDataHandler?(chatData)
        }
    }
    
    func receiveChatData(handler: @escaping ((ChatData) -> Void)) {
        self.receiveChatDataHandler = handler
    }
    
    
}
