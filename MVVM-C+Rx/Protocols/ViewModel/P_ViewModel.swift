import Foundation

/// Base for all controller viewModels.
///
/// It contains Input and Output types, usually expressed as nested structs inside a class implementation.
///
/// Input type should contain observers (e.g. AnyObserver) that should be subscribed to UI elements that emit input events.
///
/// Output type should contain observables that emit events related to result of processing of inputs.
protocol P_ViewModel: P_BaseRx {
    
    associatedtype INPUT
    associatedtype OUTPUT
    
    var input: INPUT { get }
    var output: OUTPUT { get }
    
}
