import UIKit

// MARK: - Swizzling
protocol P_SwizzlingInjection: class {
    static func inject()
}

class SwizzlingManager {
    
    private static let doOnce: Any? = {
        UIViewController.inject()
        return nil
    }()

    static func enableInjection() {
        _ = SwizzlingManager.doOnce
    }
    
}

extension UIApplication {
    
    override open var next: UIResponder? {
        SwizzlingManager.enableInjection() // Called before applicationDidFinishLaunching
        return super.next
    }
    
}

extension UIViewController: P_SwizzlingInjection {

    public static func inject() {
        [
            (#selector(viewDidLoad), #selector(swz_viewDidLoad)),
            (#selector(viewWillAppear(_:)), #selector(swz_viewWillAppear(_:))),
            (#selector(viewDidAppear(_:)), #selector(swz_viewDidAppear(_:))),
            (#selector(viewWillDisappear(_:)), #selector(swz_viewWillDisappear(_:))),
            (#selector(viewDidDisappear(_:)), #selector(swz_viewDidDisappear(_:)))
        ].forEach {
            let originalSelector = $0.0
            let swizzledSelector = $0.1

            guard let originalMethod = class_getInstanceMethod(self, originalSelector),
                let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
                else { return }

            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))

            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }

    @objc func swz_viewDidLoad() {
        self.swz_viewDidLoad()
        
    }

    @objc func swz_viewWillAppear(_ animated: Bool) {
        self.swz_viewWillAppear(animated)
        
        if let vc = self as? P_KeyboardViewController {
            if vc.isKeyboardObserving {
                vc.beginKeyboardObserving()
            }
        }
    }

    @objc func swz_viewDidAppear(_ animated: Bool) {
        self.swz_viewDidAppear(animated)

    }

    @objc func swz_viewWillDisappear(_ animated: Bool) {
        self.swz_viewWillDisappear(animated)
        
        if let vc = self as? P_KeyboardViewController {
            if vc.isKeyboardObserving {
                vc.endKeyboardObserving()
            }
        }
    }

    @objc func swz_viewDidDisappear(_ animated: Bool) {
        self.swz_viewDidDisappear(animated)
    }

}
