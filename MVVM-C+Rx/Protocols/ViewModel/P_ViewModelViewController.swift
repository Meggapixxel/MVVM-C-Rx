import Foundation
import RxSwift

protocol P_ViewModelViewController: P_ViewModel {
    
    var errorsSubject: PublishSubject<Error> { get }
    
}
