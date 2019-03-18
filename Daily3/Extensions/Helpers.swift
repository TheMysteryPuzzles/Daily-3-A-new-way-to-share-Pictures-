//
//  Helpers.swift
//  Storify
//
//  Created by Work on 2/28/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCache(withUrl url: String){
    
          self.image = nil
        
        // RETREVING FROM CACHE
        if let cacheImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
           
            self.image = cacheImage
            return
        }
       
        // GOING ON NETWORK AND STROING IN CACHE
        let thisurl = URL(string: url)
        let request = URLRequest(url: thisurl!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: url as AnyObject)
                     imageCache.evictsObjectsWithDiscardedContent = false
                    self.image = downloadedImage
                }
            }
        }.resume()
    }
    
    func flipCurrentImage(with newImage: UIImage){
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: self, duration: 0.5, options: transitionOptions, animations: {
             self.image = newImage
        })
    }
}

extension UILabel {
    
    var isTruncated: Bool {
        
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
}

extension UIImage {
    func resizeImage(_ dimension: CGFloat) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio = size.width / size.height
        
        if aspectRatio > 1 {                            // Landscape image
            width = dimension
            height = dimension / aspectRatio
        } else {                                        // Portrait image
            height = dimension
            width = dimension * aspectRatio
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image { _ in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContext(CGSize(width: width, height: height))
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        return newImage
    }
    
    func resizeImage(_ dimension: CGFloat, with quality: CGFloat) -> Data? {
        return UIImageJPEGRepresentation(resizeImage(dimension), quality)
    }
}


extension UINavigationBar{
 
    func applyNavBarMainAppTheme(){
        let gradientLayer = CAGradientLayer()
       gradientLayer.colors = [hexStringToCGColor(hex: "#8E2DE2"),hexStringToCGColor(hex: "#4A00E0")]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 1)
        self.barStyle = .default
       // self.ba
    }
    
    private  func hexStringToCGColor (hex:String) -> CGColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray.cgColor
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
            ).cgColor
    }
    
}


extension UIView {
    
    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leadingAnchor
        } else {
            return self.leadingAnchor
        }
    }
    
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.trailingAnchor
        } else {
            return self.trailingAnchor
        }
    }
    
    
    var isSafeAnchorsAvailable: Bool {
        if #available(iOS 11.0, *) {
            return true
        } else {
            return false
        }
    }
    
    var safeCenterXAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.centerXAnchor
        } else {
            return self.centerXAnchor
        }
    }
    
    var safeCenterYAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.centerYAnchor
        } else {
            return self.centerYAnchor
        }
    }
    
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leftAnchor
        }else {
            return self.leftAnchor
        }
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.rightAnchor
        }else {
            return self.rightAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
}


extension UIView {
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func applyMainAppTheme(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [hexStringToCGColor(hex: "#8E2DE2"),hexStringToCGColor(hex: "#4A00E0")]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyCategoryLabelsTheme(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [hexStringToCGColor(hex: "#12c2e9"),hexStringToCGColor(hex: "#c471ed"),hexStringToCGColor(hex: "#f64f59")]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 1)
    }
    
    func applyHomeOptionsTheme(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [hexStringToCGColor(hex: "#B066FE"),hexStringToCGColor(hex: "#63E2FF")]
        gradientLayer.frame = self.bounds
        // gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        //  gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 1)
    }
    
    func applyTextHeadingsTheme(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [hexStringToCGColor(hex: "#B066FE"),hexStringToCGColor(hex: "#63E2FF")]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 1)
    }
    
    
    func applyBottomBarAppTheme(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [hexStringToCGColor(hex: "#ef32d9"),hexStringToCGColor(hex: "#89fffd")]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyBackgroundTheme(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [hexStringToCGColor(hex: "#B066FE"),hexStringToCGColor(hex: "#63E2FF")]
        /* gradientLayer.colors = [hexStringToCGColor(hex: "#0f0c29"),hexStringToCGColor(hex: "#302b63"),hexStringToCGColor(hex: "#24243e")]*/
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    private  func hexStringToCGColor (hex:String) -> CGColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray.cgColor
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
            ).cgColor
    }
    
    
    func addMask(_ bezierPath: UIBezierPath, frame: CGRect) {
        let pathMask = CAShapeLayer()
        pathMask.frame = frame
        pathMask.path = bezierPath.cgPath
        
        layer.mask = pathMask
        
    }
}
