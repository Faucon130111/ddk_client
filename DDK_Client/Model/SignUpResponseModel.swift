//
//  SignUpResponseModel.swift
//  DDK_Client
//
//  Created by 박본혁 on 2022/10/06.
//

struct SignUpResponseModel: Codable {
    
    var isSignUpSuccess: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isSignUpSuccess = try container.decode(
            Bool.self,
            forKey: .isSignUpSuccess
        )
    }
    
}
