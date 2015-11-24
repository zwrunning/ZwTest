//
//  NetWorkManager.swift
//  Night
//
//  Created by Air. on 15/11/24.
//  Copyright © 2015年 Air. All rights reserved.
//

import Foundation

/// 网络访问接口 - 单例
class NetWorkManager {
    
    // 内存中唯一实例
    // 全局中唯一访问入口
    // let 定义常量，Swift 中， let 是线程安全的
    static let shareManager = NetWorkManager()
//    // 定义类变量，提供全局访问入口
//    class var shareManager: NetWorkManager {
//        return instance
//    }
    
    // 定义了一个类的完成闭包类型
    typealias Completion = (result: AnyObject?, error: NSError?) -> ()
    
    func requestJSON(method: HTTPMethod, urlString: String, params: [String: String]?,completion: Completion) {
        net.requestJSON(method, urlString: urlString, params: params, completion: completion)
    }
    
    // 全局网络框架实例，只实例化一次
    private let net = SimpleNetWork()
}
