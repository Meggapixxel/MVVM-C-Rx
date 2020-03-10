import UIKit
import RxSwift

@propertyWrapper
struct ProtocolPrivate<T> {
   var wrappedValue: T
}

protocol P_Bindable {
    
    associatedtype SignUpVM: P_ViewModel

    var viewModel: SignUpVM! { get set }
    
    /// Configurates controller with specified P_ViewModel subclass
    ///
    /// - Parameter viewModel: P_ViewModel subclass instance to configure with
    func bindViewModel()
    
}
