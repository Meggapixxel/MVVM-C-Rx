import UIKit

enum InitializableSource {
    
    case storyboard(storyboard: UIStoryboard, name: String?)
    case xib(name: String?)
    case manual
    
    static func storyboard(storyboard: UIStoryboard) -> InitializableSource { .storyboard(storyboard: storyboard, name: nil) }
    static var xib: InitializableSource { .xib(name: nil) }
    
}

protocol P_InitializableViewController: UIViewController {
    
    static var initiableResource: InitializableSource { get }
    
}

extension P_InitializableViewController {
    
    static var newInstance: Self {
        switch Self.initiableResource {
        case .storyboard(let storyboard, let name):
            return storyboard.instantiateViewController(withIdentifier: name ?? String(describing: Self.self)) as! Self
        case .xib(let name):
            return Self.init(nibName: name ?? String(describing: Self.self), bundle: nil)
        case .manual:
            return Self.init(nibName: nil, bundle: nil)
        }
    }
    
}
