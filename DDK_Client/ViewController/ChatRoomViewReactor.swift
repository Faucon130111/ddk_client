//
//  ChatRoomViewReactor.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/08/16.
//

import ReactorKit
import RxSwift
import SocketIO

class ChatRoomViewReactor: Reactor {
    
    enum Action {
        case sendButtonTap(String)
        case outButtonTap
        case receiveChatData(ChatData)
    }
    
    enum Mutation {
        case receiveChatData(ChatData)
        case dismiss
    }
    
    struct State {
        var newChatData: ChatData?
        var dismiss: Bool = false
    }
    
    var initialState: State = State()
    private var name: String
    private var socketService: SocketServiceSpec
    var sendChatDataComplete: (() -> Void)?
    
    init(
        name: String,
        socketService: SocketServiceSpec
    ) {
        self.name = name
        self.socketService = socketService
        self.socketService.receiveChatData { chatData in
            self.action.onNext(.receiveChatData(chatData))
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .sendButtonTap(message):
            let chatData = ChatData(
                name: self.name,
                message: message
            )
            self.socketService.sendChatData(chatData) {
                self.sendChatDataComplete?()
            }
            return .empty()
            
        case .outButtonTap:
            self.socketService.disconnect()
            return .just(.dismiss)

        case let .receiveChatData(chatData):
            return .just(.receiveChatData(chatData))
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = State()
        
        switch mutation {
        case let .receiveChatData(chatData):
            newState.newChatData = chatData
            return newState
            
        case .dismiss:
            newState.dismiss = true
            return newState
            
        }
    }
    
}

extension ChatRoomViewReactor.Action: Equatable {
    
    static func == (
        lhs: ChatRoomViewReactor.Action,
        rhs: ChatRoomViewReactor.Action
    ) -> Bool {
        switch (lhs, rhs) {
        case (.sendButtonTap, .sendButtonTap),
            (.outButtonTap, .outButtonTap),
            (.receiveChatData, .receiveChatData):
            return true
            
        default:
            return false
            
        }
    }
    
}
