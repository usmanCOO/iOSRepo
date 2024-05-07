//
//  UIView+Additions.swift
//  TradeAir
//
//  Created by Adeel on 17/09/2019.
//  Copyright © 2019 Buzzware. All rights reserved.
//

import UIKit

class UIView_Additions: NSObject {

}
extension UIView {
    enum roundingCorner {
        case top,bottom,left,right
    }

    func drawCorner(roundTo: roundingCorner){
        switch roundTo {
        case .top:
            return self.layer.maskedCorners =  [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        case .bottom:
            return self.layer.maskedCorners =  [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        case .left:
            return self.layer.maskedCorners =  [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        case .right:
            return self.layer.maskedCorners =  [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        
        }
    }
//    @IBInspectable
//    var backgroundImage: UIImage {
//        get {
//            return UIImage(named: "dashbg")!
//        }
//        set {
//            backgroundColor = UIColor.init(patternImage: newValue)
//        }
//    }
        @IBInspectable
        var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set {
                layer.cornerRadius = newValue
            }
        }
    
        @IBInspectable
        var borderWidth: CGFloat {
            get {
                return layer.borderWidth
            }
            set {
                layer.borderWidth = newValue
            }
        }
    
        @IBInspectable
        var borderColor: UIColor? {
            get {
                if let color = layer.borderColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                if let color = newValue {
                    layer.borderColor = color.cgColor
                } else {
                    layer.borderColor = nil
                }
            }
        }
    
        @IBInspectable
        var shadowRadius: CGFloat {
            get {
                return layer.shadowRadius
            }
            set {
                layer.shadowRadius = newValue
            }
        }
    
        @IBInspectable
        var shadowOpacity: Float {
            get {
                return layer.shadowOpacity
            }
            set {
                layer.shadowOpacity = newValue
            }
        }
    
        @IBInspectable
        var shadowOffset: CGSize {
            get {
                return layer.shadowOffset
            }
            set {
                layer.shadowOffset = newValue
            }
        }
    
        @IBInspectable
        var shadowColor: UIColor? {
            get {
                if let color = layer.shadowColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                if let color = newValue {
                    layer.shadowColor = color.cgColor
                } else {
                    layer.shadowColor = nil
                }
            }
        }
    @IBInspectable
    var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
}
extension UIView{
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    //
    func sunriseGradientBackground(_ direction: GradientDirection = .topBottom, startAlpha:CGFloat = 1, endAlpha:CGFloat = 1) {
        removeExistingGradientLayer()
        let gradient        = CAGradientLayer()
        gradient.name       = "gradient"
        gradient.masksToBounds  = true
        gradient.frame      = CGRect(origin: CGPoint.zero, size: CGSize(width: frame.width+500, height: frame.height))
        //        gradient.frame = self.frame
        
        
        //      135 Degree
        //        1st #007061 #009485 #00C4B0
        
        gradient.colors = [UIColor(hex: "#007061").cgColor,
                           UIColor(hex: "#009485").cgColor,
                           UIColor(hex: "#00C4B0").cgColor]
        
        gradient.locations  = [0,1,1]
        switch direction {
        case .topBottom: break
        case .leftRight: gradient.startPoint = CGPoint(x: 0, y: 0.5); gradient.endPoint = CGPoint(x: 1, y: 0.5)
        case .rightLeft: gradient.startPoint = CGPoint(x: 1, y: 0.5); gradient.endPoint = CGPoint(x: 0, y: 0.5)
        }
        layer.insertSublayer(gradient, at: 0)
    }
    
    func removeExistingGradientLayer() {
        if layer.sublayers != nil {
            for l in layer.sublayers! {
                if l is CAGradientLayer && (l as! CAGradientLayer).name == "gradient" {
                    (l as! CAGradientLayer).removeFromSuperlayer()
                }
            }
        }
    }
    
    func setGradient(colors: [CGColor], angle: Float = 0) {
        let gradientLayerView: UIView = UIView(frame: CGRect(x:0, y: 0, width: bounds.width, height: bounds.height))
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = gradientLayerView.bounds
        gradient.colors = colors
        
        let alpha: Float = angle / 360
        //        let startPointX = powf(
        //            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
        //            2
        //        )
        //        let startPointY = powf(
        //            sinf(2 * Float.pi * ((alpha + 0) / 2)),
        //            2
        //        )
        //        let endPointX = powf(
        //            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
        //            2
        //        )
        //        let endPointY = powf(
        //            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
        //            2
        //        )
        
        gradient.endPoint = CGPoint(x: CGFloat(0),y: CGFloat(0))
        gradient.startPoint = CGPoint(x: CGFloat(1), y: CGFloat(1))
        
        gradientLayerView.layer.insertSublayer(gradient, at: 0)
        layer.insertSublayer(gradientLayerView.layer, at: 0)
    }
    
    func makeCircle() {
        layer.cornerRadius      = max(frame.size.height, frame.size.width) / 2
        layer.masksToBounds     = true
    }
    
    class func autoHeight(_ view: UIView, constraint: NSLayoutConstraint) {
        constraint.constant = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat(MAXFLOAT))).height
    }
    
    class func autoWidth(_ view: UIView, constraint: NSLayoutConstraint) {
        constraint.constant = view.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: view.frame.size.height)).width
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        //        var bounds = self.bounds
        //        bounds.size.width = bounds.size.width + 50
        //        self.bounds = bounds
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {

        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}


extension UIView {
    
    enum UIViewFadeStyle {
        case bottom
        case top
        case left
        case right
        
        case vertical
        case horizontal
    }
    
    
     func addLinearGradientToView(view: UIView, colour: UIColor, transparntToOpaque: Bool, vertical: Bool) {
        let gradient = CAGradientLayer()
        let gradientFrame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        gradient.frame = gradientFrame

        var colours = [
            colour.withAlphaComponent(0.1).cgColor,
            colour.withAlphaComponent(0.1).cgColor,
            colour.withAlphaComponent(0.1).cgColor,
            colour.withAlphaComponent(0.1).cgColor,
            colour.withAlphaComponent(0.1).cgColor,
            colour.withAlphaComponent(0.1).cgColor,
            colour.withAlphaComponent(0.1).cgColor,
            colour.withAlphaComponent(0.1).cgColor,
            colour.withAlphaComponent(0.1).cgColor,
            colour.withAlphaComponent(0.1).cgColor,
            colour.withAlphaComponent(0.1).cgColor
        ]

        if transparntToOpaque == true {
            colours = colours.reversed()
        }
        if vertical == true {
            gradient.startPoint = CGPointMake(1, 0.5)
            gradient.endPoint = CGPointMake(1, 0.5)
        }
        gradient.colors = colours
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    
    
    func fadeView(style: UIViewFadeStyle = .vertical, percentage: Double = 0.07, color: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = color.cgColor as? [Any]
        //[UIColor.white.cgColor, UIColor.clear.cgColor]
        
        let startLocation = percentage
        let endLocation = 1 - percentage
        
        switch style {
        case .bottom:
            gradient.startPoint = CGPoint(x: 0.5, y: endLocation)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
        case .top:
            gradient.startPoint = CGPoint(x: 0.5, y: startLocation)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
            gradient.locations = [0.0, startLocation, endLocation, 1.0] as [NSNumber]
            
        case .left:
            gradient.startPoint = CGPoint(x: startLocation, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .right:
            gradient.startPoint = CGPoint(x: endLocation, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
            gradient.locations = [0.0, startLocation, endLocation, 1.0] as [NSNumber]
        }
        
        layer.mask = gradient
    }

}



extension UIView {

/**
 Simply zooming in of a view: set view scale to 0 and zoom to Identity on 'duration' time interval.

 - parameter duration: animation duration
 */
func zoomIn(duration: TimeInterval = 0.1) {
    self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
        self.transform = .identity
        }) { (animationCompleted: Bool) -> Void in
    }
}

/**
 Simply zooming out of a view: set view scale to Identity and zoom out to 0 on 'duration' time interval.

 - parameter duration: animation duration
 */
func zoomOut(duration : TimeInterval = 0.1) {
    self.transform = .identity
    UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (animationCompleted: Bool) -> Void in
    }
}

/**
 Zoom in any view with specified offset magnification.

 - parameter duration:     animation duration.
 - parameter easingOffset: easing offset.
 */
func zoomInWithEasing(duration: TimeInterval = 0.1, easingOffset: CGFloat = 0.1) {
    let easeScale = 1.0 + easingOffset
    let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
    let scalingDuration = duration - easingDuration
    UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
        self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = .identity
                }, completion: { (completed: Bool) -> Void in
            })
    })
}

/**
 Zoom out any view with specified offset magnification.

 - parameter duration:     animation duration.
 - parameter easingOffset: easing offset.
 */
func zoomOutWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
    let easeScale = 1.0 + easingOffset
    let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
    let scalingDuration = duration - easingDuration
    UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
        self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                }, completion: { (completed: Bool) -> Void in
            })
    })
}

}
