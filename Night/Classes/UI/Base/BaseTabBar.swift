//
//  BaseTabBar.swift
//  Night
//
//  Created by Air. on 15/11/21.
//  Copyright © 2015年 Air. All rights reserved.
//

import UIKit

class BaseTabBar: UITabBar {

    // 按钮总数
    let buttonCount = 5
    
    // 懒加载
    lazy var composeBtn: UIButton = {
        let btn = UIButton(type: .Custom)
        btn.setImage(UIImage(named: "tab_publish_add"), forState: .Normal)
        btn.setImage(UIImage(named: "tab_publish_add_pressed"), forState: .Selected)
        
        // 添加监听方法
        btn.addTarget(self, action: "clickCompose", forControlEvents: .TouchUpInside)
        return btn
    }()
    
    /// 按钮回调
    var composeButtonClicked: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(composeBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(composeBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setButtonFrame()
    }
    
    ///  计算按钮位置
    func setButtonFrame() {
        // 计算基本属性
        let w = self.bounds.width / CGFloat(buttonCount)
        let h = self.bounds.height
        
        var index = 0
        // 遍历子视图
        for view in self.subviews {
            // 判断子视图是否为控件
            if view is UIControl && !(view is UIButton) {
                let r = CGRectMake(CGFloat(index) * w, 0, w, h)
                view.frame = r
                index++
                if index == 2 {
                    index++
                }
            }
        }
        // 设置加号按钮位置
        composeBtn.frame = CGRectMake(0, 0, w, h)
        composeBtn.center = CGPointMake(self.center.x, h * 0.5)
    }
    
    ///  按钮点击
    func clickCompose() {
        // 判断闭包是否被设置数值
        if composeButtonClicked != nil {
            composeButtonClicked!()
        }
    }
}
