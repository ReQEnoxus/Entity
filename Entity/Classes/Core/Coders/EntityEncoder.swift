//
//  EntityEncoder.swift
//  Entity
//
//  Created by Enoxus on 25.10.2020.
//

public protocol EntityEncoder {
    func encode(entity: Entity?) -> Data?
}

public struct BasicEntityEncoder: EntityEncoder {
    
    public init() {}
    
    public func encode(entity: Entity?) -> Data? {
        guard let entity = entity else { return nil }
        return try? JSONSerialization.data(withJSONObject: entity.fields, options: .prettyPrinted)
    }
}
