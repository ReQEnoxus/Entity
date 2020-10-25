//
//  TypeBuilder.swift
//  Entity
//
//  Created by Enoxus on 25.10.2020.
//

public protocol TypeBuilder {
    func field(of type: BasicType, named: String) -> TypeBuilder
    func register()
}

public class BasicTypeBuilder: TypeBuilder {
    
    private let name: String
    private let manager: TypeManager
    private var fields: [String: BasicType] = [:]
    
    init(name: String, manager: TypeManager) {
        self.name = name
        self.manager = manager
    }
    
    public func field(of type: BasicType, named: String) -> TypeBuilder {
        fields[named] = type
        return self
    }
    
    public func register() {
        let type = Type(name: name, attributes: fields)
        manager.register(type: type)
    }
}
