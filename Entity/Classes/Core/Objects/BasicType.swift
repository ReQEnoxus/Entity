//
//  BasicType.swift
//  Entity
//
//  Created by Enoxus on 25.10.2020.
//

public indirect enum BasicType {
    case primitive(type: Primitive)
    case custom(type: String)
    case array(of: BasicType)
}
