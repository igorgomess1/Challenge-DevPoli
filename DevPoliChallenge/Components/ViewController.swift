import UIKit

public protocol ViewConfiguration: AnyObject {
    func buildViewHierarchy()
    func setupConstraints()
    func configureViews()
}

public extension ViewConfiguration {
    func buildLayout() {
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }

    func configureViews() { }
}

open class ViewController<Interactor, V: UIView>: UIViewController, ViewConfiguration {
    public var interactor: Interactor
    public var rootView: V
    
    public init(interactor: Interactor, rootView: @autoclosure @escaping () -> V) {
        self.interactor = interactor
        self.rootView = rootView()
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(interactor: Interactor) {
        self.interactor = interactor
        rootView = V()
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func loadView() {
        view = rootView
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
    
    open func buildViewHierarchy() { }
    
    open func setupConstraints() { }
    
    open func configureViews() { }
}
