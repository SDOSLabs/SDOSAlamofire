//
//  InitialViewController.swift
//  SDOSAlamofire
//
//  Created by Antonio Jesús Pallares on 02/26/2019.
//  Copyright (c) 2019 Antonio Jesús Pallares. All rights reserved.
//

import UIKit
import WebKit

class InitialViewController: UIViewController {
    
    //MARK: - Properties
    
    lazy fileprivate var spinner: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    lazy fileprivate var barBtnSpinner: UIBarButtonItem = {
        return UIBarButtonItem(customView: spinner)
    }()
    
    lazy fileprivate var barBtnReload: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadPage(_:)))
    }()
    
    @IBOutlet weak var btnGoBack: UIButton!
    @IBOutlet weak var btnGoForward: UIButton!
    @IBOutlet weak var btnExample: UIButton!
    
    @IBOutlet weak var viewForWebView: UIView!
    
    @IBOutlet weak var lbVersion: UILabel!
    
    @IBOutlet weak var viewBottonBar: UIView!
    
    lazy private var webView: WKWebView = {
        let webView = WKWebView(frame: viewForWebView.bounds)
        addAlignedBordersSubview(webView, to: viewForWebView)
        webView.navigationDelegate = self
        return webView
    }()
    
    //MARK: - View Controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInitialURL()
        loadContent()
        updateBackForwardButtons()
    }
    
    //MARK: - Custom methods
    
    private func addAlignedBordersSubview(_ subview: UIView!, to parent: UIView!) {
        parent.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
    }
    
    private func loadContent() {
        title = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        lbVersion.text = String(format: NSLocalizedString("SDOSAlamofireSample.version", comment: ""), Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
        btnGoBack.setTitle(Constants.Navigation.goBackButtonTitle, for: .normal)
        btnGoForward.setTitle(Constants.Navigation.goForwardButtonTitle, for: .normal)
        btnExample.setTitle(NSLocalizedString("SDOSAlamofireSample.btn.seeExample", comment: ""), for: .normal)
    }
    
    private func loadInitialURL() {
        guard let url = URL(string: Constants.Documentation.url) else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func updateBackForwardButtons() {
        btnGoBack.isEnabled = webView.canGoBack
        btnGoForward.isEnabled = webView.canGoForward
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Events
    
    fileprivate func didStartLoadingWebsite() {
        if let rightBarBtn = navigationItem.rightBarButtonItem, rightBarBtn !== barBtnSpinner {
            navigationItem.setRightBarButton(barBtnSpinner, animated: false)
            spinner.startAnimating()
        }
    }
    
    fileprivate func didFinishLoadingWebsite() {
        spinner.stopAnimating()
        navigationItem.setRightBarButton(barBtnReload, animated: false)
    }
    
    //MARK: - Actions
    
    @objc private func reloadPage(_ sender: UIBarButtonItem?) {
        loadInitialURL()
    }

    @IBAction func actionGoBack(_ sender: Any) {
        webView.goBack()
        updateBackForwardButtons()
    }
    
    @IBAction func actionGoForward(_ sender: Any) {
        webView.goForward()
        updateBackForwardButtons()
    }
    
    @IBAction func actionSeeExample(_ sender: Any) {
        
    }
}

extension InitialViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        didStartLoadingWebsite()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        didStartLoadingWebsite()
        updateBackForwardButtons()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        didFinishLoadingWebsite()
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        updateBackForwardButtons()
    }
    
}
