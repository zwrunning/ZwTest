//
//  BaseTabBarController.swift
//  Night
//
//  Created by Air. on 15/11/21.
//  Copyright © 2015年 Air. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化子控制器
        self.addControllers()
        
        // 替换系统tabBar
        self.setValue(BaseTabBar(), forKey: "tabBar")
    }

///  初始化子控制器
    func addControllers() {
        // 首页
        tabBaraddViewController(vc: HomeTableViewController(), title: "首页", imageName: "tab_首页", selectedImage: "tab_首页_pressed")
        // 发现
        tabBaraddViewController(vc: DiscoverTableViewController(), title: "发现", imageName: "tab_社区", selectedImage: "tab_社区_pressed")
        // 搜索
        tabBaraddViewController(vc: SearchTableViewController(), title: "搜索", imageName: "tab_分类", selectedImage: "tab_分类_pressed")
        // 我
        tabBaraddViewController(vc: MeTableViewController(), title: "我", imageName: "tab_我的", selectedImage: "tab_我的_pressed")
    }
    
    func tabBaraddViewController(vc vc: UIViewController, title: String, imageName: String, selectedImage: String){
        vc.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImage))
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.redColor()], forState: .Highlighted)
        let nav = UINavigationController(rootViewController: vc)
        self.addChildViewController(nav)
    }
}
