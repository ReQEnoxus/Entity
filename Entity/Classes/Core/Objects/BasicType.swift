//
//  BasicType.swift
//  Entity
//
//  Created by Enoxus on 25.10.2020.
//

public indirect enum BasicType: Equatable {
    case primitive(type: Primitive)
    case custom(type: String)
    case array(of: BasicType)
}

extension BasicType: Codable {
    enum CodingKeys: String, CodingKey {
        case primitive
        case custom
        case array
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let primitiveValue = try container.decodeIfPresent(PrimitiveCase.self, forKey: .primitive) {
            self = .primitive(type: primitiveValue.type)
        }
        else if let customValue = try container.decodeIfPresent(CustomCase.self, forKey: .custom) {
            self = .custom(type: customValue.typeName)
        }
        else {
            guard let arrayCase = try container.decodeIfPresent(ArrayCase.self, forKey: .array) else { fatalError() }
            self = .array(of: arrayCase.basic)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .primitive(let type):
            let primitiveCase = PrimitiveCase(type: type)
            try container.encode(primitiveCase, forKey: .primitive)
        case .custom(let type):
            let customCase = CustomCase(typeName: type)
            try container.encode(customCase, forKey: .custom)
        case .array(let type):
            let arrayCase = ArrayCase(basic: type)
            try container.encode(arrayCase, forKey: .array)
        }
    }
}

private struct PrimitiveCase: Codable {
    let type: Primitive
}

private struct CustomCase: Codable {
    let typeName: String
}

private struct ArrayCase: Codable {
    let basic: BasicType
}
