//
//  AnyValidator.swift
//  ValidatorSample
//
//  Created by Kazuya Ueoka on 2016/11/14.
//  Copyright © 2016年 Timers Inc. All rights reserved.
//

import Foundation

public protocol AnyValidatorRule {
    func run(with value: String?) -> Bool
}

public enum ValidatorResult {
    case success
    case failure(AnyValidatorRule)
}

public protocol AnyValidator: class {
    var rules: [AnyValidatorRule] { get }

    static func factory() -> AnyValidator
    static func factory(rules: [AnyValidatorRule]) -> AnyValidatable

    @discardableResult
    func add(rule: AnyValidatorRule) -> AnyValidatable
    @discardableResult
    func add(rules: [AnyValidatorRule]) -> AnyValidatable
}

public protocol AnyValidatable: AnyValidator {}
public extension AnyValidatable {
    func run(with value: String?) -> ValidatorResult {
        let first: AnyValidatorRule? = self.rules.filter { (rule: AnyValidatorRule) -> Bool in
            !rule.run(with: value)
        }.first

        guard let failed: AnyValidatorRule = first else {
            return ValidatorResult.success
        }
        return ValidatorResult.failure(failed)
    }
}
