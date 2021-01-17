//
//  LinkItemDetailsViewController.swift
//  Argylist
//
//  Created by Gytis Tumas on 2021-01-16.
//

import UIKit
import WebKit

class LinkItemDetailsViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    var urlString: String?
    let activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        if let urlString = urlString, let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
            webView.navigationDelegate = self
        }

        let refreshBarButton: UIBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = refreshBarButton
    }
}

extension LinkItemDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        showAlert(error.localizedDescription)
    }
}
