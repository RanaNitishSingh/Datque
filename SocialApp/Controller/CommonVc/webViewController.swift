//
//  webViewController.swift
//  SocialApp
//
//  Created by Zero IT Solutions on 20/04/23.
//

import UIKit
import WebKit

class webViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var mainWebView: WKWebView!
    @IBOutlet weak var btnBack: UIButton!
    var headerTxt = String()
    var contentUrl = String()
    var activityIndicator: UIActivityIndicatorView!
    var url = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if contentUrl == "" {
            url = "https://datque.zeroitsolutions.com/privecy-policy.php"
        } else {
            url = "https://datque.zeroitsolutions.com/about-us.php"
        }
        
        let url = URL(string: url)
        let requestObj = URLRequest(url: url! as URL)
        mainWebView.navigationDelegate = self
        mainWebView.uiDelegate = self
        headerLbl.text = headerTxt
        mainWebView.load(requestObj)
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        view.addSubview(activityIndicator)
    }
    
    func showActivityIndicator(show: Bool) {
            if show {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            showActivityIndicator(show: false)
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            showActivityIndicator(show: true)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            showActivityIndicator(show: false)
        }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
