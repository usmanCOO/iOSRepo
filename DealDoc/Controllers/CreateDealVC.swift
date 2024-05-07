//
//  CreateDealVC.swift
//  Meddpicc App
//
//  Created by Asad Khan on 9/1/22.
//

import UIKit
import Alamofire
class CreateDealVC: UIViewController {
    
    var isHome: Bool?
    var createDealResponse: CreateDealResponse?
    @IBOutlet weak var createDealTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func saveButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
        if !createDealTextField.text!.isEmpty {
         //   createDeal(dealName: createDealTextField.text!)
        }else {
            PopupHelper.showToast(message: "Enter Deal Name")
        }
       
    }
    
    @IBAction func cancelButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
        self.navigationController?.popViewController(animated: true)
            //dismiss(animated: true)
    }
    
    
}
