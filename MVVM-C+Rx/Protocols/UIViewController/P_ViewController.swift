import UIKit

protocol P_ViewController: P_InitializableViewController, P_Bindable, P_BaseRx {
    
}

extension P_ViewController {
    
    /// Factory function for view controller instatiation
    ///
    /// - Parameter viewModel: View model object
    /// - Returns: View controller of concrete type
    static func make(with viewModel: SignUpVM) -> Self {
        var vc = Self.newInstance
        vc.viewModel = viewModel
        vc.loadViewIfNeeded()
        vc.bindViewModel()
        return vc
    }
    
}
