//
//  AirflexAdView.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 18/4/25.
//

import UIKit
import WebKit

public class AirflexAdView: UIView {
    public enum AdType: Int {
        case BANNER = 0
        case PRODUCT = 1
        // Add other types as needed
    }

    private var adType: AdType?
    private var adId: String?
    private var htmlView: UIView!
    private var adWidth: Int = 0
    private var adHeight: Int = 0
    private var adContent: [String] = []
    private var onClickAd: ((String, String) -> Void)?
    private var heightConstraint: NSLayoutConstraint?

    // Initializers
    public init(context: UIView, adType: AdType, adId: String) {
        super.init(frame: .zero)
        self.adType = adType
        self.adId = adId
        initView()
    }
    
    public func showAd() {
        checkAuthenticationAndFetchAd()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    private func initView() {
//        self.translatesAutoresizingMaskIntoConstraints = false
        htmlView = UIView()
        htmlView.backgroundColor = UIColor.white
        addSubview(htmlView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAdClick))
        htmlView.addGestureRecognizer(tapGesture)
    }

    @objc private func handleAdClick() {
        if let adId = adId {
            onClickAd?(adId, "")
        }
    }

    private func checkAuthenticationAndFetchAd() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.isAuthenticated() {
                self.fetchAd()
            } else {
                self.checkAuthenticationAndFetchAd()
            }
        }
    }

    private func isAuthenticated() -> Bool {
        // Replace with actual authentication logic
        return true
    }
    
    
    private func getPageViewControllerContentSize(pageViewController: UIPageViewController?) -> CGSize? {
        guard let pageViewController = pageViewController else { return nil }
        for subview in pageViewController.view.subviews {
            if let scrollView = subview as? UIScrollView {
                return scrollView.contentSize
            }
        }
        return nil
    }

    private func createViewPager() {
//        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        pageViewController.dataSource = self
//        pageViewController.view.frame = htmlView.bounds
//        htmlView.addSubview(pageViewController.view)
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = true
        
        if let contentSize = getPageViewControllerContentSize(pageViewController: pageViewController) {
            print("Content size: \(contentSize)")
        }

        // Add the pageViewController's view to htmlView
        self.parentViewController()?.addChildViewController(pageViewController)
    
        htmlView.addSubview(pageViewController.view)

        // Set constraints for pageViewController's view
//        NSLayoutConstraint.activate([
//            pageViewController.view.leadingAnchor.constraint(equalTo: htmlView.leadingAnchor),
//            pageViewController.view.trailingAnchor.constraint(equalTo: htmlView.trailingAnchor),
//            pageViewController.view.topAnchor.constraint(equalTo: htmlView.topAnchor),
//            pageViewController.view.bottomAnchor.constraint(equalTo: htmlView.bottomAnchor)
//        ])
        pageViewController.view.frame = htmlView.bounds

        // Set the initial page
        if adContent.count > 0 {
            pageViewController.setViewControllers([AdPageViewController(content: adContent[0], adId: self.adId, index: 0)], direction: .forward, animated: true)
        }
    }

    private func fetchAd() {
        guard let adId = adId, let adType = (adType == AdType.PRODUCT ? "PRODUCT" : "BANNER") else { return }
        print("Fetching ad... \(adId) | \(adType)")

        AirflexAdHelper.getAd(adId: adId, adType: "\(adType)") { [weak self] result in
            DispatchQueue.main.async {
                if result == nil {
                    print("Failed to fetch ad")
                } else {
                    print("Ad fetched successfully")
                    self?.adContent = result!.adData
                    self?.adWidth = result!.size.width
                    self?.adHeight = result!.size.height
                    print("Ad fetched: \(self?.adContent ?? [])")
                    // Lấy chiều rộng của parent
                    let parentWidth = self?.bounds.width ?? 0

                    // Tính toán chiều cao mới dựa trên tỷ lệ
                    let aspectRatio = CGFloat(self?.adHeight ?? 0) / CGFloat(self?.adWidth ?? 1)
                    let newHeight = parentWidth * aspectRatio
//                    print(self?.heightAnchor.value(forKey: "constant") as Any)
                    // Update height constraint
//                    if self?.heightConstraint == nil {
//                        self?.heightConstraint = self?.heightAnchor.constraint(equalToConstant: newHeight)
//                        self?.heightConstraint?.isActive = true
//                    } else {
//                        self?.heightConstraint?.constant = newHeight
//                    }
                    for constraint in self?.constraints ?? [] {
                        if constraint.firstAttribute == .height {
                            constraint.constant = newHeight
                        }
                    }
                        

//                    self?.htmlView.frame = CGRect(x: 0, y: 0, width: parentWidth, height: newHeight)
//                    self?.htmlView.backgroundColor = UIColor.red
                    // Trigger layout updates
                    self?.setNeedsLayout()
                    self?.layoutIfNeeded()
                    self?.createViewPager()
                }
            }
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        htmlView.frame = bounds
    }

    func setOnClickAd(_ callback: @escaping (String, String) -> Void) {
        self.onClickAd = callback
    }
}

// MARK: - UIPageViewControllerDataSource
extension AirflexAdView: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = (viewController as? AdPageViewController)?.index, index > 0 else {
            return nil
        }
        print("index \(index)")
        return AdPageViewController(content: adContent[index - 1], adId: self.adId, index: index - 1)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = (viewController as? AdPageViewController)?.index, index < adContent.count - 1 else {
            return nil
        }
        return AdPageViewController(content: adContent[index + 1], adId: self.adId, index: index + 1)
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return adContent.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let viewController = pageViewController.viewControllers?.first as? AdPageViewController else {
            return 0
        }
        return viewController.index
    }
}

// MARK: - AdPageViewController
class AdPageViewController: UIViewController, WKNavigationDelegate {
    private var adId: String?
    let content: String
    let index: Int

    init(content: String, adId: String?, index: Int) {
        self.content = content
        self.index = index
        self.adId = adId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white
//        let label = UILabel()
//        label.text = content
//        label.font = UIFont.systemFont(ofSize: 30)
//        label.textAlignment = .center
//        label.frame = view.bounds
//        view.addSubview(label)
//        if(index == 0) {
//            view.backgroundColor = UIColor.red
//        } else if(index == 1) {
//            view.backgroundColor = UIColor.blue
//        } else if(index == 2) {
//            view.backgroundColor = UIColor.green
//        }
        view.backgroundColor = .white
        
        // Load the adContent as HTML
        let htmlContent = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <style>
            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                -webkit-user-select: none;
                -webkit-touch-callout: none;
            }
        </style>
        </head>
        <body>
        \(content)
        </body>
        </html>
        """

        // Create a WKWebView
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.preferences.javaScriptEnabled = false // Disable JavaScript

        let webView = WKWebView(frame: view.bounds, configuration: webViewConfiguration)
        webView.scrollView.isScrollEnabled = false
        
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        webView.navigationDelegate = self
        
        // Add a UITapGestureRecognizer to detect touch events on the page
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePageTap))
        
        
        let clickableArea = UIView(frame: view.bounds)
        clickableArea.backgroundColor = .clear
        view.addSubview(clickableArea)
        clickableArea.addGestureRecognizer(tapGesture)
        
        // Load the adContent as HTML
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
    
    @objc private func handlePageTap() {
        print("WebView touched")
        // Add your custom logic here
    }
    
    // WKNavigationDelegate method
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView content loaded for page \(index)")
        // Add your custom logic here
        if content != nil {
            print("Ad content: \(content)")
            AirflexAdHelper.trackImpression(adId: self.adId ?? "", productId: "String")
        }
    }
}

extension AirflexAdView {
    func parentViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder?.next
        }
        return nil
    }
}
