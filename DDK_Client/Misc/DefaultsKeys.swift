//
//  DefaultsKeys.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/09/02.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    var loginID: DefaultsKey<String?> {
        .init(
            "loginID",
            defaultValue: nil
        )
    }
    var loginPW: DefaultsKey<String?> {
        .init(
            "loginPW",
            defaultValue: nil
        )
    }
    var accessToken: DefaultsKey<String?> {
        .init(
            "accessToken",
            defaultValue: nil
        )
    }
    var refreshToken: DefaultsKey<String?> {
        .init(
            "refreshToken",
            defaultValue: nil
        )
    }
}
