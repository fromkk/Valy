//
//  TextInput.swift
//  Validator
//
//  Created by Kazuya Ueoka on 2016/11/15.
//
//

import UIKit

@objc public enum TextInputStatus: Int {
    case begin
    case change
    case end
}

public protocol ValidatableInputText {
    associatedtype ValidatorObserver
    typealias ErrorGenerator = (_ rule: AnyValidatorRule) -> String?
    var validator: AnyValidatable { get }
    var failed: ErrorGenerator? { get set }
    func add(rule: AnyValidatorRule) -> Self
    func add(rules: [AnyValidatorRule]) -> Self
    func run() -> ValidatorResult
    func valid() -> ValidatorResult
    func ovserveValidation(observer: ValidatorObserver)
    func errorMessage(_ result: ValidatorResult) -> String?
}

extension ValidatableInputText {
    public func errorMessage(_ result: ValidatorResult) -> String? {
        switch result {
        case .success:
            return nil
        case .failure(let rule):
            return self.failed?(rule)
        }
    }
}

open class VLTextField: UITextField, ValidatableInputText {
    public typealias ValidatorObserver = (_ status: TextInputStatus, _ result: ValidatorResult) -> ()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        self.observer = nil
    }

    private var didSetup: Bool = false
    private func setup() {
        guard !self.didSetup else {
            return
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(notification:)), name: UITextField.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(notification:)), name: UITextField.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(notification:)), name: UITextField.textDidEndEditingNotification, object: self)
        
        self.didSetup = true
    }

    @objc private func notificationReceived(notification: Notification) {
        let status: TextInputStatus
        switch notification.name {
        case UITextField.textDidBeginEditingNotification:
            status = .begin
        case UITextField.textDidChangeNotification:
            status = .change
        case UITextField.textDidEndEditingNotification:
            status = .end
        default:
            return
        }

        self.observer?(status, self.valid())
    }

    public lazy var validator: AnyValidatable = {
        return Valy.factory(rules: [])
    }()
    
    public var failed: ValidatableInputText.ErrorGenerator?

    @discardableResult
    public func add(rule: AnyValidatorRule) -> Self {
        self.validator.add(rule: rule)
        return self
    }
    @discardableResult
    public func add(rules: [AnyValidatorRule]) -> Self {
        self.validator.add(rules: rules)
        return self
    }

    public func valid() -> ValidatorResult {
        return self.validator.run(with: self.text)
    }

    private var observer: ValidatorObserver?
    public func ovserveValidation(observer: @escaping ValidatorObserver) {
        self.observer = observer
    }

    public func run() -> ValidatorResult {
        return self.validator.run(with: self.text)
    }
}

open class VLTextView: UITextView, ValidatableInputText {
    public typealias ValidatorObserver = (_ status: TextInputStatus, _ result: ValidatorResult) -> ()

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        self.observer = nil
    }

    private var didSetup: Bool = false
    private func setup() {
        guard !self.didSetup else {
            return
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(notification:)), name: UITextView.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(notification:)), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(notification:)), name: UITextView.textDidEndEditingNotification, object: self)

        self.didSetup = true
    }

    @objc private func notificationReceived(notification: Notification) {
        let status: TextInputStatus
        switch notification.name {
        case UITextView.textDidBeginEditingNotification:
            status = .begin
        case UITextView.textDidChangeNotification:
            status = .change
        case UITextView.textDidEndEditingNotification:
            status = .end
        default:
            return
        }

        self.observer?(status, self.valid())
    }

    public lazy var validator: AnyValidatable = {
        return Valy.factory(rules: [])
    }()
    public var failed: ValidatableInputText.ErrorGenerator?

    @discardableResult
    public func add(rule: AnyValidatorRule) -> Self {
        self.validator.add(rule: rule)
        return self
    }
    @discardableResult
    public func add(rules: [AnyValidatorRule]) -> Self {
        self.validator.add(rules: rules)
        return self
    }

    public func valid() -> ValidatorResult {
        return self.validator.run(with: self.text)
    }

    private var observer: ValidatorObserver?
    public func ovserveValidation(observer: @escaping ValidatorObserver) {
        self.observer = observer
    }
    
    public func run() -> ValidatorResult {
        return self.validator.run(with: self.text)
    }
}
