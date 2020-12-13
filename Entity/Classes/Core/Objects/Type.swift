//
//  Type.swift
//  Entity
//
//  Created by Enoxus on 25.10.2020.
//

public struct Type: Codable {
    public let name: String
    public let attributes: [String: BasicType]
    
    public init(name: String, attributes: [String : BasicType]) {
        self.name = name
        self.attributes = attributes
    }
}
