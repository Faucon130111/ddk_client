//
//  IsDuplicateIDResponseModel.swift
//  DDK_Client
//
//  Created by 박본혁 on 2022/10/07.
//

struct IsDuplicateIDResponseModel: Codable {
    
    var isDuplicateId: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.isDuplicateId = try container.decode(
            Bool.self,
            forKey: .isDuplicateId
        )
    }
    
}
