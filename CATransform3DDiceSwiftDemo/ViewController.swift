//
//  ViewController.swift
//  CATransform3DDiceSwiftDemo
//
//  Created by 冯文秀 on 2017/5/18.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let diceView = UIView()
    
    // 来源网址 http://www.cocoachina.com/swift/20170518/19305.html
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        addDiceView()
        
        // 用UIPanGestureRecognizer来识别手势
        let panGensture = UIPanGestureRecognizer.init(target: self, action: #selector(viewTransform))
        diceView.addGestureRecognizer(panGensture)
    }
    
    func addDiceView() {
        let viewFrame = UIScreen.main.bounds
        diceView.frame = CGRect(x:0, y:viewFrame.maxY/2 - 50, width:viewFrame.width, height:100)
       
        var diceTransform = CATransform3DIdentity
        
        // 利用 CATransform3DTranslate 与 CATransform3DRotate 来做出立体对象的效果，首先做骰子的 1、2、3 点。
        
        // 1
        let dice1 = UIImageView.init(image: UIImage(named: "dice1.jpg"))
        dice1.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, 50)
        dice1.layer.transform = diceTransform
        
        // CATransform3DRotate 不是只有转了影像，而是整个坐标系统，所以只需要每个面的 z 轴都增加(减少) 50 就能够做一半的正方体
        
        //6
        let dice6 = UIImageView.init(image: UIImage(named: "dice6.jpg"))
        dice6.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, -50)
        dice6.layer.transform = diceTransform
        
        
        // 加入骰子第 2、3 点，并分别垂直于 1 点
        // 2
        let dice2 = UIImageView.init(image: UIImage(named: "dice2.jpg"))
        dice2.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        
        // CATransform3D 的方法都是输入一个矩阵去改变内容。
        // 以 CATransform3DRotate 为例，第一个参数是定义好的矩阵，之后再用角度与 x、y、z 所形成的向量做旋转
        diceTransform = CATransform3DRotate(CATransform3DIdentity, (CGFloat.pi/2), 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, 50)
        dice2.layer.transform = diceTransform
        
        //5
        let dice5 = UIImageView.init(image: UIImage(named: "dice5.jpg"))
        dice5.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, (-CGFloat.pi / 2), 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, 50)
        dice5.layer.transform = diceTransform
    
        // 3
        let dice3 = UIImageView.init(image: UIImage(named: "dice3.jpg"))
        dice3.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, (-CGFloat.pi/2), 1, 0, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, 50)
        dice3.layer.transform = diceTransform
        
        //4
        let dice4 = UIImageView.init(image: UIImage(named: "dice4.jpg"))
        dice4.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, (CGFloat.pi / 2), 1, 0, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, 50)
        dice4.layer.transform = diceTransform
        
        
        diceView.addSubview(dice1)
        diceView.addSubview(dice2)
        diceView.addSubview(dice3)
        diceView.addSubview(dice4)
        diceView.addSubview(dice5)
        diceView.addSubview(dice6)

        view.addSubview(diceView)
    }
    
    
    
    func viewTransform(sender: UIPanGestureRecognizer) {
        var angle = CGPoint.init(x: 0, y: 0)
        
        let point = sender.translation(in: diceView)
        let angleX = angle.x + (point.x / 30)
        let angleY = angle.y - (point.y / 30)
        
        
        var transform = CATransform3DIdentity
        // 真实世界中，物体远离我们时，看起来变小，远的边会比近的边短，但对系统来说他们是一样长的，所以要做一些修正
        // 透过设置 CATransform3D 的 m34 为 -1.0 / d 来让影像有远近的 3D 效果，d 代表了想象中视角与屏幕的距离，这个距离只需要大概估算，不需要很精准的计算
        transform.m34 = -1 / 500      // m34 用于按比例缩放 x 和 y 的值来呈现视角的远近
        
        
        // 用 CATransform3DRotate 的方法对 X 轴与 Y 轴做转动，
        transform = CATransform3DRotate(transform, angleX, 0, 1, 0)
        transform = CATransform3DRotate(transform, angleY, 1, 0, 1)
        // View 需要用手势移动当作依据，所以不直接对这个 View 做旋转，而是旋转 View 里面的 sublayer，layer 里面的有个方法可以实作这个功能 sublayerTransform ，并把内容以 subView 的方式加入，然后把 blueView 的 backgroundColor 拿掉，这样就能很正常的转动了。
        diceView.layer.sublayerTransform = transform
        
        
        // 以手势在 View 上每次移动的相对坐标为基准（即是sender.translation(in: blueView))，直接去更改整个 View 的翻转角度
        if sender.state == .ended {
            angle.x = angleX
            angle.y = angleY
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

