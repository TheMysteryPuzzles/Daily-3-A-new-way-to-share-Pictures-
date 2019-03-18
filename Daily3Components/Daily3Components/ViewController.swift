//
//  ViewController.swift
//  Daily3Components
//
//  Created by Work on 7/1/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let botomBarwidth = self.view.frame.width
        print("\(botomBarwidth)")
        let height = CGFloat(70)
        let y = self.view.frame.maxY - height
        print("\(y)")
        
        self.view.addSubview(CustomTabbar(frame: CGRect(x: 0, y: y, width: botomBarwidth, height: height)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class CustomTabbar: UITabBar{
    override func draw(_ rect: CGRect) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.backgroundColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.path = createPath().cgPath
        //shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1.0
        self.layer.insertSublayer(shapeLayer, at: 0)
    }
    
    func createPath() -> UIBezierPath {
        
        let radius = CGFloat(39.0)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (self.frame.width/2) - radius, y: 0))
        path.addArc(withCenter: CGPoint(x: (self.frame.width/2), y: 0), radius: radius, startAngle: CGFloat(M_PI), endAngle: CGFloat(0), clockwise: false)
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        draw(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



