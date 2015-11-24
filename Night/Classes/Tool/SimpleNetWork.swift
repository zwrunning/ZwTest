//
//  SimpleNetWork.swift
//  Night
//
//  Created by Air. on 15/11/22.
//  Copyright © 2015年 Air. All rights reserved.
//

import Foundation

///  常用网络方法
///
///  - GET:  GET
///  - POST: POST
public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
}

public class SimpleNetWork {
    
    
    
    // 全局网络会话
    lazy var session: NSURLSession? = {
       return NSURLSession.sharedSession()
    }()
    
//    func requestJSON(method: HTTPMethod, urlString: String, params: [String: String]?,completion:((result: AnyObject?, error: NSError?) -> ())) {
//        
//    }
    
    // 定义闭包类型，类型别名 ->
    public typealias Completion = (result: AnyObject?, error: NSError?) -> ()
    ///  请求 JSON
    ///
    ///  - parameter method:     HTTP访问方法
    ///  - parameter urlString:  urlString
    ///  - parameter params:     可选参数字典
    ///  - parameter completion: 完成回调
    public func requestJSON(method: HTTPMethod, urlString: String, params: [String: String]?,completion: Completion) {
        
        // 实例化网络请求
        if let request = request(method, urlString: urlString, params: params) {
            
            // 访问网络 - 本身回调方法是异步
            session!.dataTaskWithRequest(request, completionHandler: { (data, _, error) -> Void in
                
                // 如果有错误，直接回调
                if error != nil {
                    completion(result: nil, error: error)
                    return
                }
                
                // 反序列化 -> 字典或者数组
                let json: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                
                // 判断是否反序列化成功
                if json == nil {
                    let error = NSError(domain: SimpleNetWork.errorDomain, code: -1, userInfo: ["error": "反序列化失败"])
                    completion(result: nil, error: error)
                } else {
                    // 有结果
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(result: json, error: nil)
                    })
                }
            }).resume()
            return
        }
        
        /**
            domain错误所属领域字符串 com.air.error
            code滴定仪错误编号
            userInfo错误信息字典
        */
        let error = NSError(domain: SimpleNetWork.errorDomain, code: -1, userInfo: ["error": "请求建立失败"])
        completion(result: nil, error: error)
    }
    
    // 类属性
    static let errorDomain = "com.air.error"
    ///  返回网络访问请求
    ///
    ///  - parameter method:    HTTP访问方法
    ///  - parameter urlString: urlString
    ///  - parameter params:    可选参数字典
    ///
    ///  - returns: 可选网络请求
    func request(method: HTTPMethod, urlString: String, params: [String: String]?) -> NSURLRequest? {
        
        // urlString如果是"" & nil
        if urlString.isEmpty {
            return nil
        }
        
        // 记录urlString
        var urlStr = urlString
        var r: NSMutableURLRequest?
        
        if method == .GET {
            // URL 的参数拼接在URL字符串中
            // 查询字符串
            let query = queryString(params)
            
            // 如果有拼接参数
            if query != nil {
                urlStr += "?" + query!
            }
            
            // 实例化请求
            r = NSMutableURLRequest(URL: NSURL(string: urlStr)!)
        } else {
            
            // 设置请求体
            if let query = queryString(params) {
                r = NSMutableURLRequest(URL: NSURL(string: urlStr)!)
                
                // 设置请求方法
                // 枚举类型，如果要去返回值，需要使用rawValur
                r!.HTTPMethod = method.rawValue
                
                // 设置数据体，转化成二进制数据
                r!.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            }
            
        }
        
        return r
    }
    ///  查询请求字符串
    func queryString(parmas: [String: String]?) -> String? {
        
        // 判断参数
        if parmas == nil {
            return nil
        }
        
        // 定义一个数组
        var array = [String]()
        // 遍历字典 
        for (k, v) in parmas! {
            let str = "\(k)=\(v.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!)"
            array.append(str)
        }
        
        return array.joinWithSeparator("&")
    }
    
    ///  公共初始函数
    public init() {
        
    }
}