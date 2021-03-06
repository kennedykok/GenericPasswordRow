//
//  PasswordValidatorEngine.swift
//  GenericPasswordRow
//
//  Created by Diego Ernst on 9/1/16.
//  Copyright © 2016 Diego Ernst. All rights reserved.
//

import UIKit
import Foundation

public struct PasswordRule {

    let hint: String
    let test: (String) -> Bool

}

public class DefaultPasswordValidator: PasswordValidator {

    public let maxStrength = 4.0

    let rules: [PasswordRule] = [
        PasswordRule(hint: "Please enter a lowercase letter") { $0.satisfiesRegexp("[a-z]") },
        PasswordRule(hint: "Please enter a number") { $0.satisfiesRegexp("[0-9]") },
        PasswordRule(hint: "Please enter an uppercase letter") { $0.satisfiesRegexp("[A-Z]") },
        PasswordRule(hint: "At least 6 characters") { $0.characters.count > 5 }
    ]

    public func strengthForPassword(password: String) -> Double {
        return rules.reduce(0) { $0 + ($1.test(password) ? 1 : 0) }
    }

    public func hintForPassword(password: String) -> String? {
        return rules.reduce([]) { $0 + ($1.test(password) ? []: [$1.hint]) }.first
    }

    public func isPasswordValid(password: String) -> Bool {
        return rules.reduce(true) { $0 && $1.test(password) }
    }

    public func colorsForStrengths() -> [Double: UIColor] {
        return [
            0: UIColor(red: 244 / 255, green: 67 / 255, blue: 54 / 255, alpha: 1),
            1: UIColor(red: 255 / 255, green: 193 / 255, blue: 7 / 255, alpha: 1),
            2: UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1),
            3: UIColor(red: 139 / 255, green: 195 / 255, blue: 74 / 255, alpha: 1)
        ]
    }

}

internal extension String {

    func satisfiesRegexp(regexp: String) -> Bool {
        return rangeOfString(regexp, options: .RegularExpressionSearch) != nil
    }

}
