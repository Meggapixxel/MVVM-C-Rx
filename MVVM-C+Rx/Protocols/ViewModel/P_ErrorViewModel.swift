import Foundation
import RxSwift

protocol P_ErrorViewModel: P_ViewModel {
    
    var errorsSubject: PublishSubject<Error> { get }
    
}
