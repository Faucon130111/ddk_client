//
//  LoginViewControllerSpec.swift
//  DDK_ClientTests
//
//  Created by iOS Developer on 2022/08/11.
//

import Quick
import Nimble

@testable import DDK_Client

class LoginViewControllerSpec: QuickSpec {
    
    override func spec() {
        var viewController: LoginViewController!
        beforeEach {
            viewController = DIContainer.instance.container.resolve(
                LoginViewController.self,
                argument: true
            )
        }
        
        describe("로그인 화면이 생성되면") {
            beforeEach {
                let _ = viewController.view
            }
            
            it("이름 입력 칸은 비어있다.") {
                expect(viewController.nameTextField.text).to(beEmpty())
            }
            
            it("입장하기 버튼은 비활성화 상태다.") {
                expect(viewController.enterButton.isEnabled).to(beFalse())
            }
        }
        
        describe("로그인 화면이 보여진 뒤") {
            beforeEach {
                viewController.beginAppearanceTransition(
                    true,
                    animated: false
                )
                viewController.endAppearanceTransition()
                
                viewController.nameTextField.text = "test name"
                viewController.nameTextField.sendActions(for: .valueChanged)
            }
            
            context("이름을 입력하면") {
                it("입장하기 버튼은 활성화 상태다.") {
                    expect(viewController.enterButton.isEnabled).to(beTrue())
                }
            }
            
            context("이름을 입력한 뒤 입장하기 버튼을 누르면") {
                beforeEach {
                    viewController.enterButton.sendActions(for: .touchUpInside)
                }
                
                it("enterButtonTap 액션이 실행된다.") {
                    expect(viewController.reactor?.stub.actions.last).to(equal(.enterButtonTap("test name")))
                }
            }
            
            context("Reactor.State.isLoading 값이 true 일 때") {
                beforeEach {
                    viewController.reactor?.stub.state.value = LoginViewReactor.State(
                        name: "",
                        isConnected: nil,
                        isLoading: true
                    )
                }
                
                it("로딩 중 애니메이션이 움직인다.") {
                    expect(viewController.isActivityIndicatorAnimating()).to(beTrue())
                }
            }
            
            context("Reactor.State.isLoading 값이 false 일 때") {
                beforeEach {
                    viewController.reactor?.stub.state.value = LoginViewReactor.State(
                        name: "",
                        isConnected: nil,
                        isLoading: false
                    )
                }
                
                it("로딩 중 애니메이션이 멈춘다.") {
                    expect(viewController.isActivityIndicatorAnimating()).to(beFalse())
                }
            }
        }
        
        describe("로그인 화면에서") {
            var mockSocketService: MockSocketService!
            var loginViewReactor: LoginViewReactor!
            var loginViewController: LoginViewController!
            
            beforeEach {
                mockSocketService = MockSocketService(url: URL(string: "http://localhost:3000")!)
                loginViewReactor = LoginViewReactor(socketService: mockSocketService)
                loginViewController = UIViewController.instantiate(of: LoginViewController.self)!
                loginViewController.reactor = loginViewReactor
                
                let coordinator = Coordinator.instance
                coordinator.setRootViewController(loginViewController)
                
                let window = UIWindow(frame: UIScreen.main.bounds)
                window.makeKeyAndVisible()
                window.rootViewController = loginViewController
                let _ = loginViewController.view
            }
            
            context("소켓 서버가 실행중이고 입장하기 버튼을 누르면") {
                beforeEach {
                    mockSocketService.isConnected = true
                    loginViewReactor.action.onNext(.enterButtonTap("tester"))
                }
                
                it("연결 상태가 된다.") {
                    expect(loginViewReactor.currentState.isConnected).to(beTrue())
                }
                
                it("채팅방으로 이동 된다.") {
                    expect(loginViewController.presentedViewController).toEventually(beAnInstanceOf(ChatRoomViewController.self))
                }
            }
            
            context("소켓 서버가 실행중이지 않고 입장하기 버튼을 누르면") {
                beforeEach {
                    mockSocketService.isConnected = false
                    loginViewReactor.action.onNext(.enterButtonTap("tester"))
                }
                
                it("연결 상태가 아니다.") {
                    expect(loginViewReactor.currentState.isConnected).to(beFalse())
                }
                
                it("연결 실패 Alert창이 표시된다.") {
                    expect(loginViewController.presentedViewController).toEventually(beAnInstanceOf(UIAlertController.self))
                }
            }
        }
        
    }

}
