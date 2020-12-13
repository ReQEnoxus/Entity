//
//  EntityDecoder.swift
//  Entity
//
//  Created by Enoxus on 25.10.2020.
//

public protocol EntityDecoder {
    func decode(from data: Data?, of type: Type) -> Entity?
}

public struct BasicEntityDecoder: EntityDecoder {
    
    public init(typeManager: TypeManager) {
        self.typeManager = typeManager
    }
    
    private let typeManager: TypeManager
    
    public func decode(from data: Data?, of type: Type) -> Entity? {
        guard let data = data, let json = try? JSONSerialization.jsonObject(with: data) else { return nil }
        guard let decoded = decodeRecursive(from: json, of: type) else { return nil }
        let entity = Entity(type: type, fields: decoded)
        return entity
    }
    
    private func decodeRecursive(from something: Any, of type: Type) -> [String: Any]? {
        guard let dict = something as? [String: Any] else { return nil }
        
        var fields = [String: Any]()
        if dict.count != type.attributes.count {
            // data is already malformed, not even trying to decode
            return nil
        }
        for (name, basicType) in type.attributes {
            guard let rawData = dict[name] else { return nil }
            
            switch basicType {
            case let .primitive(type):
                switch type {
                case .number:
                    guard let double = rawData as? Double else { return nil }
                    fields[name] = double
                case .bool:
                    guard let bool = rawData as? Bool else { return nil }
                    fields[name] = bool
                case .string:
                    guard let string = rawData as? String else { return nil }
                    fields[name] = string
                }
            case let .custom(typeName):
                guard let type = typeManager.type(named: typeName) else { return nil }
                guard let decoded = decodeRecursive(from: rawData, of: type) else { return nil }
                fields[name] = decoded
            case let .array(basic):
                switch basic {
                case let .primitive(type):
                    switch type {
                    case .number:
                        guard let double = rawData as? [Double] else { return nil }
                        fields[name] = double
                    case .bool:
                        guard let bool = rawData as? [Bool] else { return nil }
                        fields[name] = bool
                    case .string:
                        guard let string = rawData as? [String] else { return nil }
                        fields[name] = string
                    }
                case let .custom(typeName):
                    guard let type = typeManager.type(named: typeName) else { return nil }
                    guard let rawDataArray = rawData as? [Any] else { return nil }
                    fields[name] = rawDataArray.compactMap({ decodeRecursive(from: $0, of: type) })
                case .array:
                    let nestedType = Type(name: UUID().uuidString, attributes: ["container": basic])
                    guard let rawDataArray = rawData as? [Any] else { return nil }
                    fields[name] = rawDataArray.compactMap({ decodeRecursive(from: ["container": $0], of: nestedType)?["container"] })
                }                
            }
        }
        return fields
    }
}
