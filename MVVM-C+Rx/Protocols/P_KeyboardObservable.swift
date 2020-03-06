import UIKit

protocol P_KeyboardObservable: NSObject {
    
    func keyboardWillShow(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions)
    
    func keyboardWillChangeFrame(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions)
    
    func keyboardWillHide(duration: TimeInterval, options: UIView.AnimationOptions)
    
}
extension P_KeyboardObservable {

    func keyboardWillShow(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) { }
    
    func keyboardWillChangeFrame(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) { }
    
    func keyboardWillHide(duration: TimeInterval, options: UIView.AnimationOptions) { }
    
}

fileprivate extension NSObject {
    
    @objc func willShow(_ notification: Notification) {
        guard let keyboardObservable = self as? P_KeyboardObservable else { return }
        let info = notification.userInfo!
        let kbHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        keyboardObservable.keyboardWillShow(height: kbHeight, duration: duration, options: UIView.AnimationOptions(rawValue: curve))
    }
    
    @objc func willChangeFrame(_ notification: Notification) {
        guard let keyboardObservable = self as? P_KeyboardObservable else { return }
        let info = notification.userInfo!
        let height = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let options = UIView.AnimationOptions(rawValue: curve)
        keyboardObservable.keyboardWillChangeFrame(height: height, duration: duration, options: options)
    }
    
    @objc func willHide(_ notification: Notification) {
        guard let keyboardObservable = self as? P_KeyboardObservable else { return }
        let info = notification.userInfo!
        let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let options = UIView.AnimationOptions(rawValue: curve)
        keyboardObservable.keyboardWillHide(duration: duration, options: options)
    }
    
}
extension P_KeyboardObservable {
    
    func beginKeyboardObserving() {
        endKeyboardObserving()
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(willShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(willChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        center.addObserver(self, selector: #selector(willHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func endKeyboardObserving() {
        let center = NotificationCenter.default
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
}
