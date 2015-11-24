//
//  OAuthViewController.swift
//  Night
//
//  Created by Air. on 15/11/23.
//  Copyright © 2015年 Air. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {

    let AIR_API_URL_String       = "https://api.weibo.com"
    let AIR_Redirect_URL_String  = "http://www.baidu.com"
    let AIR_Client_ID            = "643131690"
    let AIR_Client_Secret        = "4067021dca397c559d9a661bc6873239"
    let AIR_Grant_Type           = "authorization_code"
    
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        loadAuthPage()
    }

    
    ///  加载
    func loadAuthPage() {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(AIR_Client_ID)&redirect_uri=\(AIR_Redirect_URL_String)"
        
        let url = NSURL(string: urlString)
        
        webView.delegate = self
        webView.loadRequest(NSURLRequest(URL: url!))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension OAuthViewController: UIWebViewDelegate {
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print(__FUNCTION__)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print(__FUNCTION__)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        print(__FUNCTION__)
    }
    
    ///  页面重定向
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        print(request.URL)
        
        let result = continueWithCode(request.URL!)
        
        if let code = result.code {
            
            // 参数
            let parameters = [
                "client_id": "643131690",
                "client_secret": "4067021dca397c559d9a661bc6873239",
                "grant_type": "authorization_code",
                "code": code,
                "redirect_uri": "http://www.baidu.com"
            ]
            
            let net = NetWorkManager()
            net.requestJSON(.POST, urlString: "https://api.weibo.com/oauth2/access_token", params: parameters, completion: { (result, error) -> () in
                
                print(result)
            })
            
//            print(code)
        }
        if !result.load {
           
            //            SVProgressHUD.showInfoWithStatus("不加载")
            // 如果不加载页面，需要重新刷新授权页面
            // TODO: 有可能会出现多次加载页面，现在真的不正常了！
            // 只有点击取消按钮，才需要重新刷新授权页面
            if result.reloadPage {
//                SVProgressHUD.showInfoWithStatus("你真的残忍的拒绝吗？", maskType: SVProgressHUDMaskType.Gradient)
                loadAuthPage()
            }
        }
        
        return result.load
    }
    
    ////  根据URL判断是否继续
    ///
    ///  :param: url URL
    ///
    ///  :returns: 1. 是否加载当前页面 2. code(如果有) 3. 是否刷新授权页面
    func continueWithCode(url: NSURL) -> (load: Bool, code: String?, reloadPage: Bool) {
        
        // 1. 将url转换成字符串
        let urlString = url.absoluteString
        
        // 2. 如果不是微博的 api 地址，都不加载
        if !urlString.hasPrefix(AIR_API_URL_String) {
            // 3. 如果是回调地址，需要判断 code ithema.com
            if urlString.hasPrefix(AIR_Redirect_URL_String) {
                if let query = url.query {
                    let codestr: NSString = "code="
                    
                    // 访问新浪微博授权的时候，带有回调地址的url只有两个，一个是正确的，一个是错误的！
                    if query.hasPrefix(codestr as String) {
                        let q = query as NSString!
                        return (false, q.substringFromIndex(codestr.length), false)
                    } else {
                        return (false, nil, true)
                    }
                }
            }
            
            return (false, nil, false)
        }
        
        return (true, nil, false)
    }
    
}