//
//  Vector3D.swift
//  AdventOfCode-Swift
//
//  Created by Thomas DURAND on 20/12/2019.
//  Copyright © 2019 Thomas Durand. All rights reserved.
//

import Foundation

struct Vector3D: Hashable {
    static var zero = Vector3D(x: 0, y: 0, z: 0)

    var x: Int
    var y: Int
    var z: Int

    var manatthanDistance: Int {
        return abs(x) + abs(y) + abs(z)
    }
}

extension Vector3D: CustomStringConvertible {
    var description: String {
        return "<x=\(x), y=\(y), z=\(z)>"
    }
}

extension Vector3D {
    static func +(lhs: Vector3D, rhs: Vector3D) -> Vector3D {
        return Vector3D(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y,
            z: lhs.z + rhs.z
        )
    }
}
