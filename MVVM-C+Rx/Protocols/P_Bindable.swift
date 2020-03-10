import UIKit
import RxSwift

@propertyWrapper
struct ProtocolPrivate<T> {
   var wrappedValue: T
}

protocol P_Bindable {
    
    associatedtype ViewModel: P_ViewModel

    var viewModel: ViewModel! { get set }
    
    /// Configurates controller with specified P_ViewModel subclass
    ///
    /// - Parameter viewModel: P_ViewModel subclass instance to configure with
    func bindViewModel()
    
}
