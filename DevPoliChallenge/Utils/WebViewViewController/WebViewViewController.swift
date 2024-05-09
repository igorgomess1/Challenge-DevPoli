import UIKit
import WebKit

class WebViewViewController: UIViewController {
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViewHierarchy()
        setupConstraints()
        loadWebView()
        setupNavigationBar()
    }
}

private extension WebViewViewController {
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Fechar",
            style: .done,
            target: self,
            action: #selector(didTapClose)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(didTapRefresh)
        )
    }
    
    func loadWebView() {
        webView.load(URLRequest(url: url))
    }
    
    @objc
    func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc
    func didTapRefresh() {
        loadWebView()
    }
}

private extension WebViewViewController {
    func setupViewHierarchy() {
        view.addSubview(webView)
    }
    
    func setupConstraints() {
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
