//
//  WebViewController.swift
//  DealDoc
//
//  Created by Asad Khan on 11/30/22.
//

import UIKit
import WebKit
class WebViewController: UIViewController {

    var dealID : Int?
    @IBOutlet var webView: UIWebView!
    var url: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        let user_ID = DealDocSessionManager.shared.getUser()?.id
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        if dealID == 0 || dealID == nil {
            url = URL(string: "https://admin.dealdoc.app/calendly?token=\(token)")!
        }else {
            url = URL(string: "https://admin.dealdoc.app/calendly?deal_id=\(dealID ?? 0)&token=\(token)")!
        }
        print(url!)
        let requestObj = NSURLRequest(url: url! as URL)
        webView.loadRequest(requestObj as URLRequest);
        self.view.addSubview(webView)
    }
    
    @IBAction func backButtonTapped (_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
