//
//  Days+Helpers.swift
//  AdventOfCode-Swift
//
//  Created by Thomas Durand on 02/12/2020.
//  Copyright © 2020 Thomas Durand. All rights reserved.
//

import Foundation

extension Day {
    static func integers(for input: String) -> [Int] {
        input.components(separatedBy: .newlines).compactMap { Int($0) }
    }
}
