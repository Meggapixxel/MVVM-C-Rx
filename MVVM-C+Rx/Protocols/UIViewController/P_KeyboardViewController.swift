import UIKit

protocol P_KeyboardViewController: P_KeyboardObservable where Self: UIViewController {

    var isKeyboardObserving: Bool { get }

}
