//
//  TextFieldGroup.swift
//  DDK_Client
//
//  Created by 박본혁 on 2022/10/07.
//

import UIKit

import RxCocoa
import RxSwift

class TextFieldGroup {
    
    private let disposeBag = DisposeBag()
    
    init(
        _ textFields: [UITextField],
        returnKeyTap: ((Int, UITextField) -> Void)? = nil
    ) {       
        for (index, textField) in textFields.enumerated() {
            textField.tag = index
            
            textField.rx.controlEvent(.editingDidEndOnExit)
                .subscribe(onNext: {
                    let nextIndex = textField.tag + 1
                    if nextIndex == textFields.count {
                        textField.resignFirstResponder()
                    } else {
                        textFields[nextIndex].becomeFirstResponder()
                    }
                    returnKeyTap?(
                        index,
                        textField
                    )
                })
                .disposed(by: self.disposeBag)
        }
    }
    
}
