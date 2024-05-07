//
//  CustomTabBarController.swift
//  Meddpicc App
//
//  Created by Asad Khan on 8/26/22.
//

import UIKit
import Foundation
class CustomTabBarController: UITabBarController,UITabBarControllerDelegate {
    
    let button = UIButton.init(type: .custom)
    var freshLaunch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        if freshLaunch == true {
            freshLaunch = false
            self.selectedIndex = 2 // 5th tab
        }
        
        setupUI()
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(named: "Home"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 32
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.clear.cgColor
        self.view.insertSubview(button, aboveSubview: self.tabBar)
        button.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
    }
    
    private func setupUI() {
        
        tabBar.tintColor = .gray
        tabBar.unselectedItemTintColor =  .white
        self.tabBar.isTranslucent = false
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIDevice().userInterfaceIdiom == .phone {
            if   (UIScreen.main.nativeBounds.size.height >= 2436) {
                // safe place to set the frame of button manually
                button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 110, width: 64, height: 64)
            }else {
                button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 80, width: 64, height: 64)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 2
        (selectedViewController as? UINavigationController)?.popToRootViewController(animated: true)
        if UIDevice().userInterfaceIdiom == .phone {
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}

