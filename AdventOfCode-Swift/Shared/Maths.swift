//
//  Maths.swift
//  AdventOfCode-Swift
//
//  Created by Thomas DURAND on 23/12/2019.
//  Copyright © 2019 Thomas Durand. All rights reserved.
//

import Foundation

func greatestCommonDivider(_ a: Int, _ b: Int) -> Int {
    return b == 0 ? a : greatestCommonDivider(b, a % b)
}

func leastCommonMultiple(_ a: Int, _ b: Int) -> Int {
    return a * b / greatestCommonDivider(a, b)
}

func leastCommonMultiple(_ numbers: [Int]) -> Int {
    if numbers.count == 2 {
        return leastCommonMultiple(numbers[0], numbers[1])
    }

    var left = numbers
    let a = left.popLast()!
    let b = left.popLast()!
    left.append(leastCommonMultiple(a, b))
    return leastCommonMultiple(left)
}
