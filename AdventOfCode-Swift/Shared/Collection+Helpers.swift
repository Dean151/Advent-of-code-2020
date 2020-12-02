//
//  Collection+Helpers.swift
//  AdventOfCode-Swift
//
//  Created by Thomas Durand on 02/12/2020.
//  Copyright © 2020 Thomas Durand. All rights reserved.
//

import Foundation

extension Collection {
    func count(where condition: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self {
            count += try condition(element) ? 1 : 0
        }
        return count
    }
}
