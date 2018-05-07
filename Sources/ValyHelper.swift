//
//  ValyHelper.swift
//  Validator
//
//  Created by Kazuya Ueoka on 2016/11/15.
//
//

import Foundation

@objc public enum ValidatorRule: Int {
    case required
    case match
    case pattern
    case alphabet
    case digit
    case alnum
    case number
    case minLength
    case maxLength
    case exactLength
    case numericMin
    case numericMax
    case numericBetween
}

@objc public class Validator: NSObject {
    private let shared: AnyValidator = Valy.factory()

    @objc(addRule:)
    public func add(rule: ValidatorRule) -> Self {
        return self.add(rule: rule, value1: nil, value2: nil)
    }

    @objc(addRule:value:)
    public func add(rule: ValidatorRule, value: Any?) -> Self {
        return self.add(rule: rule, value1: value, value2: nil)
    }

    @objc(addRule:value1:value2:)
    public func add(rule: ValidatorRule, value1: Any?, value2: Any?) -> Self {
        switch rule {
        case .required:
            self.shared.add(rule: ValyRule.required)
        case .match:
            guard let match: String = value1 as? String else {
                return self
            }
            self.shared.add(rule: ValyRule.match(match))
        case .pattern:
            guard let pattern: String = value1 as? String else {
                return self
            }
            self.shared.add(rule: ValyRule.pattern(pattern))
        case .alphabet:
            self.shared.add(rule: ValyRule.alphabet)
        case .digit:
            self.shared.add(rule: ValyRule.digit)
        case .alnum:
            self.shared.add(rule: ValyRule.alnum)
        case .number:
            self.shared.add(rule: ValyRule.number)
        case .minLength:
            guard let min: Int = value1 as? Int else {
                return self
            }

            self.shared.add(rule: ValyRule.minLength(min))
        case .maxLength:
            guard let max: Int = value1 as? Int else {
                return self
            }

            self.shared.add(rule: ValyRule.maxLength(max))
        case .exactLength:
            guard let exact: Int = value1 as? Int else {
                return self
            }

            self.shared.add(rule: ValyRule.exactLength(exact))
        case .numericMin:
            guard let min: Double = value1 as? Double else {
                return self
            }

            self.shared.add(rule: ValyRule.numericMin(min))
        case .numericMax:
            guard let max: Double = value1 as? Double else {
                return self
            }

            self.shared.add(rule: ValyRule.numericMax(max))
        case .numericBetween:
            guard let min: Double = value1 as? Double, let max: Double = value2 as? Double else {
                return self
            }
            self.shared.add(rule: ValyRule.numericBetween(min: min, max: max))
        }

        return self
    }

    @objc(runWithValue:)
    public func run(with value: String?) -> Bool {
        guard let validatable: AnyValidatable = self.shared as? AnyValidatable else {
            return false
        }

        switch validatable.run(with: value) {
        case .success:
            return true
        case .failure(_):
            return false
        }
    }
}
