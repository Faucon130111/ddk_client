//
//  ChatRoomViewControllerSpec.swift
//  DDK_ClientTests
//
//  Created by iOS Developer on 2022/08/25.
//

import Quick
import Nimble

@testable import DDK_Client

class ChatRoomViewControllerSpec: QuickSpec {
    
    override func spec() {
        var viewController: ChatRoomViewController!
        beforeEach {
            viewController = DIContainer.instance.container.resolve(
                ChatRoomViewController.self,
                arguments: "tester", true
            )
        }
        
        describe("채팅방 화면이 생성되면") {
            beforeEach {
                let _ = viewController.view
            }
            
            it("채팅 화면은 비어있다.") {
                expect(viewController.textView.text).to(beEmpty())
            }
            
            it("채팅 입력 칸은 비어있다.") {
                expect(viewController.textField.text).to(beEmpty())
            }
            
            it("보내기 버튼은 비활성화 상태다.") {
                expect(viewController.sendButton.isEnabled).to(beFalse())
            }
        }
        
        describe("채팅방 화면이 보여진 뒤") {
            beforeEach {
                viewController.beginAppearanceTransition(
                    true,
                    animated: false
                )
                viewController.endAppearanceTransition()
                
                viewController.textField.text = "hello world"
                viewController.textField.sendActions(for: .valueChanged)
            }
            
            context("채팅을 입력하면") {
                it("보내기 버튼은 활성화 상태다.") {
                    expect(viewController.sendButton.isEnabled).to(beTrue())
                }
            }
            
            context("채팅을 입력한 뒤 보내기 버튼을 누르면") {
                beforeEach {
                    viewController.sendButton.sendActions(for: .touchUpInside)
                }
                
                it("sendButtonTap 액션이 실행된다.") {
                    expect(viewController.reactor?.stub.actions.last).to(equal(.sendButtonTap("hello world")))
                }
            }
        }
        
        describe("채팅방 화면에서") {
            var mockSocketService: MockSocketService!
            var chatroomViewReactor: ChatRoomViewReactor!
            var chatRoomViewController: ChatRoomViewController!
            let expectChatData = ChatData(
                name: "tester",
                message: "hello world"
            )
            
            beforeEach {
                mockSocketService = MockSocketService(
                    url: URL(string: "http://localhost:3000")!,
                    isConnected: true
                )
                chatroomViewReactor = ChatRoomViewReactor(
                    name: "tester",
                    socketService: mockSocketService
                )
                chatRoomViewController = UIViewController.instantiate(of: ChatRoomViewController.self)
                chatRoomViewController.reactor = chatroomViewReactor
                
                let window = UIWindow(frame: UIScreen.main.bounds)
                window.makeKeyAndVisible()
                window.rootViewController = chatRoomViewController
                let _ = chatRoomViewController.view
            }
            
            context("채팅을 입력하고 보내기 버튼을 누르면") {
                var receivedChatData: ChatData?
                
                beforeEach {
                    mockSocketService.receiveChatData { chatData in
                        receivedChatData = chatData
                    }
                    chatroomViewReactor.action.onNext(.sendButtonTap("hello world"))
                }
                
                it("데이터를 정상적으로 생성하여 보낸다.") {
                    expect(mockSocketService.sendedChatData).to(equal(expectChatData))
                }
                
                it("보낸 데이터를 그대로 받아온다.") {
                    expect(receivedChatData).toEventually(
                        equal(expectChatData),
                        timeout: .seconds(3)
                    )
                }
            }
            
            context("채팅을 입력하고 보내기 버튼을 누르면") {
                beforeEach {
                    chatroomViewReactor.action.onNext(.sendButtonTap("hello world"))
                }
                
                it("소켓으로 부터 받아온 채팅 데이터를 표시한다.") {
                    expect(chatRoomViewController.textView.text).toEventually(
                        contain("\(expectChatData.name) : \(expectChatData.message)"),
                        timeout: .seconds(3)
                    )
                }
            }
            
        }
        
    }
    
}
