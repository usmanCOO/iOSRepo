//
//  PopupHelper.swift
//  AtlasMask
//
//  Created by Asad Khan on 5/19/22.
//

import UIKit
import Toast_Swift
//import SwiftEntryKit

class PopupHelper {
    /// Show a popup using the STPopup framework [STPopup on Cocoapods](https://cocoapods.org/pods/STPopup)
    /// - parameters:
    ///   - storyBoard: the name of the storyboard the popup viewcontroller will be loaded from
    ///   - popupName: the name of the viewcontroller in the storyboard to load
    ///   - viewController: the viewcontroller the popup will be popped up from
    ///   - blurBackground: boolean to indicate if the background should be blurred
    /// - returns: -
    static let sharedInstance = PopupHelper() //<- Singleton Instance
        private init() { /* Additional instances cannot be created */ }
    
    
  
    static func alertWithOk(title: String,message: String,controler:UIViewController){
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction.init(title: "Ok", style: .default) { (alertAction) in
            alertController.dismiss(animated: true, completion: nil)
            //controler.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(saveAction)
        controler.present(alertController, animated: true, completion: nil)
        
    
        
    }
    
    static func alertWithNetwork(title: String,message: String,controler:UIViewController){
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction.init(title: "Ok", style: .default) { (alertAction) in
         
        }
        let settinfAction = UIAlertAction.init(title: "Setting", style: .destructive) { (alertAction) in
            if let url = URL(string:"App-Prefs:root=WIFI") {
                if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                else{
                    if let url = URL(string:UIApplication.openSettingsURLString){
                        if UIApplication.shared.canOpenURL(url) {
                           UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    
                }
            }
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(settinfAction)
        controler.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    //Toast
    public static func showToast(message: String, duration: TimeInterval = 1.0) {
        let window = UIApplication.shared.keyWindow?.rootViewController
        window?.view.makeToast(message, duration: duration, position: .bottom)
    }
    
    
    class func showAnimating(_ controller:UIViewController){
        DispatchQueue.main.async {
            controller.startAnimating(CGSize(width: controller.view.frame.width/2, height: controller.view.frame.width/4), message: "Loading...", type: .ballTrianglePath , fadeInAnimation: nil)
        }
    }
    class func showAlertControllerWithError(forErrorMessage:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: (forErrorMessage?.isEmpty == true) ? "Error occurred":forErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }
    class func showAlertControllerWithErrorBack(forErrorMessage:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: (forErrorMessage?.isEmpty == true) ? "Error occurred":forErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { (action) in
            forViewController.navigationController?.popViewController(animated: true)
        }))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }
    class func showAlertControllerWithSucces(forErrorMessage:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: (forErrorMessage?.isEmpty == true) ? "Error occurred":forErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }
    class func showAlertControllerWithSuccessBack(forErrorMessage:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: (forErrorMessage?.isEmpty == true) ? "Error occurred":forErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { (action) in
            forViewController.navigationController?.popViewController(animated: true)
        }))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }
    class func showAlertControllerWithSuccessDismiss(Message:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: (Message?.isEmpty == true) ? "Error occurred":Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { (action) in
            forViewController.dismiss(animated: true)
        }))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }
    class func showAlertControllerWithSuccessBackRoot(forErrorMessage:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: (forErrorMessage?.isEmpty == true) ? "Error occurred":forErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { (action) in
            forViewController.navigationController?.popToRootViewController(animated: true)
        }))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }
    static func alertWithAppSetting(title: String,message: String,controler:UIViewController){
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction.init(title: "Ok", style: .default) { (alertAction) in
            
        }
        let settingAction = UIAlertAction.init(title: "Settings", style: .destructive) { (alertAction) in
            if let appSettings = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
              if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
              }
            }
        }
        alertController.addAction(okAction)
        alertController.addAction(settingAction)
        controler.present(alertController, animated: true, completion: nil)
        
    }

    class ActivityIndicator {
      static var shared = ActivityIndicator()

        var vSpinner: UIView?
        
        func showSpinner(onView : UIView) {
              let spinnerView = UIView.init(frame: onView.bounds)
              spinnerView.backgroundColor = UIColor.clear//UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
              let ai = UIActivityIndicatorView.init(style: .large)
              ai.color = .lightGray
              ai.startAnimating()
              ai.center = spinnerView.center
              DispatchQueue.main.async {
                spinnerView.addSubview(ai)
                onView.addSubview(spinnerView)
              }
            self.vSpinner = spinnerView
        }
        
        func removeSpinner() {
          DispatchQueue.main.async {
              self.vSpinner?.removeFromSuperview()
              self.vSpinner = nil
          }
        }
    }
    
    
    class CustomActivityIndicator: UIView {
        static var shared = CustomActivityIndicator()
        private convenience init() {
            self.init(frame: UIScreen.main.bounds)
        }
        
        private var spinnerBehavior: UIDynamicItemBehavior?
        private var animator: UIDynamicAnimator?
        private var imageView: UIImageView?
        private var loaderImageName = ""
            
        func show(with image: String = "logo") {
            loaderImageName = image
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
                if self?.imageView == nil {
                    self?.setupView()
                    DispatchQueue.main.async {[weak self] in
                        self?.showLoadingActivity()
                    }
                }
            }
        }
        
        func hide() {
            DispatchQueue.main.async {[weak self] in
                self?.stopAnimation()
            }
        }
        
        private func setupView() {
            center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
            
            let theImage = UIImage(named: loaderImageName)
            imageView = UIImageView(image: theImage)
            imageView?.frame = CGRect(x: self.center.x - 20, y: self.center.y - 20, width: 60, height: 60)
            
            if let imageView = imageView {
                self.spinnerBehavior = UIDynamicItemBehavior(items: [imageView])
            }
            animator = UIDynamicAnimator(referenceView: self)
        }
        
        private func showLoadingActivity() {
            if let imageView = imageView {
                addSubview(imageView)
                startAnimation()
                UIApplication.shared.windows.first?.addSubview(self)
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
        }
        
        private func startAnimation() {
            guard let imageView = imageView,
                  let spinnerBehavior = spinnerBehavior,
                  let animator = animator else { return }
            if !animator.behaviors.contains(spinnerBehavior) {
                spinnerBehavior.addAngularVelocity(8.0, for: imageView)
                animator.addBehavior(spinnerBehavior)
            }
        }
        
        private func stopAnimation() {
            animator?.removeAllBehaviors()
            imageView?.removeFromSuperview()
            imageView = nil
            self.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}

