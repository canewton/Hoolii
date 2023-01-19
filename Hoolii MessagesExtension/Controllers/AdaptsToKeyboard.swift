//
//  AdaptsToKeyboard.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/13/22.
//

import UIKit

// make a class that components inherit from to move the screen up when a text box is selected so that
// the keyboard doesn't cover the textbox
class AdaptsToKeyboard: AppViewController {
    var bottomConstraint: NSLayoutConstraint?
    var topConstraint: NSLayoutConstraint?
    var animationDuration: Double = 0
    var animationCurveOptions: UIView.AnimationOptions = UIView.AnimationOptions()
    var keyboardHeight: CGFloat = 0
    var tap: UITapGestureRecognizer = UITapGestureRecognizer()
    var offset: CGFloat = 0
    
    
    public func configure(bottomConstraint: NSLayoutConstraint, topConstraint: NSLayoutConstraint) {
        self.bottomConstraint = bottomConstraint
        self.topConstraint = topConstraint
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        // Observe keyboard frame changes.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        offset = self.view.bounds.height - 575
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: NSNotification) {
        // Unwrap notification objects.
        guard let userInfo = notification.userInfo,
              let animationDurationNumber = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
              let animationCurveNumber = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
              let _ = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        else {
            return
        }

        animationCurveOptions = UIView.AnimationOptions(rawValue: animationCurveNumber.uintValue << 16)
        animationDuration = animationDurationNumber.doubleValue

        // Get keyboard height.
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        
        view.addGestureRecognizer(tap)

        // Animate bottom constraint when text box is selected
        // This is so that the keyboard does not cover the text box
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: animationCurveOptions,
            animations: { [unowned self] in
                let bottomInset = keyboardHeight > 0 ? keyboardHeight : view.safeAreaInsets.bottom
                self.bottomConstraint?.constant = bottomInset - offset
                self.topConstraint?.constant = -bottomInset + offset
                view.layoutIfNeeded()
            }
        )
    }
    
    @objc func keyboardWillHide() {
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: animationCurveOptions,
            animations: { [unowned self] in
                self.bottomConstraint?.constant = 0
                self.topConstraint?.constant = 0
                view.layoutIfNeeded()
            }
        )
    }
    
    // Animate the bottom constraint so that the look of the app is the way it was before
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
        view.removeGestureRecognizer(tap)
    }
}
