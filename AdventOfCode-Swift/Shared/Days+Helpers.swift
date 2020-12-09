//
//  Days+Helpers.swift
//  AdventOfCode-Swift
//
//  Created by Thomas Durand on 02/12/2020.
//  Copyright © 2020 Thomas Durand. All rights reserved.
//

import Foundation

extension Day {
    static func integers(for input: String, separatedBy separator: CharacterSet = .newlines) throws -> [Int] {
        let components = input.components(separatedBy: separator)
        let integers = components.compactMap { Int($0) }
        guard integers.count == components.count else {
            throw Errors.unparsable
        }
        return integers
    }
}
