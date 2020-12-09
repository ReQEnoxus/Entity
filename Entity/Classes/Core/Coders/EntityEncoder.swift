//
//  EntityEncoder.swift
//  Entity
//
//  Created by Enoxus on 25.10.2020.
//

public protocol EntityEncoder {
    func encode(entity: Entity?) -> Data?
    func encode(entities: [Entity]) -> Data?
}

public struct BasicEntityEncoder: EntityEncoder {
    
    public init() {}
    
    public func encode(entity: Entity?) -> Data? {
        guard let entity = entity else { return nil }
        return try? JSONSerialization.data(withJSONObject: entity.fields, options: .prettyPrinted)
    }
    
    public func encode(entities: [Entity]) -> Data? {
        var arrayToEncode = [[String: Any]]()
        entities.forEach { arrayToEncode.append($0.fields) }
        
        return try? JSONSerialization.data(withJSONObject: arrayToEncode, options: .prettyPrinted)
    }
}
