//
//  TypeManager.swift
//  Entity
//
//  Created by Enoxus on 25.10.2020.
//

import Foundation

public protocol TypeManager: AnyObject {
    func new(named: String) -> TypeBuilder
    func type(named: String) -> Type?
    func register(type: Type)
    
    var availableTypes: [Type] { get }
}

public class BasicTypeManager: Codable, TypeManager {
    
    public init() {}
    
    private var registeredTypes: [String: Type] = [:]
    
    public var availableTypes: [Type] {
        return Array(registeredTypes.values)
    }
    
    public func new(named: String) -> TypeBuilder {
        return BasicTypeBuilder(name: named, manager: self)
    }
    
    public func type(named: String) -> Type? {
        return registeredTypes[named]
    }
    
    public func register(type: Type) {
        // type availability check
        for (_, basicType) in type.attributes {
            recursiveAvailabilityCheck(basicType)
        }
        registeredTypes[type.name] = type
    }
    
    private func recursiveAvailabilityCheck(_ basic: BasicType) {
        switch basic {
        case let .custom(name):
            guard registeredTypes[name] != nil else { fatalError("attempt to register a type with unknown subtype: \(name)") }
        case let .array(nestedType):
            recursiveAvailabilityCheck(nestedType)
        default:
            return
        }
    }
}
