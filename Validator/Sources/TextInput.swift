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
    var validator: AnyValidatable { get }
    func add(rule: AnyValidatorRule) -> Self
    func add(rules: [AnyValidatorRule]) -> Self
    func valid() -> ValidatorResult
    func ovserveValidation(observer: ValidatorObserver)
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

        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(notification:)), name: Notification.Name.UITextFieldTextDidBeginEditing, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(notification:)), name: Notification.Name.UITextFieldTextDidChange, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(notification:)), name: Notification.Name.UITextFieldTextDidEndEditing, object: self)
        
        self.didSetup = true
    }

    @objc private func notificationReceived(notification: Notification) {
        let status: TextInputStatus
        switch notification.name {
        case Notification.Name.UITextFieldTextDidBeginEditing:
            status = .begin
        case Notification.Name.UITextFieldTextDidChange:
            status = .change
        case Notification.Name.UITextFieldTextDidEndEditing:
            status = .end
        default:
            return
        }

        self.observer?(status, self.valid())
    }

    public lazy var validator: AnyValidatable = {
        return Valy.factory(rules: [])
    }()

    public func add(rule: AnyValidatorRule) -> Self {
        self.validator.add(rule: rule)
        return self
    }
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

    public func textDidChaned() {
        print(#function)
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

        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(notification:)), name: Notification.Name.UITextViewTextDidBeginEditing, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(notification:)), name: Notification.Name.UITextViewTextDidChange, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(notification:)), name: Notification.Name.UITextViewTextDidEndEditing, object: self)

        self.didSetup = true
    }

    @objc private func notificationReceived(notification: Notification) {
        let status: TextInputStatus
        switch notification.name {
        case Notification.Name.UITextViewTextDidBeginEditing:
            status = .begin
        case Notification.Name.UITextViewTextDidChange:
            status = .change
        case Notification.Name.UITextViewTextDidEndEditing:
            status = .end
        default:
            return
        }

        self.observer?(status, self.valid())
    }

    public lazy var validator: AnyValidatable = {
        return Valy.factory(rules: [])
    }()

    public func add(rule: AnyValidatorRule) -> Self {
        self.validator.add(rule: rule)
        return self
    }
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
}
